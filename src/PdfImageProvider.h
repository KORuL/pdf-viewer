#ifndef PDFIMAGEPROVIDER_H
#define PDFIMAGEPROVIDER_H

#include <QObject>
#include <QQuickImageProvider>
#include <QNetworkAccessManager>

#include "PdfWork.h"

class PdfImageProvider : public QQuickImageProvider
{
public:
    PdfImageProvider(ImageType type, Flags flags = Flags());
    ~PdfImageProvider();

    QImage requestImage(const QString & id, QSize * size, const QSize & requestedSize) override;

private:
    QScopedPointer<PdfWork> _pdfview;
};
#endif // PDFIMAGEPROVIDER_H
