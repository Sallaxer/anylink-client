QT       += core gui websockets widgets

CONFIG += c++14
TRANSLATIONS = i18n/anylink_zh_CN.ts

win32|macx|linux:!android {
    include(3rdparty/SingleApplication/singleapplication.pri)
    include(3rdparty/qtkeychain/qtkeychain.pri)
    # used by SingleApplication
    DEFINES += QAPPLICATION_CLASS=QApplication
}

# Copies the given files to the destination directory
defineTest(copyToDestDir) {
    files = $$1
    DDIR = $$DESTDIR/../

    for(FILE, files) {

        # Replace slashes in paths with backslashes for Windows
        win32:FILE ~= s,/,\\,g
        win32:DDIR ~= s,/,\\,g

        QMAKE_POST_LINK += $$QMAKE_COPY $$quote($$PWD/$$FILE) $$quote($$DDIR) $$escape_expand(\\n\\t)
    }

    export(QMAKE_POST_LINK)
}

#macx {
#    ICON = images/logo.png
#}

win32 {
    # https://doc.qt.io/qt-6/qmake-variable-reference.html#version
    #RC_FILE = resource.rc
    VERSION = 0.3
    RC_ICONS = resource\windows\anylink.ico
    QMAKE_TARGET_PRODUCT = "AnyLink Secure Client"
    QMAKE_TARGET_COMPANY = "https://anylink.pro"
    QMAKE_TARGET_DESCRIPTION = "AnyLink Secure Client"
    QMAKE_TARGET_COPYRIGHT = "Copyright 2022-2023 https://anylink.pro. All rights reserved."

    DESTDIR = $$PWD/out/bin
}

linux:!android {
    DESTDIR = $$PWD/out/opt/anylink/bin
    copyToDestDir(images/logo.png resource/linux/anylink.desktop)
}

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    src/anylink.cpp \
    src/common.cpp \
    src/configmanager.cpp \
    src/detaildialog.cpp \
    src/jsonrpcwebsocketclient.cpp \
    src/keychainclass.cpp \
    src/loading.cpp \
    src/logviewer.cpp \
    src/main.cpp \
    src/profilemanager.cpp

HEADERS += \
    src/anylink.h \
    src/common.h \
    src/configmanager.h \
    src/detaildialog.h \
    src/jsonrpcwebsocketclient.h \
    src/keychainclass.h \
    src/loading.h \
    src/logviewer.h \
    src/profilemanager.h

FORMS += \
    src/anylink.ui \
    src/detaildialog.ui \
    src/logviewer.ui \
    src/profilemanager.ui

RESOURCES += \
    i18n.qrc \
    systray.qrc