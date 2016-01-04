# Prevent brp-python-bytecompile from running
%define __os_install_post %{___build_post}

Name:       harbour-seriesfinale
Summary:    SeriesFinale is a TV series browser and tracker application.
Version:    1.3.0
Release:    1
Group:      Applications/Internet
License:    GPLv3
URL:        https://github.com/corecomic/seriesfinale
Source0:    %{name}-%{version}.tar.gz
BuildArch:  noarch
Requires:   libsailfishapp-launcher
Requires:   sailfishsilica-qt5 >= 0.10.9
Requires:   pyotherside-qml-plugin-python3-qt5 >= 1.3.0
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  desktop-file-utils

%description
SeriesFinale is a TV series browser and tracker application
Its goal is to help you manage the TV shows you watch regularly and
keep track of the episodes you have seen so far. The shows and episodes
can be retrieved automatically by using the “TheTVDB API” to help you
get to the "series finale" with the least effort.


%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre

# >> build post
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre

TARGET=%{buildroot}/%{_datadir}/%{name}
mkdir -p $TARGET
cp -rpv src* $TARGET/
cp -rpv qml $TARGET/

TARGET=%{buildroot}/%{_datadir}/applications
mkdir -p $TARGET
cp -rpv %{name}.desktop $TARGET/

TARGET=%{buildroot}/%{_datadir}/icons/hicolor/
mkdir -p $TARGET
cp -rpv icons/* $TARGET/

# >> install post
# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/86x86/apps/%{name}.png
%{_datadir}/icons/hicolor/108x108/apps/%{name}.png
%{_datadir}/icons/hicolor/128x128/apps/%{name}.png
%{_datadir}/icons/hicolor/256x256/apps/%{name}.png
# >> files
# << files

%changelog
# * date Author's Name <author's email> version-release
# - Summary of changes
* Mon Jan 04 2016 Core Comic <core.comic@gmail.com> 1.3.0-1
- Add menu item for refreshing a single show only
- Fix season sorting and getting most recent air date
- UI improvements (loading, refreshing)

* Thu Oct 29 2015 Core Comic <core.comic@gmail.com> 1.2.0-1
- Fix showing 'completely whatched' when there are upcoming episodes
- Can mark next episode from main page
- Compatible with tablet (noarch build)

* Tue Oct 20 2015 Core Comic <core.comic@gmail.com> 1.1.1-1
- Fix deleting multiple shows/seasons while remorse timer is active
- Fix adding shows which have no genre specified
- Allow to mark complete shows as watched

* Wed Oct 14 2015 Core Comic <core.comic@gmail.com> 1.1.0-1
- Fix saving at exit
- Add ability to search/add shows in different languages
- Allow sorting by genre

* Wed Oct 07 2015 Core Comic <core.comic@gmail.com> 1.0.0-1
- Initial release for Sailfish OS
