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

DEPLOYMENT_PATH = /usr/share/$${TARGET}

src.files = src
src.path = $${DEPLOYMENT_PATH}

CONFIG += sailfishapp_qml

SOURCES +=

OTHER_FILES += qml/harbour-seriesfinale.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-seriesfinale.changes \
    rpm/harbour-seriesfinale.spec \
    rpm/harbour-seriesfinale.yaml \
    translations/*.ts \
    harbour-seriesfinale.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

INSTALLS += src

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-seriesfinale-de.ts \
    translations/harbour-seriesfinale-es.ts \
    translations/harbour-seriesfinale-sv.ts

DISTFILES += \
    qml/pages/AboutPage.qml \
    qml/pages/AddShow.qml \
    qml/pages/EpisodeListRowDelegate.qml \
    qml/pages/EpisodePage.qml \
    qml/pages/ListRowDelegate.qml \
    qml/pages/SearchSettingsPage.qml \
    qml/pages/SeasonPage.qml \
    qml/pages/SeriesPage.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/ShowPage.qml \
    qml/util.js \
    src/seriesfinale.py \
    src/SeriesFinale/placeholderimage.png \
    src/SeriesFinale/asyncworker.py \
    src/SeriesFinale/__init__.py \
    src/SeriesFinale/series.py \
    src/SeriesFinale/settings.py \
    src/SeriesFinale/lib/connectionmanager.py \
    src/SeriesFinale/lib/constants.py \
    src/SeriesFinale/lib/__init__.py \
    src/SeriesFinale/lib/listmodel.py \
    src/SeriesFinale/lib/serializer.py \
    src/SeriesFinale/lib/thetvdbapi_v2.py \
    src/SeriesFinale/lib/util.py \
    qml/pages/StatisticsPage.qml \
    qml/pages/AddCalendarPage.qml \
    qml/pages/SurveyPage.qml \
    qml/pages/MyCalendarPicker.qml
