import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: seasonPage
    property variant season: undefined
    property variant show: undefined

    property bool isUpdating: false

    function update() {
        python.call('seriesfinale.seriesfinale.series_manager.get_episodes_list', [show.showName, season.seasonNumber], function(result) {
            // Clear the data in the list model
            episodesList.clear();
            // Load the received data into the list model
            for (var i=0; i<result.length; i++) {
                episodesList.append(result[i]);
            }
        });
    }

    Component.onCompleted: update()

    onSeasonChanged:{}
    onShowChanged: {}

    Connections {
        target: python

        onInfoMarkupChanged: {
            update();
        }

    }

    SilicaListView {
        id: listView
        anchors.fill: parent

        // PullDownMenu
        PullDownMenu {
            MenuItem {
                id: menuMarkAll
                visible: !season.isWatched
                text: "Mark all"
                onClicked: {
                    python.call('seriesfinale.seriesfinale.series_manager.mark_all_episodes_watched', [true, seasonPage.show.showName, season.seasonNumber]);
                }
            }
            MenuItem {
                id: menuMarkNone
                visible: season.isWatched
                text: "Mark none"
                onClicked: {
                    python.call('seriesfinale.seriesfinale.series_manager.mark_all_episodes_watched', [false, seasonPage.show.showName, season.seasonNumber]);
                }
            }
        }

        header: PageHeader {
            id: header
            title: show.showName + ' - ' + season.seasonName
        }

        model: ListModel {
            id:episodesList
        } // show.get_sorted_episode_list_by_season(season)

        delegate: EpisodeListRowDelegate {
            episode: model
            Component {
                id: episodePageComponent
                EpisodePage {
                    show: seasonPage.show;
                    episode: model;
                    seasonImg: season.seasonImage
                }
            }
            onClicked: pageStack.push(episodePageComponent.createObject(pageStack))
            onWatchToggled: {
                python.call('seriesfinale.seriesfinale.series_manager.set_episode_watched', [watched, seasonPage.show.showName, model.episodeName]);
            }
        }

        ViewPlaceholder {
            id: emptyText
            text: 'No episodes'
            enabled: episodesList.count == 0 && !seasonPage.isUpdating
        }

        BusyIndicator {
            id: loadingIndicator
            visible: seasonPage.isUpdating
            running: visible
            anchors.centerIn: parent
            size: BusyIndicatorSize.Large
        }

        VerticalScrollDecorator {}
    }
}
