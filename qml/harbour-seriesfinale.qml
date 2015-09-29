import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "cover"

import io.thp.pyotherside 1.3

ApplicationWindow
{
    initialPage: Component { id: seriesPage; SeriesPage {} }
    cover: Component { id: coverPage; CoverPage {} }

    property string coverImage: 'seriesfinale_cover.png'

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
        signal coverImageChanged()
        signal showArtChanged()
        signal watchedChanged(bool watched)
        signal infoMarkupChanged()
        signal loadingChanged(bool loading)
        signal showListChanged(bool changed)
        signal episodesListUpdated(string name)

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../src'));

            setHandler('finished', function(newvalue) {
                console.log('Finished..: ', newvalue)
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

            importModule('seriesfinale', function () {
                python.call('seriesfinale.seriesfinale.getVersion', [], function(result) {
                    version=result;
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

        Component.onDestruction: {
            // for some reason the PyOtherSide atexit handler does not
            // work on Sailfish OS, so we use this

            python.call('seriesfinale.seriesfinale.closeEvent()', [])
        }
    }
}


