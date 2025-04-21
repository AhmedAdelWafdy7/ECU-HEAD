import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Controls 2.15
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import QtMultimedia 5.15

Window {
    id: root
    title: "Head Unit"
    width: Screen.width
    height: Screen.height
    visible: true
    color: "black"

    FontLoader {
        id: font
        source: "../font/Nebula-Regular.otf"
    }

    // Add a default carinfo property to prevent null references
    property var carinfo: QtObject {
        property real sensorRpm: 0
        property int gear: 0
    }

    ValueSource {
        id: valueSource
    }

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: container
        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 200
            }
        }
        pushExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 200
            }
        }
        popEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 100
            }
        }
        popExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 100
            }
        }
    }

    Item {
        id: container
        width: parent.width
        height: parent.height
        anchors.centerIn: parent

        // Function to calculate gear positions dynamically
        function getGearYPosition(offset) {
            return parent.height / 2 - 40 + offset  // 40 is half of the gear rectangle height
        }

        // Rectangle for "P" gear
        Rectangle {
            width: 80
            height: 80
            x: 30
            y: container.getGearYPosition(-230)
            color: (carinfo.sensorRpm === 0) ? "#555555" : "black"
            radius: 20

            Rectangle {
                width: 65
                height: 65
                anchors.centerIn: parent
                color: (valueSource.gear === 0) ? ((carinfo.sensorRpm === 0) ? "#555555" : "#B0B0B0") : "black"
                radius: 12

                Text {
                    text: "P"
                    font.family: font.name
                    font.pixelSize: 80
                    color: (valueSource.gear === 0) ? "white" : ((carinfo.sensorRpm === 0) ? "#555555" : "#B0B0B0")
                    x: 6
                    y: -14
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (carinfo.sensorRpm === 0) {
                        manager.setIPCManagerGear(0)
                    }
                }
            }
        }

        // Rectangle for "R" gear
        Rectangle {
            width: 80
            height: 80
            x: 30
            y: container.getGearYPosition(-100)
            color: (carinfo.sensorRpm === 0) ? "#555555" : "black"
            radius: 20

            Rectangle {
                width: 65
                height: 65
                anchors.centerIn: parent
                color: (valueSource.gear === 1) ? ((carinfo.sensorRpm === 0) ? "#FF6868" : "#FFCECE") : "black"
                radius: 12

                Text {
                    text: "R"
                    font.family: font.name
                    font.pixelSize: 80
                    color: (valueSource.gear === 1) ? "white" : ((carinfo.sensorRpm === 0) ? "#FF6868" : "#FFCECE")
                    x: 6
                    y: -14
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (carinfo.sensorRpm === 0) {
                        manager.setIPCManagerGear(1)
                    }
                }
            }
        }

        // Rectangle for "N" gear
        Rectangle {
            width: 80
            height: 80
            x: 30
            y: container.getGearYPosition(30)
            color: (carinfo.sensorRpm === 0) ? "#555555" : "black"
            radius: 20

            Rectangle {
                width: 65
                height: 65
                anchors.centerIn: parent
                color: (valueSource.gear === 2) ? ((carinfo.sensorRpm === 0) ? "#35CA3D" : "#AEFFAE") : "black"
                radius: 12

                Text {
                    text: "N"
                    font.family: font.name
                    font.pixelSize: 80
                    color: (valueSource.gear === 2) ? "white" : ((carinfo.sensorRpm === 0) ? "#35CA3D" : "#AEFFAE")
                    x: 6
                    y: -14
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (carinfo.sensorRpm === 0) {
                        manager.setIPCManagerGear(2)
                    }
                }
            }
        }

        // Rectangle for "D" gear
        Rectangle {
            width: 80
            height: 80
            x: 30
            y: container.getGearYPosition(160)
            color: (carinfo.sensorRpm === 0) ? "#555555" : "black"
            radius: 20

            Rectangle {
                width: 65
                height: 65
                anchors.centerIn: parent
                color: (valueSource.gear === 3) ? ((carinfo.sensorRpm === 0) ? "#555555" : "#B0B0B0") : "black"
                radius: 12

                Text {
                    text: "D"
                    font.family: font.name
                    font.pixelSize: 80
                    color: (valueSource.gear === 3) ? "white" : ((carinfo.sensorRpm === 0) ? "#555555" : "#B0B0B0")
                    x: 6
                    y: -14
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (carinfo.sensorRpm === 0) {
                        manager.setIPCManagerGear(3)
                    }
                }
            }
        }

        Image {
            id: topBar
            source: "qrc:/image/Top Bar.png"
            width: parent.width * 0.6
            height: 150
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            RowLayout {
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.1
                anchors.verticalCenter: parent.verticalCenter
                spacing: 7
                Image {
                    source: "qrc:/icons/cloud.svg"
                    width: 24
                    height: 24
                }
                Label {
                    text: qsTr("12 °C")
                    font.pixelSize: 24
                    font.bold: true
                    font.weight: Font.Normal
                    color: "#FFFFFF"
                    font.family: "TacticSans-Med"
                }
            }

            Label {
                id: timeLabel
                text: new Date().toLocaleTimeString(Qt.locale(), "hh:mm AP")
                anchors.right: parent.right
                anchors.rightMargin: parent.width * 0.1
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 24
                font.bold: true
                font.weight: Font.Normal
                font.family: "TacticSans-Med"
                color: "#FFFFFF"
            }
        }

        IconButton {
            id: rightIndicator
            roundIcon: true
            iconWidth: 45
            iconHeight: 45
            checkable: true
            setIcon: checked || (valueSource.right_on_off) ? "qrc:/icons/icons-right-checked/icon-park-solid_right-two.svg" : "qrc:/icons/icons-right/icon-park-solid_right-two.svg"
            anchors.right: parent.right
            anchors.rightMargin: parent.width * 0.025
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height * 0.04
            SequentialAnimation {
                running: rightIndicator.checked
                loops: Animation.Infinite
                OpacityAnimator {
                    target: rightIndicator.roundIcon ? rightIndicator.roundIconSource : rightIndicator.iconSource
                    from: 0
                    to: 1
                    duration: 500
                }
                OpacityAnimator {
                    target: rightIndicator.roundIcon ? rightIndicator.roundIconSource : rightIndicator.iconSource
                    from: 1
                    to: 0
                    duration: 500
                }
            }
        }

        IconButton {
            id: leftIndicator
            roundIcon: true
            iconWidth: 45
            iconHeight: 45
            checkable: true
            setIcon: checked || (valueSource.left_on_off) ? "qrc:/icons/icons-left-checked/icon-park-solid_right-two.svg" : "qrc:/icons/icons-left/icon-park-solid_right-two.svg"
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.025
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height * 0.04
            SequentialAnimation {
                running: leftIndicator.checked
                loops: Animation.Infinite
                OpacityAnimator {
                    target: leftIndicator.roundIcon ? leftIndicator.roundIconSource : leftIndicator.iconSource
                    from: 0
                    to: 1
                    duration: 500
                }
                OpacityAnimator {
                    target: leftIndicator.roundIcon ? leftIndicator.roundIconSource : leftIndicator.iconSource
                    from: 1
                    to: 0
                    duration: 500
                }
            }
        }

        RowLayout {
            anchors {
                bottom: parent.bottom
                bottomMargin: parent.height * 0.04
                right: rightIndicator.left
                rightMargin: parent.width * 0.05
            }
            IconButton {
                id: seatBreak
                roundIcon: true
                iconWidth: 45
                iconHeight: 45
                checkable: true
                setIcon: checked ? "qrc:/icons/icons-right/mdi_seatbelt.svg" : "qrc:/icons/icons-right/mdi_seatbelt.svg"
            }
            IconButton {
                id: breakParking
                roundIcon: true
                iconWidth: 45
                iconHeight: 45
                checkable: true
                setIcon: checked ? "qrc:/icons/icons-right/mdi_car-brake-parking.svg" : "qrc:/icons/icons-right/mdi_car-brake-parking.svg"
            }
            IconButton {
                id: lightDimmed
                roundIcon: true
                iconWidth: 45
                iconHeight: 45
                checkable: true
                setIcon: checked ? "qrc:/icons/icons-right/mdi_car-light-dimmed.svg" : "qrc:/icons/icons-right/mdi_car-light-dimmed.svg"
            }
            IconButton {
                id: lightHigh
                roundIcon: true
                iconWidth: 45
                iconHeight: 45
                checkable: true
                setIcon: checked ? "qrc:/icons/icons-right-checked/mdi_car-light-high.svg" : "qrc:/icons/icons-right/mdi_car-light-high.svg"
            }
            IconButton {
                id: lightFog
                roundIcon: true
                iconWidth: 45
                iconHeight: 45
                checkable: true
                setIcon: checked ? "qrc:/icons/icons-right/mdi_car-light-fog.svg" : "qrc:/icons/icons-right/mdi_car-light-fog.svg"
            }
        }

        RowLayout {
            anchors {
                left: leftIndicator.right
                leftMargin: parent.width * 0.05
                bottom: parent.bottom
                bottomMargin: parent.height * 0.04
            }
            IconButton {
                id: handbreak
                roundIcon: true
                iconWidth: 45
                iconHeight: 45
                checkable: true
                setIcon: checked ? "qrc:/icons/icons-left/mdi_car-handbrake.svg" : "qrc:/icons/icons-left/mdi_car-handbrake.svg"
            }
            IconButton {
                id: battery
                roundIcon: true
                iconWidth: 45
                iconHeight: 45
                checkable: true
                setIcon: checked ? "qrc:/icons/icons-left-checked/mdi_car-battery.svg" : "qrc:/icons/icons-left/mdi_car-battery.svg"
                SequentialAnimation {
                    running: battery.checked
                    loops: Animation.Infinite
                    OpacityAnimator {
                        target: battery.roundIcon ? battery.roundIconSource : battery.iconSource
                        from: 0
                        to: 1
                        duration: 500
                    }
                    OpacityAnimator {
                        target: battery.roundIcon ? battery.roundIconSource : battery.iconSource
                        from: 1
                        to: 0
                        duration: 500
                    }
                }
            }
            IconButton {
                id: engineBold
                roundIcon: true
                iconWidth: 45
                iconHeight: 45
                checkable: true
                setIcon: checked ? "qrc:/icons/icons-left-checked/ph_engine-bold.svg" : "qrc:/icons/icons-left/ph_engine-bold.svg"
                SequentialAnimation {
                    running: engineBold.checked
                    loops: Animation.Infinite
                    OpacityAnimator {
                        target: engineBold.roundIcon ? engineBold.roundIconSource : engineBold.iconSource
                        from: 0
                        to: 1
                        duration: 500
                    }
                    OpacityAnimator {
                        target: engineBold.roundIcon ? engineBold.roundIconSource : engineBold.iconSource
                        from: 1
                        to: 0
                        duration: 500
                    }
                }
            }
            IconButton {
                id: oil
                roundIcon: true
                iconWidth: 45
                iconHeight: 45
                checkable: true
                setIcon: checked ? "qrc:/icons/icons-left-checked/mdi_oil.svg" : "qrc:/icons/icons-left/mdi_oil.svg"
                SequentialAnimation {
                    running: oil.checked
                    loops: Animation.Infinite
                    OpacityAnimator {
                        target: oil.roundIcon ? oil.roundIconSource : oil.iconSource
                        from: 0
                        to: 1
                        duration: 500
                    }
                    OpacityAnimator {
                        target: oil.roundIcon ? oil.roundIconSource : oil.iconSource
                        from: 1
                        to: 0
                        duration: 500
                    }
                }
            }
            IconButton {
                id: tireAlert
                roundIcon: true
                iconWidth: 45
                iconHeight: 45
                checkable: true
                setIcon: checked ? "qrc:/icons/icons-left/mdi_car-tire-alert.svg" : "qrc:/icons/icons-left/mdi_car-tire-alert.svg"
            }
        }

        Image {
            id: leftgauge
            sourceSize: Qt.size(parent.height / 1.4, parent.height / 1.4)
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.1
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/image/Tacometer.png"

            CircularGauge {
                id: leftIndi
                property bool accelerating
                anchors.centerIn: parent
                width: parent.width * 0.95
                height: parent.height * 0.95
                value: valueSource.rpm
                maximumValue: 450
                style: RPMGauageStyle {}
                Component.onCompleted: forceActiveFocus()
                Behavior on value { NumberAnimation { duration: 1000 } }
                Keys.onSpacePressed: {
                    accelerating = true
                    rightGuage.accelerating = true
                }
                Keys.onReleased: {
                    if (event.key === Qt.Key_Space) {
                        accelerating = false
                        event.accepted = true
                        rightGuage.accelerating = false
                        event.accepted = true
                    }
                }
            }

            Label {
                text: "🍃Echo"
                font.bold: true
                font.weight: Font.Normal
                font.pixelSize: 22
                font.family: "TacticSans-Med"
                color: "#2BD150"
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: -10
                anchors.verticalCenterOffset: -70
                layer.effect: DropShadow {
                    anchors.fill: parent
                    horizontalOffset: 5
                    verticalOffset: 5
                    radius: 10
                    samples: 16
                    color: "white"
                }
            }
        }

        Image {
            id: rightgaugae
            sourceSize: Qt.size(parent.height / 1.55, parent.height / 1.55)
            anchors.right: parent.right
            anchors.rightMargin: parent.width * 0.03
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/image/Speedometer.png"

            CircularGauge {
                id: rightGuage
                anchors.centerIn: parent
                property bool accelerating
                width: parent.width * 1.1
                height: parent.height * 1.1
                value: valueSource.speed
                maximumValue: 450
                Behavior on value { NumberAnimation { duration: 1000 } }
                style: SpeedGauageStyle {}
            }

            Label {
                text: "🍃Echo"
                font.bold: true
                font.weight: Font.Normal
                font.pixelSize: 22
                font.family: "TacticSans-Med"
                color: "#2BD150"
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: -10
                anchors.verticalCenterOffset: -70
                layer.effect: DropShadow {
                    anchors.fill: parent
                    horizontalOffset: 5
                    verticalOffset: 5
                    radius: 10
                    samples: 16
                    color: "white"
                }
            }
        }

        IconButton {
            text: "WAFDUNIX"
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: topBar.horizontalCenter
            font.pixelSize: 16
            font.bold: Font.DemiBold
            implicitHeight: 80
            implicitWidth: 120
            setIconSize: 50
            checkable: true
            iconBackground: "transparent"
            setIconColor: "#4287f5"
            font.weight: Font.Normal
            font.family: "TacticSans-Lgt"
            onClicked: stack.push("qrc:/Infotainment/infotainment.qml")
        }
    }
}
