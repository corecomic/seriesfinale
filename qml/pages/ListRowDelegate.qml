import QtQuick 2.0
import Sailfish.Silica 1.0

ListItem {
    id: listItem
    contentHeight: Screen.sizeCategory >= Screen.Large ? Theme.itemSizeExtraLarge : Theme.itemSizeLarge

    menu: contextMenu

    property alias title: title.text
    property alias subtitle: subtitle.text
    property alias iconSource: icon.source

    property bool isUpdating: false
    property bool isPremiere: false

    anchors {
        left: parent.left
        right: parent.right
    }

    Rectangle {
        anchors.fill: parent
        color: isPremiere ? Theme.rgba(Theme.highlightBackgroundColor, 0.1) : "transparent"

        Image {
            id: icon
            visible: source != ''

            anchors {
                left: parent.left
                leftMargin: Screen.sizeCategory >= Screen.Large ? Theme.horizontalPageMargin : Theme.paddingSmall
                verticalCenter: parent.verticalCenter
            }

            height: listItem.contentHeight - 6
            width: height

            asynchronous: true
            fillMode: "PreserveAspectFit"
            smooth: false
            sourceSize.height: height
            source: ''
            opacity: isUpdating ? 0.2 :
                                  String(source).indexOf('placeholderimage') > -1 ? 0.5 : 1.0
        }

        BusyIndicator {
            anchors.centerIn: icon
            visible: isUpdating
            running: visible
        }

        Column {
            id: column
            anchors {
                left: icon.right
                leftMargin: Theme.paddingSmall
                rightMargin: Theme.horizontalPageMargin
                right: parent.right
                verticalCenter: parent.verticalCenter
            }

            Label {
                id: title
                width: parent.width
                font.pixelSize: Theme.fontSizeMedium
                font.bold: isPremiere
                color: highlighted ? Theme.highlightColor : Theme.primaryColor
                truncationMode: TruncationMode.Fade
            }

            Label {
                id: subtitle
                font.pixelSize: Theme.fontSizeTiny
                font.bold: isPremiere
                color: highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                visible: text != ""
            }
        }
    }


}
