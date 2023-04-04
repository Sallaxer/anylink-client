#include "anylink.h"
#include "common.h"
#include "configmanager.h"
#include <QApplication>
#include <QStandardPaths>
#include <QDir>
#include <QTranslator>
#if defined(Q_OS_LINUX) || defined(Q_OS_MACOS) || defined(Q_OS_WIN)
#include "singleapplication.h"
#endif

void outdateCheck()
{
    if (QDate::currentDate().daysTo(QDate(2024,5,1)) < 0) {
        error(QObject::tr("The current version of the software has expired, please install the latest version!"));
        exit(0);
    }
}

int main(int argc, char *argv[])
{
    qSetMessagePattern("%{type}:[%{file}:%{line}]  %{message}");
#if QT_VERSION <= QT_VERSION_CHECK(6, 2, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QApplication::setApplicationName("AnyLink");
    configLocation = QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation);
    tempLocation = QStandardPaths::writableLocation(QStandardPaths::TempLocation);
    QDir().mkpath(configLocation);

#if defined(Q_OS_LINUX) || defined(Q_OS_MACOS) || defined(Q_OS_WIN)
    SingleApplication app(argc, argv);
#else
    QApplication app(argc, argv);
#endif

    configManager = new ConfigManager();
    // Multiple translation files can be installed.
    // Translations are searched for in the reverse order in which they were installed
    QTranslator myTranslator; // must global

    if(configManager->loadConfig(Json)) {
        if(configManager->config["local"].toBool()) {
//            qDebug() << QLocale::system().name();
            // embeded in qrc
            if(myTranslator.load(QLocale(), QLatin1String("anylink"), QLatin1String("_"), QLatin1String(":/i18n"))) {
                app.installTranslator(&myTranslator);
            }
        }
    }

    outdateCheck();

    AnyLink w;
    w.show();

    QApplication::setQuitOnLastWindowClosed(false);
    QObject::connect(&app, &SingleApplication::instanceStarted, &w, &AnyLink::show);

    return app.exec();
}