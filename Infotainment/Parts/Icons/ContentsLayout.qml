import QtQuick 2.12
import QtQuick.Controls 2.12
import QtWebEngine 1.8
import YouTubeSearch 1.0
import QtQuick.Layouts 1.3

ColumnLayout {
    width: 1024
    height: 600
    spacing: 0

    property var youTubeSearch: null

    // Back button
    Button {
        text: "Back"
        Layout.preferredHeight: 40
        Layout.fillWidth: true
        onClicked: {
            youTubeSearch.goBack()
        }
    }

    // YouTube search and content area
    ColumnLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 0

        
        // Search layout (25% of height)
        SearchLayout {
            id: searchLayout
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height * 0.25
            youTubeSearch: youTubeSearchInternal
            webEngineView: youtubeLayout.webEngineView
        }

        // YouTube layout (75% of height)
        YoutubeLayout {
            id: youtubeLayout
            Layout.fillWidth: true
            Layout.fillHeight: true
            youTubeSearch: youTubeSearchInternal
        }

        YouTubeSearch {
        id: youTubeSearchInternal
        }
    }
}