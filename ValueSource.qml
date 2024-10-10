import QtQuick 2.9

Item {
    id: valueSource

    property real steering: carinfo.steering

    property bool blink: !(valueSource.steering > -0.5 && valueSource.steering < 0.5)
    property bool left_dirction: (valueSource.steering < -0.5)
    property bool right_direction: (valueSource.steering > 0.5)

    property bool left_on_off: false
    property bool right_on_off: false

    onSteeringChanged: {
        valueSource.blink = !(valueSource.steering > -0.5 && valueSource.steering < 0.5);
        valueSource.left_dirction = (valueSource.steering < -0.5);
        valueSource.right_direction = (valueSource.steering > 0.5);
        if(valueSource.emergency){
            valueSource.left_on_off = false;
            valueSource.right_on_off = false;
        }
    }

    function blinking_direction(){
        if(valueSource.left_dirction){
            valueSource.left_on_off = !valueSource.left_on_off
        }

        if(valueSource.right_direction){
            valueSource.right_on_off = !valueSource.right_on_off
        }
    }

    Timer {
        interval:500; running: (valueSource.blink && !valueSource.emergency); repeat: true
        onTriggered: {
            valueSource.blinking_direction()
        }
    }

    property bool emergency: false
    property bool emergency_on_off: false

    onEmergencyChanged: {
        valueSource.left_on_off = false;
        valueSource.right_on_off = false;
        valueSource.emergency_on_off = false;
    }

    function blinking_emergency() {
        valueSource.left_on_off = !valueSource.left_on_off
        valueSource.right_on_off = !valueSource.right_on_off
        valueSource.emergency_on_off = !valueSource.emergency_on_off
    }

    Timer {
        interval: 500; running: valueSource.emergency; repeat: true
        onTriggered: {
            valueSource.blinking_emergency()
        }
    }


    property string light: "#808080"

    property int red: 128
    property int green: 128
    property int blue: 128
    property string red_string: "80"
    property string green_string: "80"
    property string blue_string: "80"


    property bool gps: false
    property bool ads: false

    onAdsChanged: {
        carinfo.sendAdsMessages(valueSource,ads);
    }
}
