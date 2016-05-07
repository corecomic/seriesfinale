import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: aboutPage

    property string license: 'SeriesFinale is free software: you can redistribute it ' +
                             'and/or modify it under the terms of the GNU General Public License as published by ' +
                             'the Free Software Foundation, either version 3 of the License, or ' +
                             '(at your option) any later version.<br/><br/>' +

                             'SeriesFinale is distributed in the hope that it will be useful, ' +
                             'but WITHOUT ANY WARRANTY; without even the implied warranty of ' +
                             'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the ' +
                             'GNU General Public License for more details.<br/><br/>' +

                             'You should have received a copy of the GNU General Public License ' +
                             'along with SeriesFinale.  If not, see <a href="http://www.gnu.org/licenses/">http://www.gnu.org/licenses/</a>.'

    SilicaFlickable {
        id: flickableText
        anchors.fill: parent

        contentHeight: contents.height
        contentWidth: contents.width

        VerticalScrollDecorator {}

        Column {
            id: contents
            width: aboutPage.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: 'SeriesFinale ' + python.version
            }

            Column {
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.horizontalPageMargin
                    rightMargin: Theme.horizontalPageMargin
                }
                spacing: Theme.paddingLarge

                Label {
                    font.pixelSize: Theme.fontSizeSmall
                    text: 'Copyright © 2015 Core Comic'
                    color: Theme.primaryColor
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Label {
                    font.pixelSize: Theme.fontSizeSmall
                    text: '<strong>Special thanks to:</strong> <br/>&nbsp;&nbsp;Joaquim Rocha\
                      <br/>&nbsp;&nbsp;Juan Suarez Romero\
                      <br/>&nbsp;&nbsp;Micke Prag'
                    color: Theme.primaryColor
                    anchors.left: parent.left
                    onLinkActivated: Qt.openUrlExternally(link)
                }

                Label {
                    font.pixelSize: Theme.fontSizeTiny
                    text: "<style>a { color: " + Theme.highlightColor + "; }</style>" + 'SeriesFinale uses <a href="http://www.thetvdb.com">TheTVDB</a> API but is not endorsed or certified by TheTVDB. Please contribute to it if you can.'
                    textFormat: Text.RichText
                    color: Theme.primaryColor
                    wrapMode: Text.WordWrap
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Label {
                    font.pixelSize: Theme.fontSizeTiny
                    text: "<style>a { color: " + Theme.highlightColor + "; }</style>" + license
                    textFormat: Text.RichText
                    color: Theme.primaryColor
                    wrapMode: Text.WordWrap
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    onLinkActivated: Qt.openUrlExternally(link)
                }
            }
        }
    }

    Component { id: statisticsComponent; StatisticsPage {} }
    onStatusChanged: {
        if (status === PageStatus.Active) {
            pageStack.pushAttached(statisticsComponent);
        }
    }
}
