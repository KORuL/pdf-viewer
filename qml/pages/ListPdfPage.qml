import QtQuick 2.6
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0

import FileWork 1.0
import "../controls" as Controls
import "../service"
import "../model"
import "../dialogs"

Page {
    id: page
    allowedOrientations: Orientation.All

    function displayPdfs() {
        listOfPdf.model.clear();
        dao.retrievepdfStatistics(function(pdfs) {
            ifNoPdf.text = "";
            if(pdfs.length !== 0) {
                for (var i = 0; i < pdfs.length; i++) {
                    var pdf = pdfs.item(i);
                    validator.url = pdf.path
                    if(validator.fileValid)
                        listOfPdf.model.addPdf(pdf.id, pdf.name, pdf.path, false);
                    else
                        dao.removePdf(pdf.path)
                }
            } else {
                ifNoPdf.text = qsTr("You don't have any actual pdf files right now");
            }
        });
    }

    FileValidator {
        id: validator
        url: ""
        treatAsImage: false
    }

    SilicaListView {
        id: listOfPdf
        anchors.fill: page

        topMargin: 15
        spacing: 15
        clip: true

        contentWidth: page.width
        contentHeight: page.height

        header: PageHeader {
            title: qsTr("PDF List")
        }

        model: PdfListModel { id: pdfListModel }
        delegate: ListItem {
            Controls.ComponentPdf {
                anchors.horizontalCenter: parent.horizontalCenter

                pixelsize: dp(15)
                width: dp(320)
                textTitle: name
                textSubTitle: path
                color: "#722164"
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("ViewerPdfPage.qml"),
                                   {pdfPath: path});
                }
            }
        }

        VerticalScrollDecorator {}

        Label {
            id: ifNoPdf
            color: Theme.secondaryHighlightColor
            y: page.height / 2
            anchors.horizontalCenter: parent.horizontalCenter
        }

        PushUpMenu {
            quickSelect: true
        }

        PullDownMenu {
            quickSelect: true

            MenuItem {
                text: qsTr("Select documents")
                onClicked: {
                    pageStack.push(multiFilePickerDialog)
                }
            }

            MenuItem {
                text: qsTr("Delete documents from list")
                visible: listOfPdf.model.count > 0
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("../dialogs/DeletePdfs.qml"));
                }
            }
        }

        Component.onCompleted: displayPdfs()
    }

    Component {
        id: multiFilePickerDialog
        MultiFilePickerDialog {
            nameFilters: [ '*.pdf' ]

            onDone: {
                if (result == DialogResult.Accepted) {
                    for (var i = 0; i < selectedContent.count; ++i) {
                        var url = selectedContent.get(i).url
                        var name = selectedContent.get(i).fileName
                        dao.createPdf(name, url)
                    }
                    displayPdfs()
                    listOfPdf.update()
                }
            }
        }
    }

    onStatusChanged: {
        if(status === PageStatus.Activating) {
            displayPdfs()
        }
    }
}
