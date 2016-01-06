import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: searchPage

    property bool isSearching: false
    property string searchLanguage: 'en'

    Component.onCompleted: searchField.forceActiveFocus()

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            python.call('seriesfinale.seriesfinale.settingsWrapper.getSearchLanguage', [], function(result) {
                searchLanguage = result;
            })
        }
    }

    function search() {
        parent.focus = true //Make sure the keyboard closes and the text is updated
        python.call('seriesfinale.seriesfinale.series_manager.search_shows', [searchField.text, searchLanguage], function() {});
    }

    Connections {
        target: python

        onSearchingChanged: {
            searchPage.isSearching = searching;
            if(!searching) {
                python.call('seriesfinale.seriesfinale.series_manager.search_result_model', [], function(result) {
                    // Clear the data in the list model
                    listModel.clear();
                    // Load the received data into the list model
                    for (var i=0; i<result.length; i++) {
                        listModel.append(result[i]);
                    }
                });
            }
        }
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        VerticalScrollDecorator {}

        PullDownMenu {
            MenuItem {
                text: qsTr('Search options')
                onClicked: pageStack.push(Qt.resolvedUrl("SearchSettingsPage.qml"), {language: searchLanguage})
            }
        }


        Column {
            id: column
            width: searchPage.width

            PageHeader {
                title: qsTr("Add show")
            }

            SearchField {
                id: searchField

                width: parent.width
                placeholderText: qsTr("Search")
                inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText

                onTextChanged: {
                    //search();
                }

                EnterKey.onClicked: {
                    if (text != "")
                        searchField.focus = false;
                    search();
                }
            }

            Repeater {
                width: parent.width

                model: ListModel {
                    id: listModel
                }

                delegate: ListItem {
                    Label {
                        anchors {
                            left: parent.left
                            right: parent.right
                            leftMargin: searchField.textLeftMargin
                            rightMargin: searchField.textRightMargin
                            verticalCenter: parent.verticalCenter
                        }
                        text: model.data
                        truncationMode: TruncationMode.Fade
                    }
                    onClicked: {
                        python.call('seriesfinale.seriesfinale.series_manager.get_complete_show', [model.data, searchLanguage], function() {});
                        pageStack.pop()
                    }
                }
            }
        }
        BusyIndicator {
            size: BusyIndicatorSize.Medium
            anchors {
                top: parent.top
                topMargin: 10*Theme.paddingLarge
                horizontalCenter: parent.horizontalCenter
            }
            visible: isSearching
            running: visible
        }
    }
}
