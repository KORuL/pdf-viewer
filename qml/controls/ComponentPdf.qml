import QtQuick 2.5
import QtQuick.Window 2.2

Item {
    id: button

    property color color: "#000000"
    property alias textTitle: buttonText.text
    property alias textSubTitle: buttonText1.text
    property int dpi: Screen.pixelDensity * 25.4
    property int pixelsize: dp(40)
    property int borderwidth: dp(5)
    property bool boldd: false

    signal clicked()

    function dp(x) {
        if(dpi < 120) {
            return 2*x*(dpi/72);
        } else {
            return x*(dpi/160);
        }
    }

    width:  dp(260)
    height: dp(50)

    scale: mouseArea.pressed ? 0.9 : 1.0

    Behavior on scale { NumberAnimation { duration: 100 } }

    Rectangle {
        anchors.fill: parent
        color: button.color
        border.color: button.color
        border.width: borderwidth
        antialiasing: true
        radius: height / 5
    }

    Column {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: dp(5)

        Text {
            id: buttonText
            font.family: "Helvetica"
            font.bold: boldd
            font.pixelSize: pixelsize
            wrapMode: Text.WordWrap
            color: Qt.rgba(1, 1, 1, 1)
        }

        Text {
            id: buttonText1
            font.family: "Helvetica"
            font.bold: boldd
            font.pixelSize: pixelsize/1.2
            color: Qt.rgba(1, 1, 1, 1)
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: button.clicked()
    }
}
