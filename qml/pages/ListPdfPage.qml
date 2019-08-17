import QtQuick 2.6
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0

import FileWork 1.0
import "../service"
import "../model"
import "../dialogs"

Page {
    id: page
    allowedOrientations: Orientation.All

    function displayPdfs() {
        listOfPdf.model.clear();
        dao.retrievepdfStatistics(function(pdfs) {
            if(pdfs.length !== 0) {
                for (var i = 0; i < pdfs.length; i++) {
                    var pdf = pdfs.item(i);
                    validator.url = pdf.path
                    if(validator.fileValid)
                        listOfPdf.model.addPdf(pdf.id, pdf.name, pdf.path, false);
                    else
                        dao.removePdf(pdf.path)
                }
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

        topMargin: Theme.paddingMedium
        spacing: Theme.paddingMedium

        header: PageHeader {
            title: qsTr("PDF List")
        }

        model: PdfListModel { id: pdfListModel }
        delegate: ListItem {

            scale: mouseArea.pressed ? 0.9 : 1.0

            Behavior on scale { NumberAnimation { duration: 100 } }

            height: textname.height + textpath.height

            Column {
                anchors.fill: parent

                Text {
                    id: textname
                    x: Theme.paddingMedium
                    width : parent.width - 2*Theme.paddingMedium
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.primaryColor
                    text: name
                    wrapMode: Text.Wrap
                }

                Text {
                    id: textpath
                    x: Theme.paddingMedium
                    width : parent.width - 2*Theme.paddingMedium
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.primaryColor
                    text: path
                    wrapMode: Text.Wrap
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("ViewerPdfPage.qml"),
                                   {pdfPath: textpath.text});
                }
            }
        }

        VerticalScrollDecorator {}

        ViewPlaceholder {
            enabled: listOfPdf.model.count == 0
            text: "You don't have any actual pdf files right now"
            hintText: "Pull down to add items"
        }

        PullDownMenu {

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
