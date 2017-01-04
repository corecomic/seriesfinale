import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "cover"

import io.thp.pyotherside 1.3
import org.nemomobile.notifications 1.0

ApplicationWindow
{
    initialPage: Component { id: seriesPage; SeriesPage {} }
    cover: Component { id: coverPage; CoverPage {} }

    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All

    property string coverImage: 'seriesfinale_cover.png'

    property var prioListModel: [
        { name: qsTr("None"), color: "#93a1a1" },
        { name: qsTr("Pilot"), color: "#2aa198" },
        { name: qsTr("Episode"), color: "#268bd2" },
        { name: qsTr("Season"), color: "#6c71c4" },
        { name: qsTr("Finale"), color: "#d33682" }
    ]

    Component.onDestruction: {
        // for some reason the PyOtherSide atexit handler does not
        // work on Sailfish OS, so we use this

        python.call('seriesfinale.seriesfinale.closeEvent()', [])
    }

    Notification {
        id: notification
        appName: "SeriesFinale"
        summary: ""
        previewSummary: summary
        expireTimeout: 1
    }

    Python {
        id: python

        property bool ready: false
        property string version

        signal searchingChanged(bool searching)
        signal updatingChanged(bool updating)
        signal showUpdatingChanged(bool updating)
        signal overviewChanged()
        signal titleChanged()
        signal airDateTextChanged()
        signal coverImageChanged(string name, string image)
        signal showArtChanged()
        signal watchedChanged(bool watched)
        signal infoMarkupChanged()
        signal loadingChanged(bool loading)
        signal showListChanged(bool changed)
        signal episodesListUpdated(var show)
        signal episodesListUpdating(string name)

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../src'));

            setHandler('finished', function(newvalue) {
                console.log('Finished..: ', newvalue)
            });
            setHandler('notification', function(note) {
                notification.summary = note;
                notification.publish();
            });
            setHandler('searching', python.searchingChanged);
            setHandler('updating', python.updatingChanged);
            setHandler('showUpdating', python.showUpdatingChanged);
            setHandler('overviewChanged', python.overviewChanged);
            setHandler('titleChanged', python.titleChanged);
            setHandler('airDateTextChanged', python.airDateTextChanged);
            setHandler('coverImageChanged', python.coverImageChanged);
            setHandler('showArtChanged', python.showArtChanged);
            setHandler('watchedChanged', python.watchedChanged);
            setHandler('infoMarkupChanged', python.infoMarkupChanged);
            setHandler('showListChanged', python.showListChanged);
            setHandler('loadingChanged', python.loadingChanged);
            setHandler('episodesListUpdated', python.episodesListUpdated);
            setHandler('episodesListUpdating', python.episodesListUpdating);

            importModule('seriesfinale', function () {
                python.call('seriesfinale.seriesfinale.getVersion', [], function(result) {
                    version=result;
                    ready = true;
                });
            });
        }

        onError: {
            // when an exception is raised, this error handler will be called
            console.log('python error: ' + traceback);
        }

        onReceived: {
            // asychronous messages from Python arrive here
            // in Python, this can be accomplished via pyotherside.send()
            console.log('got message from python: ' + data);
        }
    }
}


