#include <QtQuick>
#include <sailfishapp.h>
#include "PdfWork.h"
#include "FileValidator.h"
#include "PdfImageProvider.h"

int main(int argc, char *argv[])
{
    qmlRegisterSingletonType<PdfWork>("PdfWorker", 1, 0, "PdfWork", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)

        PdfWork *pdf = PdfWork::getInstance();
        return pdf;
    });

    qmlRegisterType<FileValidator>("FileWork", 1, 0, "FileValidator");

    QGuiApplication *app = SailfishApp::application(argc, argv);
    QQuickView *view = SailfishApp::createView();

    view->engine()->addImageProvider("pdf", new PdfImageProvider(QQmlImageProviderBase::Image));

    view->setSource(SailfishApp::pathToMainQml());
    view->show();
    return app->exec();
}
