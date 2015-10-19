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
        anchors.leftMargin: Theme.horizontalPageMargin
        anchors.rightMargin: Theme.horizontalPageMargin
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
            opacity: String(source).indexOf('placeholderimage') > -1 ? 0.5 : 1.0
        }

        Column {
            id: column
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - icon.width - Theme.paddingMedium

            Label {
                id: title
                width: parent.width
                font.pixelSize: Theme.fontSizeMedium
                color: highlighted ? Theme.highlightColor : Theme.primaryColor
                truncationMode: TruncationMode.Fade
            }

            Label {
                id: subtitle
                font.pixelSize: Theme.fontSizeTiny
                color: highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                visible: text != ""
            }
        }
    }
}
