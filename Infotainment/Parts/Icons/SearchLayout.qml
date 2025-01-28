import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.VirtualKeyboard 2.4

ColumnLayout {
    id: searchLayout
    spacing: 10
    Layout.fillWidth: true
    Layout.preferredHeight: 60

    property var youTubeSearch
    property var webEngineView

    // Virtual keyboard setup
    InputPanel {
        id: inputPanel
        z: 99
        width: parent.width
        anchors.bottom: parent.bottom
        visible: Qt.inputMethod.visible
    }

    TextField {
        id: textField
        Layout.fillWidth: true
        Layout.preferredHeight: 50
        placeholderText: "Search YouTube..."
        placeholderTextColor: "#666"
        font.pixelSize: 16
        background: Rectangle {
            radius: 25
            border.color: "#ddd"
            border.width: 2
        }

        onAccepted: performSearch()
        onActiveFocusChanged: if(activeFocus) inputPanel.open(textField)
    }

    Button {
        id: searchButton
        Layout.preferredWidth: 50
        Layout.preferredHeight: 50
        hoverEnabled: true
        background: Rectangle {
            color: parent.down ? "#e0e0e0" : "#f8f8f8"
            radius: width / 2
            border.color: "#ddd"
        }

        contentItem: Image {
            source: "qrc:/image/search_glass.png"
            anchors.centerIn: parent
            sourceSize.width: 24
            sourceSize.height: 24
        }

        onClicked: performSearch()
    }

    Button {
        id: clearButton
        Layout.preferredWidth: 50
        Layout.preferredHeight: 50
        hoverEnabled: true
        visible: textField.text.length > 0

        background: Rectangle {
            color: parent.down ? "#e0e0e0" : "#f8f8f8"
            radius: width / 2
            border.color: "#ddd"
        }

        contentItem: Image {
            source: "qrc:/image/X.png"
            anchors.centerIn: parent
            sourceSize.width: 16
            sourceSize.height: 16
        }

        onClicked: {
            textField.clear()
            webEngineView.url = "about:blank"
            webEngineView.visible = false
            Qt.inputMethod.hide()
        }
    }

    function performSearch() {
        if(textField.text.trim().length > 0) {
            // Reset view state
            webEngineView.url = "about:blank"
            webEngineView.visible = false
            Qt.inputMethod.hide()
            
            // Execute search
            youTubeSearch.searchVideos(textField.text.trim())
        }
    }
}