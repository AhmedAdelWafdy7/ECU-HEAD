import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtWebEngine 1.8

GridLayout{
    id: root
    width: parent.width
    height: parent.height
    columns: 1

    property var youTubeSearch
    property var searchResults

    property alias webEngineView: webEngineView

    Connections{
        target: youTubeSearch
        onSearchResultReady: function(results){ 
            searchResults = results;
            webEngineView.visible = false;
        }
    }

    ListView {
        id: listView
        Layout.fillWidth: true
        Layout.fillHeight: true
        model: searchResults
        spacing: 5
        visible: !webEngineView.visible

        delegate: Rectangle {
            width: listView.width
            height: 100
            color: "black"
            radius: 4


            Image {
                id: thumbnail
                source: modelData.snippet.thumbnails.medium.url
                width: 160
                height: 90
                anchors{
                    left: parent.left
                    leftMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                fillMode: Image.PreserveAspectFit
            }

            Text {
                text: modelData.snippet.title
                color: "white"
                font.pixelSize: 14
                elide: Text.ElideRight
                maximumLineCount: 2
                wrapMode: Text.Wrap
                anchors{
                    left: thumbnail.right
                    margins: 10
                    right: parent.right
                    top: parent.top
                }
            }
            Text {
                text: modelData.snippet.channelTitle
                color: "#AAAAAA"
                font.pixelSize: 12
                anchors {
                    left: thumbnail.right
                    right: parent.right
                    bottom: parent.bottom
                    margins: 10
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    var videoId = modelData.id.videoId || modelData.id;
                    webEngineView.url = "https://www.youtube.com/embed/" + videoId + "?autoplay=1";
                    webEngineView.visible = true;
                }
            }
        }
    }

    WebEngineView {
        id: webEngineView
        Layout.fillWidth: true
        Layout.fillHeight: true
        visible: false
        settings.pluginsEnabled: true
        settings.playbackRequiresUserGesture: false

        Button{
            anchors{
                top: parent.top
                right: parent.right
                margins: 10
            }
            text: "Back to search"
            onClicked: parent.visible = false
            background: Rectangle {
                color: "#AA000000"
                radius: 4
            }

            contentItem: Text {
                text: parent.text
                color: "white"
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
