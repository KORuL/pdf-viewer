#include <QtQuick>
#include <sailfishapp.h>
#include "PdfWork.h"
#include "FileValidator.h"
#include "PdfImageProvider.h"

static QObject *pdfwork_provider(QQmlEngine *engine, QJSEngine *scriptEngine);

int main(int argc, char *argv[])
{
    qmlRegisterSingletonType<PdfWork>("PdfWorker", 1, 0, "PdfWork", pdfwork_provider);

    qmlRegisterType<FileValidator>("FileWork", 1, 0, "FileValidator");

    QGuiApplication *app = SailfishApp::application(argc, argv);
    QQuickView *view = SailfishApp::createView();

    view->engine()->addImageProvider("pdf", new PdfImageProvider(QQmlImageProviderBase::Image));

    view->setSource(SailfishApp::pathToMainQml());
    view->show();
    return app->exec();
}

static QObject *pdfwork_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

   PdfWork* instance = PdfWork::getInstance();
   return instance;
}
