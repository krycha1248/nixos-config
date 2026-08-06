import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"

    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    Text {
        id: clock

        anchors.centerIn: parent

        text: Qt.formatTime(new Date(), "HH:mm:ss")

        color: "#cdd6f4"

        font {
            family: "CodeNewRoman Nerd Font Mono"
            pixelSize: 96
            weight: Font.Normal
        }

        Timer {
            interval: 1000
            running: true
            repeat: true

            onTriggered: {
                clock.text = Qt.formatTime(new Date(), "HH:mm:ss")
                date.text = Qt.formatDate(new Date(), "dddd, d MMMM")
            }
        }

        Text {
            id: date

            anchors {
                top: parent.bottom
                horizontalCenter: parent.horizontalCenter
                topMargin: 8
            }

            text: Qt.formatDate(new Date(), "dddd, d MMMM")

            color: "#a6adc8"

            font {
                family: "Inter"
                pixelSize: 22
                weight: Font.Normal
            }
        }
    }
}
