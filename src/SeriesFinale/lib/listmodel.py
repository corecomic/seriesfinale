# -*- coding: utf-8 -*-

###########################################################################
#    SeriesFinale
#    Copyright (C) 2009 Joaquim Rocha <jrocha@igalia.com>
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

from datetime import datetime

class ListModel():
    def __init__(self, items = [], parent = None):
        self._items = items
        self.setRoleNames({0: 'data'})

    def append(self, show):
        self._items.append(show)

    def clear(self):
        if not self._items:
            return
        self._items = []

    def columnCount(self):
        return 1

    def rowCount(self):
        return len(self._items)

    def data(self, index):
        if (index-1 > rowCount()):
            return
        return self._items[index]

    def list(self):
        return self._items

    def __len__(self):
        return self.rowCount()

    def __delitem__(self, index):
        del self._items[index]

    def __getitem__(self, key):
        return self._items[key]

def SortedSeriesList(series_list, settings):
        sortOrder = settings.getConf(settings.SHOWS_SORT)
        sortByGenre = settings.getConf(settings.SHOWS_SORT_BY_GENRE)
        hideCompleted = settings.getConf(settings.HIDE_COMPLETED_SHOWS)

        sorted_list = series_list

        if sortOrder == settings.RECENT_EPISODE:
            sorted_list = sorted(series_list, key=lambda k: k['nextToWatch']
                if (k and k['nextToWatch'])
                else datetime.max.date())
        elif sortOrder == settings.LAST_AIRED_EPISODE:
            sorted_list = sorted(series_list, key=lambda k: k['lastAired']
                if (k and k['lastAired'])
                else datetime.min.date(), reverse=True)
        elif sortOrder == settings.ALPHABETIC_ORDER:
            sorted_list = sorted(series_list, key=lambda k: k['showName'])
        else:
            sorted_list = series_list

        if sortByGenre:
            sorted_list = sorted(sorted_list, key=lambda k: k['showGenre'])

        return sorted_list


def SortedSeasonsList(season_list, settings):
    sortOrder = settings.getConf(settings.SEASONS_ORDER_CONF_NAME)
    if (sortOrder == settings.DESCENDING_ORDER):
        return list(reversed(season_list))
    return season_list


def SortedEpisodesList(episode_list, settings):
    sortOrder = settings.getConf(settings.EPISODES_ORDER_CONF_NAME)
    if (sortOrder == settings.DESCENDING_ORDER):
        return list(reversed(episode_list))
    return episode_list
