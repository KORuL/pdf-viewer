#ifndef PDFWORK_H
#define PDFWORK_H

#include <QQuickPaintedItem>
#include <QImage>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlEngine>
#include <QFileInfo>

#include <poppler-qt5.h>

class PdfWork: public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(PdfWork)

    Q_PROPERTY(QUrl source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(int pageCount READ pageCount NOTIFY pageCountChanged)
    Q_PROPERTY(int currentPage READ currentPage WRITE setCurrentPage NOTIFY currentPageChanged)
    Q_PROPERTY(int resolution READ resolution WRITE setResolution NOTIFY resolutionChanged)
    Q_PROPERTY(bool isLoaded READ isLoaded WRITE setIsLoaded NOTIFY isLoadedChanged)

private:
    PdfWork(QObject *parent = nullptr);
    PdfWork& operator=(PdfWork&);

public:
    static PdfWork *getInstance() {
        if(!p_instance)
            p_instance = new PdfWork();
        return p_instance;
    }

    QUrl source() const;
    int pageCount() const;
    int currentPage() const;
    int resolution() const;
    bool isLoaded() const;
    QImage currentImage() const;

public slots:
    void resetSource();
    void setSource(const QUrl &source);
    void setCurrentPage(int page);
    void setResolution(int resolution);
    void setIsLoaded(bool isLoaded);
    QUrl getSpecificURL() const;
    void emitError(QString errorStr);

signals:
    void sourceChanged();
    void pageCountChanged();
    void currentPageChanged();
    void resolutionChanged();
    void error(const QString &message);
    void isLoadedChanged(bool isLoaded);

private:
    QUrl _source;
    int _currentPage = 0;
    int _resolution = 150;
    QScopedPointer<Poppler::Document> _popplerDocument;
    QScopedPointer<Poppler::Page> _popplerPage;
    QImage _pageImage;
    bool _isLoaded;

    static PdfWork *p_instance;
};
#endif // PDFWORK_H
