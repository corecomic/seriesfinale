import QtQuick 2.0
import Sailfish.Silica 1.0

ListItem {
    id: epListItem
    contentHeight: Theme.itemSizeSmall

    signal watchToggled(bool watched)
    property alias title: title.text
    property alias subtitle: subtitle.text
    property variant episode: undefined

    Row {
        anchors.fill: parent
        anchors.margins: Theme.paddingLarge
        spacing: Theme.paddingMedium

        Switch {
            id: markItem
            anchors.verticalCenter: parent.verticalCenter
            checked: episode.isWatched

            onClicked: {
                //episode.isWatched = !episode.isWatched
                epListItem.watchToggled(checked)
            }
        }

        Column {
            id: column
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - markItem.width

            Label {
                id: title
                width: parent.width
                font.pixelSize: Theme.fontSizeSmall
                color: episode.isWatched ? Theme.secondaryColor : episode.hasAired ? Theme.primaryColor : Theme.secondaryColor
                text: episode.episodeName
                truncationMode: TruncationMode.Fade
            }

            Label {
                id: subtitle
                font.pixelSize: Theme.fontSizeTiny
                color: Theme.secondaryColor
                text: episode.airDate
                visible: text != ""
            }
        }
    }
}
