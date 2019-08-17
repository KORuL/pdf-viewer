import Sailfish.Silica 1.0
import QtQuick 2.0
import PdfWorker 1.0

CoverBackground {

    Connections {
        target: PdfWork

        onError: {
            labelError.text = message
            console.log(message)
        }

        onSourceChanged: {
            labelError.update()
            coverPdfImage.source = ""
            coverPdfImage.source = PdfWork.getSpecificURL()
        }
    }

    Label {
        id: label
        anchors.centerIn: parent

        visible: PdfWork.isLoaded != true
        text: qsTr("PDF Viewer")
        font.pixelSize: Theme.fontSizeLarge
    }

    Label {
        id: labelError
        anchors.top: label.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: Theme.paddingMedium

        visible: PdfWork.isLoaded != true
        text: qsTr("PDF not selected")
        font.pixelSize: Theme.fontSizeMedium
    }

    Image {
        id: coverPdfImage

        anchors.fill: parent
        anchors.centerIn: parent
        source: if(PdfWork.isLoaded == true) PdfWork.getSpecificURL()
    }

    CoverActionList {
        id: coverActionButs

        CoverAction {
            iconSource: "image://theme/icon-cover-previous"

            onTriggered: {
                if(PdfWork.isLoaded == true) {
                    var prevPage = PdfWork.currentPage - 1
                    PdfWork.currentPage = Math.max(0, prevPage)
                    coverPdfImage.source = PdfWork.getSpecificURL()
                }
            }
        }
        CoverAction {
            iconSource: "image://theme/icon-cover-next"

            onTriggered: {
                if(PdfWork.isLoaded == true) {
                    var prevPage = PdfWork.currentPage + 1
                    PdfWork.currentPage = Math.min(PdfWork.pageCount, prevPage)
                    coverPdfImage.source = PdfWork.getSpecificURL()
                }
            }
        }
    }

    onStatusChanged: {
        if(status === Cover.Activating) {
            coverPdfImage.source = ""
            coverPdfImage.source = PdfWork.getSpecificURL()
        }
    }
}
