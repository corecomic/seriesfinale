import QtQuick 2.0
import Sailfish.Silica 1.0

import '../util.js' as Util

Page {
    id: surveyPage

    property bool isLoading: false
    property bool hasChanged: true

    function update() {
        python.call('seriesfinale.seriesfinale.series_manager.get_series_list_by_prio', [], function(result) {
            // Load the received data into the list model
            Util.updateModelFrom(seriesListByPrio, result);
            isLoading = false;
            hasChanged = false;
        });
    }

    onStatusChanged: {
        if (status === PageStatus.Activating && hasChanged) {
            isLoading = true;
            update();
        }
    }

    Connections {
        target: python

        onLoadingChanged: {
            surveyPage.isLoading = true;
            if(!loading) {
                update();
            }
        }

        onShowListChanged: {
            if (changed) {
                update()
            }
        }

        onCoverImageChanged: {
            for (var i=0; i<seriesListByPrio.count; i++) {
                var show = seriesListByPrio.get(i);
                if (show.showName === name) {
                    seriesListByPrio.setProperty(i, 'coverImage', image);
                    break;
                }
            }
        }

    }


    SilicaListView {
        id: listView
        anchors.fill: parent
        spacing: Theme.paddingMedium

        // PullDownMenu
        PullDownMenu {
            busy: isUpdating

            MenuItem {
                text: qsTr("Add Show")
                visible: !seriesPage.isUpdating
                onClicked: { pageStack.push(addShowComponent.createObject(pageStack)) }
                Component { id: addShowComponent; AddShow {} }
            }
        }

        header: PageHeader {
            id: header
            title: qsTr("Survey Page")
        }

        model: ListModel {
            id: seriesListByPrio
        }

        section.property: "priority"
        section.criteria: ViewSection.FullString
        section.delegate: SectionHeader {
            text: prioListModel[section].name
        }

        delegate: ListRowDelegate {
            id: listDelegate

            isUpdating: model.isUpdating
            isPremiere: model.nextIsPremiere && doHighlight
            isShowPremiere: model.isShowPremiere && doHighlight
            title: model.showName
            subtitle: model.infoMarkup
            priority: model.priority
            iconSource: model.coverImage
            Component {
                id: showPageComponent
                ShowPage { show: model }
            }

            Component {
                id: contextMenu
                ContextMenu {
                    MenuItem {
                        text: qsTr('Change show priority')
                        onClicked: {
                            selectionDialog.showName = model.showName;
                            selectionDialog.open();
                        }
                    }

                    MenuItem {
                        text: qsTr("Delete show")
                        onClicked: showRemorseItem()
                    }
                }
            }

            RemorseItem { id: remorse }
            function showRemorseItem() {
                remorse.execute(listDelegate, qsTr("Deleting"), function() {
                    python.call('seriesfinale.seriesfinale.series_manager.delete_show_by_name', [model.showName]);
                    //seriesList.remove(index);
                })
            }

            onClicked: {
                pageStack.push(showPageComponent.createObject(pageStack));
            }
        }

        ViewPlaceholder {
            id: emptyText
            text: qsTr('No shows')
            enabled: seriesListByPrio.count == 0 && !surveyPage.isLoading
        }

        BusyIndicator {
            id: loadingIndicator
            visible: surveyPage.isLoading || !python.ready
            running: visible
            anchors.centerIn: parent
            size: BusyIndicatorSize.Large
        }

        VerticalScrollDecorator {}
    }

    Dialog {
        id: selectionDialog

        property string showName: ''
        property int selectedIndex: -1

        canAccept: false

        DialogHeader {
            id: dialogHeader
            anchors { top: parent.top; left: parent.left; right: parent.right }
        }

        ListView {
            id: dialogList
            anchors { top: dialogHeader.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }

            model: prioListModel

            delegate: BackgroundItem {
                height: Theme.itemSizeMedium

                Label {
                    text: model.modelData.name

                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: Theme.paddingLarge
                    }
                }

                Rectangle {
                    anchors {
                        right: parent.right
                        rightMargin: Theme.paddingLarge
                        verticalCenter: parent.verticalCenter
                    }
                    color: model.modelData.color
                    height: Theme.itemSizeExtraSmall
                    radius: Math.round(width / 3)
                    width: Theme.paddingSmall
                }


                onClicked: {
                    selectionDialog.selectedIndex = index;
                    selectionDialog.canAccept = true;
                    selectionDialog.accept();

                    python.call('seriesfinale.seriesfinale.series_manager.set_show_priority', [selectionDialog.selectedIndex, selectionDialog.showName])
                    seriesPage.update()
                    surveyPage.update()
                    //console.log("Show: ", selectionDialog.showName, "|| Selected: ", selectionDialog.selectedIndex)
                }
            }
        }
    }
}
