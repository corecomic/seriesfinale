import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: showPage
    property variant show: undefined

    property bool isUpdating: false
    property bool hasChanged: false


    function update() {
        python.call('seriesfinale.seriesfinale.series_manager.get_seasons_list', [show.showName], function(result) {
            // Clear the data in the list model
            seasonList.clear();
            // Load the received data into the list model
            for (var i=0; i<result.length; i++) {
                seasonList.append(result[i]);
            }
            hasChanged = false;
        });
    }

    Component.onCompleted: update()

    onShowChanged: {}
    onStatusChanged: {
        if (status === PageStatus.Activating && hasChanged) {
            update();
        }
    }


    Connections {
        target: python

        onShowUpdatingChanged: {
            showPage.isUpdating = updating;
            if(!updating) {
                update();
            }
        }

        onEpisodesListUpdated: update()
        onInfoMarkupChanged: hasChanged = true

        //onShowArtChanged: delegate.iconSource = show.get_season_image(model.data)

        //onInfoMarkupChanged: {
        //    delegate.subtitle = show.get_season_info_markup(model.data)
        //    markAllItem.text = show.is_completely_watched(model.data) ? 'Mark None' : 'Mark All'
        //}
    }

    Dialog {
        id: showInfoDialog

        SilicaFlickable {
            id: content
            anchors.fill: parent

            contentWidth: grid.width
            contentHeight:  grid.height

            VerticalScrollDecorator { flickable: flickable }

            Column {
                id: grid

                width: showInfoDialog.width
                spacing: Theme.paddingLarge

                PageHeader {
                    title: show.showName
                }

                Image {
                    id: showCover
                    source: show.coverImage
                    height: 300
                    fillMode: "PreserveAspectFit"
                    smooth: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    id: showInfoDescription
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - 2*Theme.paddingLarge
                    text: show.showOverview
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.secondaryColor
                    wrapMode: Text.Wrap
                }
            }
        }
    }


    SilicaListView {
        id: listView
        anchors.fill: parent

        // PullDownMenu
        PullDownMenu {
            MenuItem {
                text: "Info"
                onClicked: showInfoDialog.open()
            }
            MenuItem {
                text: "Refresh"
                visible: false
                onClicked: python.call('seriesfinale.seriesfinale.series_manager.update_show_by_name', [show.showName])
            }
        }

        header: PageHeader {
            id: header
            title: show.showName
        }

        model: ListModel {
            id: seasonList
        } //show.get_seasons_model()

        delegate: ListRowDelegate {
            id: listDelegate

            title: model.seasonName
            subtitle: model.seasonInfoMarkup
            iconSource: model.seasonImage

            Component {
                id: seasonPageComponent
                SeasonPage { show: showPage.show; season: model }
            }
            Component {
                id: contextMenu
                ContextMenu {
                    MenuItem {
                        id: markAllItem
                        text: model.isWatched ? 'Mark None' : 'Mark All'
                        onClicked: {
                            if (model.isWatched) {
                                python.call('seriesfinale.seriesfinale.series_manager.mark_all_episodes_watched', [false, showPage.show.showName, model.seasonNumber])
                            } else {
                                python.call('seriesfinale.seriesfinale.series_manager.mark_all_episodes_watched', [true, showPage.show.showName, model.seasonNumber])
                            }
                            showPage.update()
                        }
                    }
                    MenuItem {
                        text: "Delete season";
                        onClicked: showRemorseItem()
                    }
                }
            }

            RemorseItem { id: remorse }
            function showRemorseItem() {
                remorse.execute(listDelegate, "Deleting", function() {
                    python.call('seriesfinale.seriesfinale.series_manager.delete_season', [showPage.show.showName, model.seasonNumber]);
                    seasonList.remove(index);
                })
            }

            onClicked: pageStack.push(seasonPageComponent.createObject(pageStack))
        }

        ViewPlaceholder {
            id: emptyText
            text: 'No seasons'
            enabled: seasonList.count == 0 && !showPage.isUpdating
        }

        BusyIndicator {
            id: loadingIndicator
            visible: showPage.isUpdating
            running: visible
            anchors.centerIn: parent
            size: BusyIndicatorSize.Large
        }

        VerticalScrollDecorator {}
    }
}
