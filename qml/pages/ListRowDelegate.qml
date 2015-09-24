import QtQuick 2.0
import Sailfish.Silica 1.0

ListItem {
    id: listItem
    contentHeight: Theme.itemSizeLarge

    menu: contextMenu

    property alias title: title.text
    property alias subtitle: subtitle.text
    property alias iconSource: icon.source

    Row {
        anchors.fill: parent
        spacing: Theme.paddingMedium

        Image {
            id: icon
            anchors.verticalCenter: parent.verticalCenter
            height: listItem.contentHeight - 5
            width: height
            fillMode: "PreserveAspectFit"
            smooth: true
            source: ''
            visible: source != ''
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter

            Label {
                id: title
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.primaryColor
            }

            Label {
                id: subtitle
                font.pixelSize: Theme.fontSizeTiny
                color: Theme.secondaryColor
                visible: text != ""
            }
        }
    }
}
