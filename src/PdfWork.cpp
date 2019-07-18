#include "PdfWork.h"
#include <QPainter>
#include <QDebug>
#include <QQmlEngine>

PdfWork *PdfWork::p_instance = nullptr;

PdfWork::PdfWork(QObject *parent):
    QObject (parent)
{
    QObject::connect(this, &PdfWork::sourceChanged,
                     this, &PdfWork::pageCountChanged);
    QObject::connect(this, &PdfWork::sourceChanged,
                     this, &PdfWork::currentPageChanged);
}

QUrl PdfWork::source() const
{
    return this->_source;
}

int PdfWork::pageCount() const
{
    if (!this->_popplerDocument)
        return 0;
    return this->_popplerDocument->numPages();
}

int PdfWork::currentPage() const
{
    return _currentPage;
}

int PdfWork::resolution() const
{
    return this->_resolution;
}

bool PdfWork::isLoaded() const
{
    return _isLoaded;
}

QImage PdfWork::currentImage() const
{
    return _pageImage;
}

void PdfWork::resetSource()
{
    _source = "";
    _currentPage = 0;
    _isLoaded = false;
}

QUrl PdfWork::getSpecificURL() const
{
    QString url = QString("image://pdf/%1?p=%2&dpi=%3").arg(_source.toString()).arg(_currentPage).arg(_resolution);
    qDebug()<<"specific url to pdf - "<<url;
    return QUrl(url);
}

void PdfWork::emitError(QString errorStr)
{
    emit error(errorStr);
}


void PdfWork::setSource(const QUrl &source)
{
    qDebug() << "try lo load: " << source;
    if (source == this->_source || !source.isLocalFile())
        return;

    this->_source = source;
    this->_popplerDocument.reset(Poppler::Document::load(source.toLocalFile()));
    if (this->_popplerDocument.isNull() || this->_popplerDocument->isLocked()) {
        qDebug() << "cannot process file";
        this->_currentPage = 0;
        this->_popplerPage.reset();
        emit error("The document can not be loaded");
    } else {
        this->_popplerDocument->setRenderHint(Poppler::Document::TextAntialiasing);
        this->_popplerDocument->setRenderHint(Poppler::Document::Antialiasing);
        this->_popplerDocument->setRenderHint(Poppler::Document::TextHinting);
        qDebug() << "try to load page";
        this->_popplerPage.reset(this->_popplerDocument->page(0));
        if (this->_popplerPage.isNull()) {
            qDebug() << "cannot read page";
            this->_currentPage = 0;
            this->_pageImage = QImage();
            this->_isLoaded = false;
            emit error("No pages in the document");
        } else {
            qDebug() << "page is ready";
            this->_currentPage = 1;
            this->_isLoaded = true;
            this->_pageImage = this->_popplerPage->renderToImage(this->_resolution, this->_resolution);
        }
    }
    qDebug() << "request redraw";
    emit sourceChanged();
}

void PdfWork::setCurrentPage(int page)
{
    if (page <= 0 || page == this->_currentPage || page > this->pageCount())
        return;
    this->_currentPage = page;
    this->_popplerPage.reset(this->_popplerDocument->page(this->_currentPage - 1));
    this->_pageImage = this->_popplerPage.isNull() ? QImage() : this->_popplerPage->renderToImage(this->_resolution, this->_resolution);
    emit currentPageChanged();
}

void PdfWork::setResolution(int resolution)
{
    if (resolution <= 0 || resolution == this->_resolution)
        return;
    this->_resolution = resolution;
    this->_pageImage = this->_popplerPage.isNull() ? QImage() : this->_popplerPage->renderToImage(this->_resolution, this->_resolution);
    emit resolutionChanged();
}

void PdfWork::setIsLoaded(bool isLoaded)
{
    if (_isLoaded == isLoaded)
        return;

    _isLoaded = isLoaded;
    emit isLoadedChanged(_isLoaded);
}
