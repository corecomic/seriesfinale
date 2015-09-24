# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-seriesfinale

CONFIG += sailfishapp

DEPLOYMENT_PATH = /usr/share/$${TARGET}

src.files = src
src.path = $${DEPLOYMENT_PATH}

SOURCES += src/harbour-seriesfinale.cpp

OTHER_FILES += qml/harbour-seriesfinale.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-seriesfinale.changes.in \
    rpm/harbour-seriesfinale.spec \
    rpm/harbour-seriesfinale.yaml \
    translations/*.ts \
    harbour-seriesfinale.desktop \
    qml/pages/ShowPage.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/SeriesPage.qml \
    qml/pages/SeasonPage.qml \
    qml/pages/ListRowDelegate.qml \
    qml/pages/EpisodePage.qml \
    qml/pages/EpisodeListRowDelegate.qml \
    qml/pages/AddShow.qml \
    qml/pages/AboutPage.qml \
    src/SeriesFinale/locale/pt/LC_MESSAGES/seriesfinale.mo \
    src/SeriesFinale/po/pt.po \
    src/SeriesFinale/po/seriesfinale.pot \
    src/SeriesFinale/lib/__init__.py \
    src/SeriesFinale/lib/connectionmanager.py \
    src/SeriesFinale/lib/constants.py \
    src/SeriesFinale/lib/listmodel.py \
    src/SeriesFinale/lib/portrait.py \
    src/SeriesFinale/lib/serializer.py \
    src/SeriesFinale/lib/thetvdbapi.py \
    src/SeriesFinale/lib/util.py \
    src/SeriesFinale/__init__.py \
    src/SeriesFinale/asyncworker.py \
    src/SeriesFinale/qtgui.py \
    src/SeriesFinale/series.py \
    src/SeriesFinale/settings.py \
    src/seriesfinale.py \
    harbour-seriesfinale.png

INSTALLS += src

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-seriesfinale-de.ts

