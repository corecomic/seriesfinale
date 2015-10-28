import QtQuick 2.0
import Sailfish.Silica 1.0

ListItem {
    id: listItem
    contentHeight: Screen.sizeCategory >= Screen.Large ? Theme.itemSizeExtraLarge : Theme.itemSizeLarge

    menu: contextMenu

    property alias title: title.text
    property alias subtitle: subtitle.text
    property alias iconSource: icon.source

    Row {
        anchors.fill: parent
        anchors.leftMargin: Screen.sizeCategory >= Screen.Large ? Theme.horizontalPageMargin : Theme.paddingSmall
        spacing: Theme.paddingSmall

        Image {
            id: icon
            anchors.verticalCenter: parent.verticalCenter
            height: listItem.contentHeight - 6
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
            width: parent.width - icon.width - Theme.horizontalPageMargin

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
