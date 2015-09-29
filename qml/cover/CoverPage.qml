import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    id: coverPage

    Image {
        source: coverImage
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectCrop
        clip: true
        opacity: 0.5
    }

    Label {
        id: label
        anchors.centerIn: parent
        text: 'SeriesFinale'
        font.pixelSize: Theme.fontSizeLarge
        color: Theme.highlightColor
    }

    CoverActionList {
        id: coverAction
        enabled: false

        CoverAction {
            iconSource: "image://theme/icon-cover-next"
            onTriggered: {}
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-pause"
            onTriggered: {}
        }
    }
}


