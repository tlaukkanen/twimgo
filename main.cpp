/*
    Copyright 2011 - Tommi Laukkanen (www.substanceofcode.com)

    This file is part of TwimGo.

    NewsFlow is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Foobar is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with NewsFlow. If not, see <http://www.gnu.org/licenses/>.
*/

#include <QDeclarativeContext>
#include <QDeclarativeEngine>
#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"
#include "windowhelper.h"
#include <QDeclarativeEngine>
#include <QTranslator>
#include <QLocale>

#ifdef HAVE_GLWIDGET

#include <QGLWidget>

#endif


int main(int argc, char *argv[])
{
#ifdef Q_OS_SYMBIAN
    QApplication::setGraphicsSystem(QLatin1String("openvg"));
#elif defined(Q_WS_MAEMO_5) || defined(Q_WS_MAEMO_6)
    QApplication::setGraphicsSystem(QLatin1String("opengl"));
//#else
//    QApplication::setGraphicsSystem(QLatin1String("raster"));
#endif


    QApplication app(argc, argv);
    //app.setProperty("NoMStyle", true);
    QString locale = QLocale::system().name();

    QTranslator translator;

    /* the ":/" is a special directory Qt uses to
    * distinguish resources;
    * NB this will look for a filename matching locale + ".qm";
    * if that's not found, it will truncate the locale to
    * the first two characters (e.g. "en_GB" to "en") and look
    * for that + ".qm"; if not found, it will look for a
    * qml-translations.qm file; if not found, no translation is done
    */
    if (translator.load("twimgo_twimgots_" + locale, ":/"))
    {
        app.installTranslator(&translator);
    }
    QmlApplicationViewer viewer;

//#ifdef HAVE_GLWIDGET
//    QGLWidget *glWidget = new QGLWidget(&viewer);
//    viewer.setViewport(glWidget);
//#endif
    //viewer.setAttribute(Qt::WA_NoSystemBackground);
    //viewer.setAttribute(Qt::WA_OpaquePaintEvent);
    //viewer.viewport()->setAttribute(Qt::WA_OpaquePaintEvent);
    //viewer.viewport()->setAttribute(Qt::WA_NoSystemBackground);


#ifdef Q_WS_MAEMO_5
    viewer.engine()->addImportPath(QString("/opt/qtm11/imports"));
    viewer.engine()->addPluginPath(QString("/opt/qtm11/plugins"));
#endif

    WindowHelper *windowHelper = new WindowHelper();
    viewer.rootContext()->setContextProperty("windowHelper", windowHelper);

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/TwimGo/main.qml"));
#ifdef Q_OS_SYMBIAN
    viewer.showFullScreen();
#elif defined(Q_WS_MAEMO_5)
    viewer.showFullScreen();
#elif defined(Q_WS_SIMULATOR)
    viewer.showFullScreen();
#else
    viewer.showFullScreen();
    // we don't want full screen on meego tablets at least
    //viewer.showMaximized();
#endif

    return app.exec();
}
