import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import "../"

Popup {
    id: launchPad
    width: 600
    height: 280
    modal: true
    dim: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    signal youtubeRequested()

    background: Rectangle {
        anchors.fill: parent
        radius: 9
        color: Theme.alphaColor(Theme.black, 0.8)
        layer.enabled: true
        layer.effect: DropShadow {
            radius: 8
            samples: 16
            color: "#80000000"
        }
    }

    contentItem: ColumnLayout {
        spacing: 8
        anchors.fill: parent

        Rectangle {
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            Layout.topMargin: 8
            width: parent.width - 48
            height: 1
            color: "#40FFFFFF"
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 14
            columns: 4
            columnSpacing: 14
            rowSpacing: 14

            // Row 1
            LaunchButton {
                icon.source: "qrc:/Infotainment/assets/camera.png"
                text: "Camera"
            }

            LaunchButton {
                icon.source: "qrc:/Infotainment/assets/calendar.png"
                text: "Calendar"
            }

            LaunchButton {
                icon.source: "qrc:/Infotainment/assets/icons/message.png"
                text: "Messages"
            }

            LaunchButton {
                icon.source: "qrc:/Infotainment/assets/icons/zoom.png"
                text: "Zoom"
            }

            // Row 2
            LaunchButton {
                icon.source: "qrc:/Infotainment/assets/icons/clapperboard.png"
                text: "Theater"
            }

            LaunchButton {
                icon.source: "qrc:/Infotainment/assets/spotify.png"
                text: "Spotify"
            }

            LaunchButton {
                icon.source: "qrc:/Infotainment/assets/youtube.png"
                text: "YouTube"
                onClicked: {
                    youtubeRequested()
                    close()
                }
            }

            Item { Layout.fillWidth: true } // Spacer
        }
    }

    // Animation effects
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 150 }
        NumberAnimation { property: "scale"; from: 0.9; to: 1; duration: 150 }
    }

    exit: Transition {
        NumberAnimation { property: "opacity"; to: 0; duration: 100 }
        NumberAnimation { property: "scale"; to: 0.95; duration: 100 }
    }
}