import QtQuick 2.6
import Sailfish.Silica 1.0
import "service"

ApplicationWindow {
    id: applicationWindow

    Dao { id: dao }

    initialPage: Qt.resolvedUrl("pages/ListPdfPage.qml")
    cover: Qt.resolvedUrl("cover/CoverPage.qml")

    allowedOrientations: Orientation.Portrait
    _defaultPageOrientations: Orientation.All
}
