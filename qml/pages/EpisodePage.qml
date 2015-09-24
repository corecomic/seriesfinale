import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: episodePage
    property variant show: undefined
    property variant episode: undefined
    property string seasonImg: ''

    PageHeader {
        id: header
        title: episode.episodeName
    }

    Item {
        id: dataItem
        anchors.top: header.bottom
        anchors.left: parent.left
        width: parent.width
        anchors.margins: Theme.paddingLarge
        height: grid.height

        Grid {
              id: grid
              columns: 2
              spacing: 10

              Text {
                  text: "Air date:"
                  font.pixelSize: Theme.fontSizeSmall
                  color: Theme.primaryColor
              }
              Text {
                  text: episode.airDate
                  font.pixelSize: Theme.fontSizeSmall
                  color: Theme.secondaryColor
              }
              Text {
                  text: "Rating:"
                  font.pixelSize: Theme.fontSizeSmall
                  color: Theme.primaryColor
              }
              Text {
                  text: episode.episodeRating
                  font.pixelSize: Theme.fontSizeSmall
                  color: Theme.secondaryColor
              }
          }
    }

    Item {
        id: overviewItem
        anchors.top: dataItem.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: watched.top
        anchors.margins: Theme.paddingLarge

        Flickable {
            id: flickableText
            height: parent.height - watched.height - 10
            width: parent.width
            contentHeight: text.height + overviewTitle.height + 10
            clip: true

//            onMovingChanged: {
//                if (horizontalVelocity == 0){
//                    // do nothing
//                } else if (horizontalVelocity < 0){
//                    if (!moving)
//                        episode = show.get_previous_episode(episode)
//                } else {
//                    if (!moving)
//                        episode = show.get_next_episode(episode)
//                }
//            }

            Text {
                id: overviewTitle
                font.pixelSize: Theme.fontSizeSmall
                text: 'Overview:'
                color: Theme.highlightColor
            }

            Text {
                id: text
                anchors.top: overviewTitle.bottom
                anchors.topMargin: Theme.paddingMedium
                width: parent.width
                text: episode.overviewText
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
                wrapMode: Text.Wrap
            }
        }
        //VerticalScrollDecorator {}
    }

    TextSwitch {
        id: watched
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.paddingLarge
        anchors.left: parent.left
        anchors.leftMargin: Theme.paddingLarge
        text: "Watched"
        onCheckedChanged: {
            python.call('seriesfinale.seriesfinale.series_manager.set_episode_watched', [checked, show.showName, episode.episodeName])
        }
    }
    onEpisodeChanged: watched.checked = episode.isWatched
}
