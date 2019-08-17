TARGET = harbour-pdf-viewer

CONFIG += sailfishapp

SOURCES += \
    src/PdfImageProvider.cpp \
    src/FileValidator.cpp \
    src/PdfWork.cpp \
    src/harbour-pdf-viewer.cpp

HEADERS += \
    src/PdfImageProvider.h \
    src/FileValidator.h \
    src/PdfWork.h

DISTFILES += \
    qml/cover/CoverPage.qml \
    qml/pages/ListPdfPage.qml \
    qml/service/Dao.qml \
    qml/model/PdfListModel.qml \
    qml/dialogs/DeletePdfs.qml \
    translations/*.ts \
    qml/pages/ViewerPdfPage.qml \
    qml/harbour-pdf-viewer.qml \
    rpm/harbour-pdf-viewer.yaml \
    harbour-pdf-viewer.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-pdf-viewer-ru.ts

LIBS += -lpoppler-qt5
INCLUDEPATH += /usr/include/poppler/qt5
