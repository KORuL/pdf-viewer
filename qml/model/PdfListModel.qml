import QtQuick 2.0

ListModel {
    function addPdf(id, name, path, checked) {
        append({
                   id: id,
                   name: name,
                   path: path,
                   checked: checked
               });
    }
}
