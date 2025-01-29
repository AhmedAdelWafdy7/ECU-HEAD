import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: mainScreen
    width: 1024
    height: 600
    visible: true

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