#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import pyotherside
import time
import gettext
import locale
import os
import logging

from SeriesFinale.series import SeriesManager, Show, Episode
from SeriesFinale.lib import constants
from SeriesFinale.settings import Settings
from SeriesFinale.asyncworker import AsyncWorker, AsyncItem

class SettingsWrapper():
    def __init__(self, parent=None):
        pass

    def getAddSpecialSeasons(self):
        return Settings().getConf(Settings.ADD_SPECIAL_SEASONS)
    def setAddSpecialSeasons(self, add):
        Settings().setConf(Settings.ADD_SPECIAL_SEASONS, add)

    def getHideCompletedShows(self):
        return Settings().getConf(Settings.HIDE_COMPLETED_SHOWS)
    def setHideCompletedShows(self, add):
        Settings().setConf(Settings.HIDE_COMPLETED_SHOWS, add)

    def getEpisodesOrder(self):
        return Settings().getConf(Settings.EPISODES_ORDER_CONF_NAME)
    def setEpisodesOrder(self, newOrder):
        Settings().setConf(Settings.EPISODES_ORDER_CONF_NAME, newOrder)

    def getSeasonsOrder(self):
        return Settings().getConf(Settings.SEASONS_ORDER_CONF_NAME)
    def setSeasonsOrder(self, newOrder):
        Settings().setConf(Settings.SEASONS_ORDER_CONF_NAME, newOrder)

    def getShowsSort(self):
        return Settings().getConf(Settings.SHOWS_SORT)
    def setShowsSort(self, newOrder):
        Settings().setConf(Settings.SHOWS_SORT, newOrder)

class SeriesFinale:
    def __init__(self):
        # i18n
        languages = []
        lc, encoding = locale.getdefaultlocale()
        if lc:
            languages = [lc]
        languages += constants.DEFAULT_LANGUAGES
        gettext.bindtextdomain(constants.SF_COMPACT_NAME,
                               constants.LOCALE_DIR)
        gettext.textdomain(constants.SF_COMPACT_NAME)
        language = gettext.translation(constants.SF_COMPACT_NAME,
                                       constants.LOCALE_DIR,
                                       languages = languages,
                                       fallback = True)
        _ = language.gettext

        self.series_manager = SeriesManager()
        self.settings = Settings()
        self.settingsWrapper = SettingsWrapper()

        load_conf_item = AsyncItem(self.settings.load,
                                   (constants.SF_CONF_FILE,),
                                   self._settings_load_finished)
        load_shows_item = AsyncItem(self.series_manager.load,
                                    (constants.SF_DB_FILE,),
                                    self._load_finished)

        self.request = AsyncWorker(True)
        self.request.queue.put(load_conf_item)
        self.request.queue.put(load_shows_item)
        self.request.start()

        self.version = constants.SF_VERSION

        #pyotherside.atexit(self.closeEvent())

    def getVersion(self):
        return self.version

    def closeEvent(self):
        # If the shows list is empty but the user hasn't deleted
        # any, then we don't save in order to avoid overwriting
        # the current db (for the shows list might be empty due
        # to an error)
        logging.debug('Going down...')
        if not self.series_manager.series_list and not self.series_manager.have_deleted:
            return
        self.series_manager.auto_save(False)

        save_shows_item = AsyncItem(self.series_manager.save,
                               (constants.SF_DB_FILE,))
        save_conf_item = AsyncItem(self.settings.save,
                               (constants.SF_CONF_FILE,),
                               self._save_finished_cb)
        async_worker = AsyncWorker(False)
        async_worker.queue.put(save_shows_item)
        async_worker.queue.put(save_conf_item)
        async_worker.start()

    def saveSettings(self):
        self.settings.save(constants.SF_CONF_FILE)

    def _settings_load_finished(self, dummy_arg, error):
        #self.series_manager.sorted_series_list.resort()
        pass

    def _load_finished(self, dummy_arg, error):
        self.request = None
        self.series_manager.auto_save(False)

    def _save_finished_cb(self, dummy_arg, error):
        pass

seriesfinale = SeriesFinale()
#pyotherside.atexit(seriesfinale.closeEvent()) #FIXME not working on sailfish os
