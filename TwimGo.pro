# Add more folders to ship with the application, here
folder_01.source = qml/TwimGo
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# Avoid auto screen rotation
#DEFINES += ORIENTATIONLOCK

# Needs to be defined for Symbian
DEFINES += NETWORKACCESS
symbian:TARGET.CAPABILITY += NetworkServices Location LocalServices ReadUserData WriteUserData
symbian:TARGET.UID3 = 0xE4172C9B
#symbian:TARGET.UID3 = 0x20041107

symbian {
      DEPLOYMENT.installer_header=0x2002CCCF
      vendorinfo = \
      "%{\"Tommi Laukkanen\"}" \
       ":\"Tommi Laukkanen\""
       my_deployment.pkg_prerules = vendorinfo
       DEPLOYMENT += my_deployment
 }

!symbian: {
    DEFINES += HAVE_GLWIDGET
    QT += opengl
}

# Define QMLJSDEBUGGER to allow debugging of QML in debug builds
# (This might significantly increase build time)
# DEFINES += QMLJSDEBUGGER

# If your application uses the Qt Mobility libraries, uncomment
# the following lines and add the respective components to the 

# MOBILITY variable. 
#CONFIG += mobility
maemo5:CONFIG += qdbus # mobility
MOBILITY += location

VERSION = 3.2.0

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    windowhelper.cpp

PACKAGENAME = com.substanceofcode.twimgo

# do not compile in debugger stuff

QMLJSDEBUGGER_PATH =
# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/myqmlapplicationviewer.pri)
qtcAddDeployment()

HEADERS += \
    windowhelper.h

OTHER_FILES += \
    qtc_packaging/debian_fremantle/compat \
    qtc_packaging/debian_fremantle/rules \
    qtc_packaging/debian_fremantle/control \
    qtc_packaging/debian_fremantle/changelog \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog \
    TwimGo.desktop

RESOURCES += \
    Resources.qrc








