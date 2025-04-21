import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import "Parts/BottomBar"
import "Parts/RightScreen"
import "Parts/LeftScreen"
import "Parts/Icons"
import "Parts"
import "qrc:/Infotainment/LayoutManager.js" as Responsive


Page {
    id: root
    width: Screen.width
    height: Screen.height
    visible: true
    title: qsTr("Infotainment")

    // Add a back button to return to the main dashboard
    Button {
        id: backButton
        anchors {
            top: parent.top
            left: parent.left
            margins: 10
        }
        text: "Back to Dashboard"
        onClicked: {
            if (stack) stack.pop()
        }
        z: 10 // Ensure it's above other elements
    }

    onWidthChanged: {
        if(adaptive)
        adaptive.updateWindowWidth(root.width)
    }

    onHeightChanged: {
        if(adaptive)
            adaptive.updateWindowHeight(root.height)
    }
    property var adaptive: new Responsive.AdaptiveLayoutManager(root.width,root.height, root.width,root.height)
    
    BottomBar {
        id: bottomBar
        onOpenLauncher: {
            if (mainScreen) mainScreen.open()
        }
    }

    LeftScreen{
        id: leftScreen
    }

    RightScreen{
        id: rightScreen
        visible: Theme.mapAreaVisible
        spacing: 0
        NavigationScreenHelper{
            Layout.fillHeight: true
            Layout.fillWidth: true
            runMenuAnimation: true
        }
    }

    // Use a Loader for MainScreen to ensure it's loaded properly
    Loader {
        id: mainScreenLoader
        anchors.fill: parent
        source: "Parts/Icons/MainScreen.qml"
        asynchronous: true
        
        onLoaded: {
            // Expose the open method from the loaded component
            mainScreen = item
        }
    }
    
    // Property to hold the reference to the MainScreen component
    property var mainScreen: null
}
