import QtQuick 2.0
import QtQuick.LocalStorage 2.0

Item {
    property var database
    property var pdfStatistics

    Component.onCompleted: {
        database = LocalStorage.openDatabaseSync("PdfListDatabase", "1.0")
//        database.transaction(function(tx) {
//            tx.executeSql("DROP TABLE PdfListTable");
//        });
        database.transaction(function(tx) {
            tx.executeSql("CREATE TABLE IF NOT EXISTS PdfListTable(
                 id INTEGER PRIMARY KEY AUTOINCREMENT,
                 name TEXT,
                 path TEXT NOT NULL UNIQUE)");
        });
        updateStatisticsValue();
    }

    function updateStatisticsValue() {
        retrievepdfStatistics(function(result) {
            if (result !== null) {
                pdfStatistics = result;
            } else {
                pdfStatistics = 0
            }
        });
    }

    function retrievepdfStatistics(callback) {
        database = LocalStorage.openDatabaseSync("PdfListDatabase", "1.0");
        database.readTransaction(function(tx) {
            var result = tx.executeSql("SELECT * FROM PdfListTable ORDER BY id ASC");
            callback(result.rows)
        });
    }

    function createPdf(name, path) {
        database = LocalStorage.openDatabaseSync("PdfListDatabase", "1.0");
        database.transaction(function(tx) {
            tx.executeSql("INSERT OR IGNORE INTO PdfListTable(name, path)
                                VALUES(?, ?)", [name, path]);
        });
        updateStatisticsValue();
    }

    function removePdfById(id) {
        database = LocalStorage.openDatabaseSync("PdfListDatabase", "1.0");
        database.transaction(function(tx) {
            tx.executeSql("DELETE FROM PdfListTable WHERE id = ?", [id]);
        });
        updateStatisticsValue();
    }

    function removePdf(path) {
        database = LocalStorage.openDatabaseSync("PdfListDatabase", "1.0");
        database.transaction(function(tx) {
            tx.executeSql("DELETE FROM PdfListTable WHERE path = ?", [path]);
        });
        updateStatisticsValue();
    }
}
