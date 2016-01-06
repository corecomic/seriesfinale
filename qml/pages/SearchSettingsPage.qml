import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: searchSettingsPage

    property string language: 'en'

    function setLanguage(lang) {
        python.call('seriesfinale.seriesfinale.settingsWrapper.setSearchLanguage', [lang])
    }

    Component.onCompleted: {
        var langList = ['en','sv','no','da','fi','nl','de','it','es','fr','pl','hu','el','tr','ru','he','ja','pt','zh','cs','sl','hr','ko'];
        languageMenu.currentIndex = langList.indexOf(language);
    }

    SilicaFlickable {
        id: content
        anchors.fill: parent

        contentWidth: grid.width
        contentHeight: grid.height

        VerticalScrollDecorator { flickable: flickable }

        Column {
            id: grid

            width: searchSettingsPage.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr('Search options')
            }

            ComboBox {
                id: languageMenu
                label: qsTr('Language')
                menu: ContextMenu {
                    MenuItem { text: "English"; onClicked: setLanguage('en')}
                    MenuItem { text: "Svenska"; onClicked: setLanguage('sv')}
                    MenuItem { text: "Norsk"; onClicked: setLanguage('no')}
                    MenuItem { text: "Dansk"; onClicked: setLanguage('da')}
                    MenuItem { text: "Suomeksi"; onClicked: setLanguage('fi')}
                    MenuItem { text: "Nederlands"; onClicked: setLanguage('nl')}
                    MenuItem { text: "Deutsch"; onClicked: setLanguage('de')}
                    MenuItem { text: "Italiano"; onClicked: setLanguage('it')}
                    MenuItem { text: "Español"; onClicked: setLanguage('es')}
                    MenuItem { text: "Français"; onClicked: setLanguage('fr')}
                    MenuItem { text: "Polski"; onClicked: setLanguage('pl')}
                    MenuItem { text: "Magyar"; onClicked: setLanguage('hu')}
                    MenuItem { text: "Greek"; onClicked: setLanguage('el')}
                    MenuItem { text: "Turkish"; onClicked: setLanguage('tr')}
                    MenuItem { text: "Russian"; onClicked: setLanguage('ru')}
                    MenuItem { text: "Hebrew"; onClicked: setLanguage('he')}
                    MenuItem { text: "Japanese"; onClicked: setLanguage('ja')}
                    MenuItem { text: "Portuguese"; onClicked: setLanguage('pt')}
                    MenuItem { text: "Chinese"; onClicked: setLanguage('zh')}
                    MenuItem { text: "Czech"; onClicked: setLanguage('cs')}
                    MenuItem { text: "Slovenian"; onClicked: setLanguage('sl')}
                    MenuItem { text: "Croatian"; onClicked: setLanguage('hr')}
                    MenuItem { text: "Korean"; onClicked: setLanguage('ko')}
                }
            }
        }
    }
}
