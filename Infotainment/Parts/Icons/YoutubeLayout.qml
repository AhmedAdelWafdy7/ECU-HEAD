import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtWebEngine 1.8

ColumnLayout {
    id: youtubeLayout
    anchors.top: SearchLayout.bottom
    spacing: 0

    Layout.fillWidth: true
    Layout.fillHeight: true
    property var youTubeSearch
    property var searchResults
    property string currentVideoTitle: ""

    property alias webEngineView: webEngineView

    Connections {
        target: youTubeSearch
        onSearchResultsReady: function(results) {
            searchResults = results;
            webEngineView.visible = false;
            searchBusy.running = false;
        }
    }

    
    ColumnLayout {
        visible: webEngineView.visible
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 5
            Layout.leftMargin: 10
            spacing: 15

            Button {
                text: "◄ Back to Results"
                font.pixelSize: 14
                flat: true
                contentItem: Text {
                    text: parent.text
                    color: "#fff"
                    font: parent.font
                    horizontalAlignment: Text.AlignLeft
                }
                background: Rectangle {
                    color: "transparent"
                }
                onClicked: webEngineView.visible = false
            }

            Text {
                text: currentVideoTitle
                color: "white"
                font.pixelSize: 16
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }

       
        BusyIndicator {
            running: webEngineView.loading
            visible: running
            Layout.alignment: Qt.AlignCenter
            palette.dark: "#fff"
        }

        Text {
            id: errorText
            visible: false
            text: "❌ Failed to load video"
            color: "#ff4444"
            font.pixelSize: 16
            Layout.alignment: Qt.AlignCenter
        }
    }

    ListView {
        id: listView
        Layout.fillWidth: true
        Layout.fillHeight: true
        visible: !webEngineView.visible
        model: searchResults
        spacing: 10
        clip: true

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
            width: 8
            background: Rectangle { color: "transparent" }
            contentItem: Rectangle {
                color: "#666"
                radius: 4
            }
        }

        delegate: Rectangle {
            width: listView.width - 20
            height: 150
            radius: 12
            color: mouseArea.containsMouse ? "#2c2c2c" : "#202020"
            anchors.horizontalCenter: parent.horizontalCenter

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 15

                // Thumbnail
                Rectangle {
                    Layout.preferredWidth: 213  // 16:9 aspect ratio
                    Layout.preferredHeight: 120
                    radius: 8
                    color: "#3500EA"
                    clip: true

                    Image {
                        id: thumbnail
                        source: modelData.snippet.thumbnails.medium.url
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                        opacity: status === Image.Ready ? 1 : 0.3
                        Behavior on opacity { NumberAnimation { duration: 200 } }
                    }

                    BusyIndicator {
                        anchors.centerIn: parent
                        running: thumbnail.status === Image.Loading
                        width: 32
                        height: 32
                    }
                }

                // Video Info
                ColumnLayout {
                    spacing: 8
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Text {
                        text: modelData.snippet.title
                        color: "#fff"
                        font.pixelSize: 16
                        font.bold: true
                        wrapMode: Text.Wrap
                        maximumLineCount: 2
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    ColumnLayout {
                        spacing: 6

                        Row {
                            spacing: 8
                            Image {
                                source: "qrc:/image/channel.svg"
                                width: 16
                                height: 16
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Text {
                                text: modelData.snippet.channelTitle
                                color: "#aaa"
                                font.pixelSize: 14
                                elide: Text.ElideRight
                            }
                        }

                        Row {
                            spacing: 8
                            Image {
                                source: "qrc:/image/calendar.svg"
                                width: 16
                                height: 16
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Text {
                                text: Qt.formatDateTime(modelData.snippet.publishedAt, "MMM d, yyyy")
                                color: "#aaa"
                                font.pixelSize: 14
                            }
                        }
                    }

                    Text {
                        text: modelData.snippet.description
                        color: "#888"
                        font.pixelSize: 14
                        wrapMode: Text.WordWrap
                        maximumLineCount: 2
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    currentVideoTitle = modelData.snippet.title;
                    webEngineView.url = "https://www.youtube.com/embed/" + modelData.id.videoId + "?autoplay=1";
                    webEngineView.visible = true;
                    errorText.visible = false;
                }
            }
        }
    }

    BusyIndicator {
        id: searchBusy
        running: searchResults === undefined && !webEngineView.visible
        visible: running
        Layout.alignment: Qt.AlignCenter
        palette.dark: "#fff"
    }

    WebEngineView {
            id: webEngineView
            Layout.fillWidth: true
            Layout.fillHeight: true
            backgroundColor: "#000"

            onLoadingChanged: {
                if (loadRequest.status === WebEngineLoadRequest.LoadFailedStatus) {
                    errorText.visible = true;
                }
            }
        }
}