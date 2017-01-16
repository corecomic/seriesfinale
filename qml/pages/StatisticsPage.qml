import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: statisticsPage

    Component.onCompleted: {
        python.call('seriesfinale.seriesfinale.getStatistics', [], function(result) {
            numShows.text = result.numSeries;
            watchedShows.text = result.numSeriesWatched + ' (' + Math.round(100*result.numSeriesWatched/result.numSeries) + '%)';
            endedShows.text = result.numSeriesEnded;
            numEpisodes.text = result.numEpisodes;
            watchedEpisodes.text = result.numEpisodesWatched + ' (' + Math.round(100*result.numEpisodesWatched/result.numEpisodes) + '%)';
            timeWatched.text = Math.round(result.timeWatched/14.4)/100;
        })
        python.call('seriesfinale.seriesfinale.settingsWrapper.getLastCompleteUpdate', [], function(result) {
            lastUpdate.text = result;
        })

    }


    SilicaFlickable {
        id: flickableText
        anchors.fill: parent

        contentHeight: contents.height

        VerticalScrollDecorator {}

        anchors.leftMargin: Theme.horizontalPageMargin
        anchors.rightMargin: Theme.horizontalPageMargin

        Column {
            id: contents
            width: statisticsPage.width - Theme.horizontalPageMargin
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Statistics")
            }

            Grid {
                id: grid
                columns: 2
                spacing: Theme.paddingLarge

                Text {
                    text: qsTr("Number of shows:")
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.primaryColor
                }
                Text {
                    id: numShows
                    text: ""
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.secondaryColor
                }
                Text {
                    text: qsTr("Ended shows:")
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.primaryColor
                }
                Text {
                    id: endedShows
                    text: ""
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.secondaryColor
                }
                Text {
                    text: qsTr("Watched shows:")
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.primaryColor
                }
                Text {
                    id: watchedShows
                    text: ""
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.secondaryColor
                }
                Text {
                    text: qsTr("Number of episodes:")
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.primaryColor
                }
                Text {
                    id: numEpisodes
                    text: ""
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.secondaryColor
                }
                Text {
                    text: qsTr("Watched episodes:")
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.primaryColor
                }
                Text {
                    id: watchedEpisodes
                    text: ""
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.secondaryColor
                }
                Text {
                    text: qsTr("Days spent watching:")
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.primaryColor
                }
                Text {
                    id: timeWatched
                    text: ""
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.secondaryColor
                }
                Text {
                    text: qsTr("Last refresh:")
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.primaryColor
                }
                Text {
                    id: lastUpdate
                    text: ""
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.secondaryColor
                }
            }
        }
    }
}
