# 
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.21
# 
# >> macros
# << macros

Name:       com.substanceofcode.twimgo
Summary:    Twitter client
Version:    2.8.2
Release:    1
Group:      Applications/Internet
License:    TBD
URL:        http://www.substanceofcode.com/
Source0:    %{name}-%{version}.tar.gz
Source100:  com.substanceofcode.twimgo.yaml
BuildRequires:  pkgconfig(QtCore) >= 4.7.0
BuildRequires:  pkgconfig(QtGui)
BuildRequires:  pkgconfig(QtWebKit)
BuildRequires:  pkgconfig(QtOpenGL)


%description
Twitter client



%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre

%qmake 

make %{?jobs:-j%jobs}

# >> build post
# << build post
%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%qmake_install

# >> install post
# << install post






%files
%defattr(-,root,root,-)
/usr/share
/opt
# >> files
# << files


