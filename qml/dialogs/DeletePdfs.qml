import QtQuick 2.0
import Sailfish.Silica 1.0

import "../model"

Dialog {
    id: dialog

    allowedOrientations: Orientation.All
    canAccept: true

    function displayPdfs() {
        listOfPdfToDelete.model.clear();
        dao.retrievepdfStatistics(function(pdfs) {
            if(pdfs.length !== 0) {
                for (var i = 0; i < pdfs.length; i++) {
                    var pdf = pdfs.item(i);
                    listOfPdfToDelete.model.addPdf(pdf.id, pdf.name, pdf.path, false);
                }
            }
        });
    }

    SilicaListView {
        id: listOfPdfToDelete
        anchors.fill: dialog

        topMargin: Theme.paddingLarge
        spacing: Theme.paddingLarge

        header: PageHeader {
            title: qsTr("Select PDFs to delete")
        }

        model: PdfListModel { id: pdfListModel }
        delegate: ListItem {
            property int indexOfThisDelegate: index

            TextSwitch {
                id: textSwitch
                text: name
                description: path

                onCheckedChanged: {
                    listOfPdfToDelete.model.get(indexOfThisDelegate).checked = checked
                }
            }
        }

        VerticalScrollDecorator {}

        ViewPlaceholder {
            enabled: listOfPdfToDelete.model.count == 0
            text: "You don't have any actual pdf files right now"
            hintText: "Pull down to add items"
        }

        Component.onCompleted: displayPdfs()
    }

    onDone: {
        if (result == DialogResult.Accepted) {
            for (var i = 0; i < listOfPdfToDelete.model.count; i++) {
                if(listOfPdfToDelete.model.get(i).checked)
                    dao.removePdf(listOfPdfToDelete.model.get(i).path)
            }
        }
    }
}
