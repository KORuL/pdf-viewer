#include "PdfImageProvider.h"

PdfImageProvider::PdfImageProvider(ImageType type, Flags flags): QQuickImageProvider(type,flags)
{
    this->_pdfview.reset(PdfWork::getInstance());
}

PdfImageProvider::~PdfImageProvider()
{

}

QImage PdfImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{    
    QStringList param = id.split("?p=");
    QStringList paramPageRes = param.at(1).split("&dpi=");
    if(param.size() < 2 || paramPageRes.size() < 2) {
        this->_pdfview->emitError("Wrong request to pdf image");
        return QImage();
    }
    else if(param.at(0) == "") {
        this->_pdfview->emitError("PDF not selected");
        return QImage();
    }

    QUrl source = param.at(0);
    qint32 page = paramPageRes.at(0).toInt();
    qint32 resolution = paramPageRes.at(1).toInt();

    this->_pdfview->setResolution(resolution);
    this->_pdfview->setSource(source);
    this->_pdfview->setCurrentPage(page);

    return this->_pdfview->currentImage();
}
