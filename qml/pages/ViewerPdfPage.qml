import QtQuick 2.6
import Sailfish.Silica 1.0
import PdfWorker 1.0


Page {
    id: page
    allowedOrientations: Orientation.All

    property var pdfPath

    Connections {
        target: PdfWork

        onSourceChanged: {
            pageSlider.value = PdfWork.currentPage
            currentPdfIm.source = ""
            currentPdfIm.source = PdfWork.getSpecificURL()
        }

        onCurrentPageChanged: {
            currentPdfIm.source = ""
            currentPdfIm.source = PdfWork.getSpecificURL()
        }

        onError: console.log(message)
    }

    SilicaFlickable {
        anchors.fill: page
        contentWidth: page.width
        contentHeight: page.height

        Image {
            id: currentPdfIm
            anchors.fill: parent
            anchors.centerIn: parent

            source: PdfWork.getSpecificURL()

            Slider {
                id: pageSlider
                visible: PdfWork.pageCount > 1
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                minimumValue: 1
                maximumValue: PdfWork.pageCount
                stepSize: 1
                valueText: qsTr("Page %1/%2").arg(value).arg(maximumValue)

                onValueChanged: {
                    PdfWork.setCurrentPage(value)
                    currentPdfIm.source = ""
                    currentPdfIm.source = PdfWork.getSpecificURL()
                }
            }
        }

        Component.onCompleted: {
            if (pdfPath !== undefined) {
                PdfWork.setSource(pdfPath)
                PdfWork.setCurrentPage(PdfWork.currentPage)
            }
        }
    }

    onStatusChanged: {
        if(status === PageStatus.Deactivating) {
            PdfWork.resetSource()
        }
    }
}
