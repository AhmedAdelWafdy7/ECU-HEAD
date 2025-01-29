import QtQuick 2.12
import QtQuick.Controls 2.12
import QtWebEngine 1.8
import YouTubeSearch 1.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Window 2.12

Page {
    id: contentsLayout
    anchors.fill: parent
    background: Rectangle {
        color: "#0F0F0F"
    }

    property alias webEngineView: youtubeLayout.webEngineView
    property var youTubeSearch: null
    property bool videoFullscreen: false

    ColumnLayout {
        id: mainColumn
        spacing: 0
        anchors.fill: parent


        SearchLayout {
            id: searchLayout
            Layout.fillWidth: true
            Layout.preferredHeight: videoFullscreen ? 0 : Math.min(parent.height * 0.15, 120)
            Layout.topMargin: videoFullscreen ? 0 : 10
            Layout.bottomMargin: videoFullscreen ? 0 : 10
            Layout.leftMargin: videoFullscreen ? 0 : 20
            Layout.rightMargin: videoFullscreen ? 0 : 20
            youTubeSearch: youTubeSearchInternal
            webEngineView: youtubeLayout.webEngineView
            z: 2
            visible: !videoFullscreen 

            layer.enabled: !videoFullscreen
            layer.effect: DropShadow {
                transparentBorder: true
                radius: 16
                samples: 32
                color: "#80000000"
                verticalOffset: 4
            }
        }

        // Content Divider
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#303030"
            visible: !youtubeLayout.webEngineView.visible
        }

        YoutubeLayout {
            id: youtubeLayout
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: (videoFullscreen || youtubeLayout.webEngineView.visible) ? 0 : 20
            youTubeSearch: youTubeSearchInternal
            clip: true

            Behavior on Layout.margins {
                NumberAnimation { duration: 200 }
            }
        }
    }

    Rectangle {
        id: statusOverlay
        anchors.centerIn: parent
        width: 300
        height: 60
        radius: 8
        color: "#CC1F1F1F"
        visible: false

        RowLayout {
            anchors.centerIn: parent
            spacing: 12

            BusyIndicator {
                palette.dark: "#FF0000"
                running: parent.visible
            }

            Label {
                id: statusMessage
                color: "white"
                font.pixelSize: 14
            }
        }

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }

    Button {
        id: fullscreenButton
        anchors {
            top: youtubeLayout.top
            right: youtubeLayout.right
            margins: 20
        }
        width: 40
        height: 40
        flat: true
        visible: youtubeLayout.webEngineView.visible && !videoFullscreen
        z: 1000

        background: Rectangle {
            radius: 20
            color: parent.hovered ? "#30FFFFFF" : "transparent"
        }

        contentItem: Image {
            source: videoFullscreen ? "qrc:/image/fullscreen-exit.svg" : "qrc:/image/fullscreen.svg"
            sourceSize: Qt.size(24, 24)
            ColorOverlay {
                source: parent
                color: "white"
                anchors.fill: parent
            }
        }

        onClicked: {
            contentsLayout.videoFullscreen = !contentsLayout.videoFullscreen;
        }
    }

    YouTubeSearch {
        id: youTubeSearchInternal
        onSearchStarted: showStatus("Searching...")
        onSearchFinished: hideStatus()
        onSearchError: showStatus("Search failed: " + error, true)
    }

    Component.onCompleted: {
        youtubeLayout.webEngineView.fullScreenRequested.connect(function(request) {
            if (request.toggleOn) {
                contentsLayout.videoFullscreen = true;
                request.accept();
            } else {
                contentsLayout.videoFullscreen = false;
                request.accept();
            }
        });
    }

    function showStatus(message, isError = false) {
        statusMessage.color = isError ? "#FF4444" : "white"
        statusMessage.text = message
        statusOverlay.visible = true
        statusOverlay.opacity = 1
    }

    function hideStatus() {
        statusOverlay.opacity = 0
        statusOverlay.visible = false
    }

    Shortcut {
        sequence: "Esc"
        onActivated: {
            if (contentsLayout.videoFullscreen) {
                contentsLayout.videoFullscreen = false;
            } else if (Window.window.visibility === Window.FullScreen) {
                Window.window.showNormal();
            } else if (youtubeLayout.webEngineView.visible) {
                youtubeLayout.webEngineView.visible = false;
            }
        }
    }

    Shortcut {
        sequences: ["Ctrl+K", "Meta+K"]
        onActivated: searchLayout.textField.forceActiveFocus()
    }
}