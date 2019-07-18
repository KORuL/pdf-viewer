import QtQuick 2.6
import Sailfish.Silica 1.0
import "service"

ApplicationWindow {
    id: applicationWindow

    property int dpi: Screen.pixelDensity * 25.4

    function dp(x) {
        if(dpi < 120) {
            return 2*x*(dpi/72);
        } else {
            return x*(dpi/160);
        }
    }

    Dao { id: dao }

    initialPage: Qt.resolvedUrl("pages/ListPdfPage.qml")
    cover: Qt.resolvedUrl("cover/CoverPage.qml")

    allowedOrientations: Orientation.Portrait
    _defaultPageOrientations: Orientation.All
}
