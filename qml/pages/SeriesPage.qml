import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: seriesPage

    property variant series: undefined

    property bool isUpdating: false
    property bool hasChanged: false

    function getRandomNumber(min, max) {
        return Math.random() * (max - min) + min;
    }

    function update() {
        python.call('seriesfinale.seriesfinale.series_manager.get_series_list', [], function(result) {
            // Clear the data in the list model
            seriesList.clear();
            // Load the received data into the list model
            for (var i=0; i<result.length; i++) {
                seriesList.append(result[i]);
            }
            series = seriesList;
            hasChanged = false;
            coverImage = seriesList.get(getRandomNumber(0, result.length)).coverImage;
        });

        python.call('seriesfinale.seriesfinale.settingsWrapper.getSortByGenre', [], function(result) {
            if (result) {
                listView.section.property = "showGenre"
            } else {
                listView.section.property = ""
            }
        })
    }

    onStatusChanged: {
        if (status === PageStatus.Activating && hasChanged) {
            update();
        }
    }

    Connections {
        target: python

        onLoadingChanged: {
            seriesPage.isUpdating = loading;
            if(!loading) {
                update();
            }
        }

        onUpdatingChanged: {
            seriesPage.isUpdating = updating;
            if(!updating) {
                update();
            }
        }


        onCoverImageChanged: update()
        onEpisodesListUpdated: {
            update()
        }
        onInfoMarkupChanged: hasChanged = true
    }

    SilicaListView {
        id: listView
        anchors.fill: parent
        spacing: Theme.paddingMedium

        // PullDownMenu
        PullDownMenu {
            MenuItem {
                text: "About"
                onClicked: pageStack.push(aboutComponent.createObject(pageStack))
                Component { id: aboutComponent; AboutPage {} }
            }
            MenuItem {
                text: "Settings"
                onClicked: pageStack.push(settingsComponent.createObject(pageStack))
                Component { id: settingsComponent; SettingsPage {} }
            }
            MenuItem {
                text: "Refresh"
                visible: seriesList.count != 0
                onClicked: python.call('seriesfinale.seriesfinale.series_manager.update_all_shows_episodes', [])
            }
            MenuItem {
                text: "Add Show"
                visible: !seriesPage.isUpdating
                onClicked: { pageStack.push(addShowComponent.createObject(pageStack)) }
                Component { id: addShowComponent; AddShow {} }
            }
        }

        header: PageHeader {
            id: header
            title: "SeriesFinale"
        }

        model: ListModel {
            id: seriesList
        }

        section.property: ""
        section.criteria: ViewSection.FullString
        section.delegate: SectionHeader {
            text: section
        }

        delegate: ListRowDelegate {
            id: listDelegate

            title: model.showName
            subtitle: model.infoMarkup
            iconSource: model.coverImage
            Component {
                id: showPageComponent
                ShowPage { show: model }
            }

            Component {
                id: contextMenu
                ContextMenu {
                    MenuItem {
                        text: "Delete show";
                        onClicked: showRemorseItem()
                    }
                }
            }

            RemorseItem { id: remorse }
            function showRemorseItem() {
                remorse.execute(listDelegate, "Deleting", function() {
                    python.call('seriesfinale.seriesfinale.series_manager.delete_show_by_name', [model.showName]);
                    seriesPage.update();
                })
            }

            onClicked: {
                pageStack.push(showPageComponent.createObject(pageStack));
            }
        }

        ViewPlaceholder {
            id: emptyText
            text: 'No shows'
            enabled: seriesList.count == 0 && !seriesPage.isUpdating
        }

        BusyIndicator {
            id: loadingIndicator
            visible: seriesPage.isUpdating
            running: visible
            anchors.centerIn: parent
            size: BusyIndicatorSize.Large
        }

        VerticalScrollDecorator {}
    }
}
