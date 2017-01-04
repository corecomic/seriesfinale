import QtQuick 2.0
import Sailfish.Silica 1.0


Dialog {
    id: settingsDialog

    onAccepted: {
        python.call('seriesfinale.seriesfinale.settingsWrapper.setShowsSort', [showSorting.currentIndex])
        python.call('seriesfinale.seriesfinale.settingsWrapper.setSortByGenre', [sortByGenreSwitch.checked])
        python.call('seriesfinale.seriesfinale.settingsWrapper.setSortByPrio', [sortByPrioSwitch.checked])
        python.call('seriesfinale.seriesfinale.settingsWrapper.setSeasonsOrder', [seasonSorting.currentIndex])
        python.call('seriesfinale.seriesfinale.settingsWrapper.setEpisodesOrder', [episodeSorting.currentIndex])
        python.call('seriesfinale.seriesfinale.settingsWrapper.setAddSpecialSeasons', [specialSeasonsSwitch.checked])
        python.call('seriesfinale.seriesfinale.settingsWrapper.setUpdateEndedShows', [updateEndedShowsSwitch.checked])
        python.call('seriesfinale.seriesfinale.settingsWrapper.setHighlightSpecial', [highlightSpecialSwitch.checked])
        python.call('seriesfinale.seriesfinale.saveSettings', [])
    }

    Component.onCompleted: {
        python.call('seriesfinale.seriesfinale.settingsWrapper.getShowsSort', [], function(result) {
            showSorting.currentIndex = result;
        })
        python.call('seriesfinale.seriesfinale.settingsWrapper.getSortByGenre', [], function(result) {
            sortByGenreSwitch.checked = result;
        })
        python.call('seriesfinale.seriesfinale.settingsWrapper.getSortByPrio', [], function(result) {
            sortByPrioSwitch.checked = result;
        })
        python.call('seriesfinale.seriesfinale.settingsWrapper.getSeasonsOrder', [], function(result) {
            seasonSorting.currentIndex = result;
        })
        python.call('seriesfinale.seriesfinale.settingsWrapper.getEpisodesOrder', [], function(result) {
            episodeSorting.currentIndex = result;
        })
        python.call('seriesfinale.seriesfinale.settingsWrapper.getAddSpecialSeasons', [], function(result) {
            specialSeasonsSwitch.checked = result;
        })
        python.call('seriesfinale.seriesfinale.settingsWrapper.getUpdateEndedShows', [], function(result) {
            updateEndedShowsSwitch.checked = result;
        })
        python.call('seriesfinale.seriesfinale.settingsWrapper.getHighlightSpecial', [], function(result) {
            highlightSpecialSwitch.checked = result;
        })
        seriesPage.hasChanged = true
    }

    SilicaFlickable {
        id: content
        anchors.fill: parent

        contentWidth: grid.width
        contentHeight: grid.height

        VerticalScrollDecorator { flickable: flickable }

        Column {
            id: grid

            width: settingsDialog.width
            spacing: Theme.paddingLarge

            DialogHeader {
                title: qsTr("Settings")
                acceptText: qsTr("Save")
            }

            SectionHeader {
                text: qsTr("Sorting")
            }

            ComboBox {
                id: showSorting
                label: qsTr("Show sorting")
                menu: ContextMenu {
                    id: showSortingMenu
                    MenuItem { text: qsTr("By title"); }
                    MenuItem { text: qsTr("By next episode date"); }
                    MenuItem { text: qsTr("By last aired episode"); }
                }
            }

            ComboBox {
                id: seasonSorting
                label: qsTr("Seasons sorting")
                menu: ContextMenu {
                    id: seasonSortingMenu
                    MenuItem { text: "1-9"; }
                    MenuItem { text: "9-1"; }
                }
            }

            ComboBox {
                id: episodeSorting
                label: qsTr("Episode sorting")
                menu: ContextMenu {
                    id: episodeSortingMenu
                    MenuItem { text: "1-9"; }
                    MenuItem { text: "9-1"; }
                }
            }

            TextSwitch {
                id: sortByGenreSwitch
                text: qsTr("Sort by genre")
            }

            TextSwitch {
                id: sortByPrioSwitch
                text: qsTr("Sort by priority")
            }

            SectionHeader {
                text: qsTr("Other")
            }

            TextSwitch {
                id: specialSeasonsSwitch
                text: qsTr("Add special seasons")
            }

            TextSwitch {
                id: updateEndedShowsSwitch
                text: qsTr("Update ended shows")
            }

            TextSwitch {
                id: highlightSpecialSwitch
                text: qsTr("Highlight season premiere")
            }
        }
    }
}
