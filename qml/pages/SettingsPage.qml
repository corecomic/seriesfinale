import QtQuick 2.0
import Sailfish.Silica 1.0


Dialog {
    id: settingsDialog

    onAccepted: {
        python.call('seriesfinale.seriesfinale.settingsWrapper.setShowsSort', [showSorting.currentIndex])
        python.call('seriesfinale.seriesfinale.settingsWrapper.setSortByGenre', [sortByGenreSwitch.checked])
        python.call('seriesfinale.seriesfinale.settingsWrapper.setSeasonsOrder', [seasonSorting.currentIndex])
        python.call('seriesfinale.seriesfinale.settingsWrapper.setEpisodesOrder', [episodeSorting.currentIndex])
        python.call('seriesfinale.seriesfinale.settingsWrapper.setAddSpecialSeasons', [specialSeasonsSwitch.checked])
        python.call('seriesfinale.seriesfinale.saveSettings', [])
    }

    Component.onCompleted: {
        python.call('seriesfinale.seriesfinale.settingsWrapper.getShowsSort', [], function(result) {
            showSorting.currentIndex = result;
        })
        python.call('seriesfinale.seriesfinale.settingsWrapper.getSortByGenre', [], function(result) {
            sortByGenreSwitch.checked = result;
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
        seriesPage.hasChanged = true
    }

    SilicaFlickable {
        id: content
        anchors.fill: parent

        contentWidth: grid.width
        contentHeight:  grid.height

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
                text: "Sorting"
            }

            ComboBox {
                id: showSorting
                label: qsTr("Show sorting")
                menu: ContextMenu {
                    id: showSortingMenu
                    MenuItem { text: "By title"; }
                    MenuItem { text: "By next episode date"; }
                    MenuItem { text: "By last aired episode"; }
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

            SectionHeader {
                text: ""
            }

            TextSwitch {
                id: specialSeasonsSwitch
                text: qsTr("Add special seasons")
            }
        }
    }
}
