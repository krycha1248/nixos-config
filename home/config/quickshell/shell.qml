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

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: root.height * 0.15
        }

        text: Qt.formatTime(new Date(), "HH:mm:ss")

        color: "#cdd6f4"

        font {
            family: "CodeNewRoman Nerd Font Mono"
            pixelSize: root.height * 0.09
            weight: Font.Normal
        }

        Text {
            id: date

            anchors {
                top: parent.bottom
                horizontalCenter: parent.horizontalCenter
                topMargin: root.height * 0.01
            }

            text: Qt.formatDate(new Date(), "dddd, d MMMM")

            color: "#a6adc8"

            font {
                family: "Inter"
                pixelSize: root.height * 0.022
                weight: Font.Normal
            }
        }

        Timer {
            interval: 1000
            running: true
            repeat: true

            onTriggered: {
                const now = new Date()

                clock.text = Qt.formatTime(now, "HH:mm:ss")
                date.text = Qt.formatDate(now, "dddd, d MMMM")
            }
        }
    }
}
