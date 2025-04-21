import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: mainScreen
    width: 1024
    height: 600
    visible: true

    // Back button to return to the main dashboard
    Button {
        id: backButton
        anchors {
            top: parent.top
            left: parent.left
            margins: 10
        }
        text: "Back"
        onClicked: {
            mainScreen.visible = false
            youtubeLoader.active = false
        }
        z: 10 // Ensure it's above other elements
        visible: youtubeLoader.active
    }
/*
    // Create a simple YouTubeSearch stub since module is not installed
    property var youTubeSearchInternal: QtObject {
        signal searchResultsReady(var results)
        signal searchStarted()
        signal searchError(string message)
        
        function searchVideos(query) {
            console.log("Search requested for:", query)
            // In a real implementation, this would make an API call
            searchStarted()
            
            // Simulate search results after a delay
            searchTimer.start()
        }
        
        property Timer searchTimer: Timer {
            interval: 1000
            onTriggered: {
                // Supply dummy search results
                var mockResults = [
                    {
                        id: { videoId: "dQw4w9WgXcQ" },
                        snippet: {
                            title: "Sample Video 1",
                            description: "This is a placeholder video description.",
                            channelTitle: "Sample Channel",
                            publishedAt: new Date().toISOString(),
                            thumbnails: {
                                medium: {
                                    url: "qrc:/image/shade.png"  // Use an existing image as placeholder
                                }
                            }
                        }
                    }
                ]
                youTubeSearchInternal.searchResultsReady(mockResults)
            }
        }
    }
*/
    function open() {
        console.log("MainScreen opened");
        mainScreen.visible = true;
        appLauncher.open();
    }

    LaunchPad {
        id: appLauncher
        anchors.centerIn: parent
        onYoutubeRequested: {
            youtubeLoader.active = true
        }
    }

    Loader {
        id: youtubeLoader
        anchors.fill: parent
        active: false
        sourceComponent: ContentsLayout {
            youTubeSearch: youTubeSearchInternal
        }
        onStatusChanged: {
            if (status === Loader.Error) {
                console.error("Failed to load:", sourceComponent.errorString());
            }
        }
    }
}