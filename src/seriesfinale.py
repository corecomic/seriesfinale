#!/usr/bin/env python3
# -*- coding: utf-8 -*-

###########################################################################
#    SeriesFinale
#    Copyright (C) 2015 Core Comic <core.comic@gmail.com>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
###########################################################################

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

    def getSortByGenre(self):
        return Settings().getConf(Settings.SHOWS_SORT_BY_GENRE)
    def setSortByGenre(self, add):
        Settings().setConf(Settings.SHOWS_SORT_BY_GENRE, add)

    def getSearchLanguage(self):
        return Settings().getConf(Settings.SEARCH_LANGUAGE)
    def setSearchLanguage(self, language):
        Settings().setConf(Settings.SEARCH_LANGUAGE, language)

    def getUpdateEndedShows(self):
        return Settings().getConf(Settings.UPDATE_ENDED_SHOWS)
    def setUpdateEndedShows(self, add):
        Settings().setConf(Settings.UPDATE_ENDED_SHOWS, add)

    def getLastCompleteUpdate(self):
        return Settings().getConf(Settings.LAST_COMPLETE_UPDATE)
    def setLastCompleteUpdate(self, date):
        Settings().setConf(Settings.LAST_COMPLETE_UPDATE, date)

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

    def getVersion(self):
        return self.version

    def getStatistics(self):
        n_series = len(self.series_manager.series_list)
        n_series_watched = 0
        n_series_ended = 0
        n_all_episodes = 0
        n_episodes_to_watch = 0
        time_watched = 0
        for i in range(n_series):
            show = self.series_manager.series_list[i]
            episodes = show.episode_list
            aired_episodes = [episode for episode in episodes \
                              if episode.already_aired()]
            episodes_to_watch = [episode for episode in aired_episodes \
                                 if not episode.watched]
            n_all_episodes += len(aired_episodes)
            if episodes_to_watch:
                n_episodes_to_watch += len(episodes_to_watch)
            else:
                n_series_watched += 1
            if show.runtime:
                time_watched += (len(aired_episodes)-len(episodes_to_watch))*int(show.runtime)
            if show.status and show.status == 'Ended':
                n_series_ended += 1
        return {'numSeries': n_series,
                'numSeriesWatched': n_series_watched,
                'numSeriesEnded': n_series_ended,
                'numEpisodes': n_all_episodes,
                'numEpisodesWatched': n_all_episodes-n_episodes_to_watch,
                'timeWatched': time_watched}

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
        # Wait for the saving thread to complete.
        async_worker.join()

    def saveSettings(self):
        self.settings.save(constants.SF_CONF_FILE)

    def _settings_load_finished(self, dummy_arg, error):
        #self.series_manager.sorted_series_list.resort()
        pass

    def _load_finished(self, dummy_arg, error):
        self.request = None
        self.series_manager.auto_save(False)

    def _save_finished_cb(self, dummy_arg, error):
        logging.debug('All saved!')

seriesfinale = SeriesFinale()
#pyotherside.atexit(seriesfinale.closeEvent()) #FIXME: not working on sailfish os
