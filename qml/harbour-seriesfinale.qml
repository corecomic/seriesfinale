/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"

import io.thp.pyotherside 1.4

ApplicationWindow
{
    initialPage: Component { id: seriesPage; SeriesPage {} }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")

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
        signal episodesListUpdated()

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


