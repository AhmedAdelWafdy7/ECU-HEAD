import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.VirtualKeyboard 2.4
import QtGraphicalEffects 1.0

ColumnLayout {
    id: searchLayout
    spacing: 10
    Layout.fillWidth: true
    Layout.preferredHeight: 70

    property var youTubeSearch
    property var webEngineView
    property bool isSearching: false

    // Virtual keyboard setup (position maintained)
    InputPanel {
        id: inputPanel
        z: 99
        width: parent.width
        anchors.bottom: parent.bottom
        visible: Qt.inputMethod.visible
    }

    // Original RowLayout structure preserved
    RowLayout {
        spacing: 10
        Layout.fillWidth: true

        // TextField (original position and structure kept)
        TextField {
            id: textField
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            placeholderText: "Search YouTube..."
            placeholderTextColor: "#666"
            font.pixelSize: 16
            selectByMouse: true
            verticalAlignment: TextInput.AlignVCenter
            leftPadding: 25
            rightPadding: 25

            // Enhanced background with animation
            background: Rectangle {
                color: "#FFFFFF"
                radius: 25
                border.color: textField.activeFocus ? "#4285f4" : "#ddd"
                border.width: textField.activeFocus ? 2 : 1
                
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    radius: 8
                    samples: 16
                    color: "#20000000"
                }

                Behavior on border.color {
                    ColorAnimation { duration: 200 }
                }
            }

            onAccepted: performSearch()
            onActiveFocusChanged: if(activeFocus) inputPanel.open(textField)

            
            Rectangle {
                visible: textField.length > 0
                anchors {
                    right: parent.right
                    rightMargin: 15
                    verticalCenter: parent.verticalCenter
                }
                width: 8
                height: 8
                radius: 4
                color: "#4285f4"
                opacity: 0.6
            }
        }

        
        Button {
            id: searchButton
            Layout.preferredWidth: 50
            Layout.preferredHeight: 50
            hoverEnabled: true
            focusPolicy: Qt.StrongFocus

            // Enhanced background with animation
            background: Rectangle {
                color: parent.down ? "#e0e0e0" : "#f8f8f8"
                radius: width / 2
                border.color: "#ddd"
                scale: parent.hovered ? 1.1 : 1.0

                Behavior on scale {
                    NumberAnimation { duration: 100 }
                }

                // New: Loading indicator
                Rectangle {
                    visible: isSearching
                    anchors.fill: parent
                    radius: width / 2
                    color: "#4285f4"
                    opacity: 0.3
                }

                SequentialAnimation on rotation {
                    running: isSearching
                    loops: Animation.Infinite
                    PropertyAnimation { to: 360; duration: 1000 }
                }
            }

            contentItem: Image {
                source: "qrc:/image/search_glass.svg"
                anchors.centerIn: parent
                sourceSize.width: 24
                sourceSize.height: 24
                opacity: parent.enabled ? 1 : 0.5
                
                // New: Color overlay
                ColorOverlay {
                    anchors.fill: parent
                    source: parent
                    color: isSearching ? "#4285f4" : "#666"
                }
            }

            onClicked: performSearch()
            ToolTip.text: "Search YouTube"
            ToolTip.visible: hovered
        }

        
        Button {
            id: clearButton
            Layout.preferredWidth: 50
            Layout.preferredHeight: 50
            hoverEnabled: true
            visible: textField.text.length > 0
            opacity: visible ? 1 : 0
            focusPolicy: Qt.StrongFocus

            // Enhanced background with animation
            background: Rectangle {
                color: parent.down ? "#e0e0e0" : "#f8f8f8"
                radius: width / 2
                border.color: "#ddd"
                scale: parent.hovered ? 1.1 : 1.0

                Behavior on scale {
                    NumberAnimation { duration: 100 }
                }
            }

            contentItem: Image {
                source: "qrc:/image/X.svg"
                anchors.centerIn: parent
                sourceSize.width: 18
                sourceSize.height: 18
                opacity: parent.enabled ? 1 : 0.5
                
                
                ColorOverlay {
                    anchors.fill: parent
                    source: parent
                    color: "#666"
                }
            }

            onClicked: {
                textField.clear()
                webEngineView.url = "about:blank"
                webEngineView.visible = false
                Qt.inputMethod.hide()
            }
            ToolTip.text: "Clear search"
            ToolTip.visible: hovered

            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }
        }
    }

    
    Text {
        id: statusMessage
        Layout.alignment: Qt.AlignHCenter
        color: "#FF4444"
        font.pixelSize: 12
        visible: false
    }

    function performSearch() {
        if(textField.text.trim().length > 0) {
            isSearching = true
            statusMessage.visible = false
            
            // Animate search button
            searchAnim.start()
            
            // Hide keyboard and reset view
            webEngineView.url = "about:blank"
            webEngineView.visible = false
            Qt.inputMethod.hide()
            
            // Execute search with error handling
            youTubeSearch.searchVideos(textField.text.trim(), function(success) {
                isSearching = false
                if (!success) {
                    statusMessage.text = "Search failed. Please try again."
                    statusMessage.visible = true
                }
            })
        }
    }

    SequentialAnimation {
        id: searchAnim
        PropertyAnimation {
            target: searchButton
            property: "scale"
            to: 0.9
            duration: 100
        }
        PropertyAnimation {
            target: searchButton
            property: "scale"
            to: 1.1
            duration: 150
        }
        PropertyAnimation {
            target: searchButton
            property: "scale"
            to: 1.0
            duration: 200
        }
    }
}