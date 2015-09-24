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

class SortedSeriesList():

    def __init__(self, settings, parent=None):
        self._settings = settings
        self.sortOrder = self._settings.getConf(self._settings.SHOWS_SORT)
        self.hideCompleted = self._settings.getConf(self._settings.HIDE_COMPLETED_SHOWS)
        self.setDynamicSortFilter(True)
        self.sort(0)

    def resort(self):
        self.sortOrder = self._settings.getConf(self._settings.SHOWS_SORT)
        self.hideCompleted = self._settings.getConf(self._settings.HIDE_COMPLETED_SHOWS)
        self.invalidate()

    def filterAcceptsRow(self, sourceRow, sourceParent):
        if not self.hideCompleted:
            return True

        index = self.sourceModel().index(sourceRow, 0, sourceParent)
        show = self.sourceModel().data(index)
        return not show.is_completely_watched()

    def lessThan(self, left, right):
        leftData = self.sourceModel().data(left)
        rightData = self.sourceModel().data(right)
        if (self.sortOrder != self._settings.RECENT_EPISODE):
            return str(leftData) < str(rightData)
        leftEpisodes = leftData.get_episodes_info()
        rightEpisodes = rightData.get_episodes_info()
        episode1 = leftEpisodes['next_episode']
        episode2 = rightEpisodes['next_episode']
        if not episode1:
            return str(leftData) < str(rightData)
        if not episode2:
            if episode1:
                return True
        most_recent = (episode1 or episode2).get_most_recent(episode2)
        if not most_recent:
            return str(leftData) < str(rightData)
        return episode1 == most_recent

class SortedSeasonsList():

    def __init__(self, list, settings, parent=None):
        QtGui.QSortFilterProxyModel.__init__(self, parent)
        self._settings = settings
        self.setDynamicSortFilter(True)
        self.sortOrder = self._settings.getConf(self._settings.SEASONS_ORDER_CONF_NAME)
        self.sort(0)
        self.setSourceModel(list)

    def lessThan(self, left, right):
        if (self.sortOrder == self._settings.DESCENDING_ORDER):
            return int(self.sourceModel().data(left)) > int(self.sourceModel().data(right))
        return int(self.sourceModel().data(left)) < int(self.sourceModel().data(right))

class SortedEpisodesList():

    def __init__(self, list, settings, parent=None):
        QtGui.QSortFilterProxyModel.__init__(self, parent)
        self._settings = settings
        self.setDynamicSortFilter(True)
        self.sortOrder = self._settings.getConf(self._settings.EPISODES_ORDER_CONF_NAME)
        self.sort(0)
        self.setSourceModel(list)

    def lessThan(self, left, right):
        if (self.sortOrder == self._settings.DESCENDING_ORDER):
            return self.sourceModel().data(left).episode_number > self.sourceModel().data(right).episode_number
        return self.sourceModel().data(left).episode_number < self.sourceModel().data(right).episode_number
