#include "headcore.h"

HeadCore::HeadCore(QObject *parent)
    : QObject{parent}
{
    m_steering  = 0.0;
    m_throttle = 0.0;
    m_xposition = 0.0;
    m_yposition = 0.0;
    m_orientation = 0.0;

    canDevice = QCanBus::instance()->createDevice("socketcan","can0",&errorString);


    if(!canDevice)
        qDebug()<<"failed to create can device:" << errorString;
        return;

    connect(canDevice,&QCanBusDevice::framesReceived,this, &HeadCore::processReceivedFrame);

    if(!canDevice->connectDevice()){
        qDebug()<< "failed to connect CAN device:" <<canDevice->errorString();
        delete canDevice;
        canDevice = nullptr;
    }
}

HeadCore::~HeadCore()
{
    if (canDevice) {
        canDevice->disconnectDevice();
        delete canDevice;
    }
}

void HeadCore::sendAdsMessages(bool onoff)
{
    QCanBusFrame frame;
    QByteArray payload;

    if(onoff){
        payload = QByteArray::fromHex("01000000");
    }else{
        payload = QByteArray::fromHex("00000000");
    }

    frame.setFrameId(adsmode_id);
    frame.setPayload(payload);
    canDevice->writeFrame(frame);
}

qreal HeadCore::steering() const
{
    return m_steering;
}

void HeadCore::setSteering(qreal newSteering)
{
    if (qFuzzyCompare(m_steering, newSteering))
        return;
    m_steering = newSteering;
    emit steeringChanged();
}

qreal HeadCore::throttle() const
{
    return m_throttle;
}

void HeadCore::setThrottle(qreal newThrottle)
{
    if (qFuzzyCompare(m_throttle, newThrottle))
        return;
    m_throttle = newThrottle;
    emit throttleChanged();
}

qreal HeadCore::xposition() const
{
    return m_xposition;
}

void HeadCore::setXposition(qreal newXposition)
{
    if (qFuzzyCompare(m_xposition, newXposition))
        return;
    m_xposition = newXposition;
    emit xpositionChanged();
}

qreal HeadCore::yposition() const
{
    return m_yposition;
}

void HeadCore::setYposition(qreal newYposition)
{
    if (qFuzzyCompare(m_yposition, newYposition))
        return;
    m_yposition = newYposition;
    emit ypositionChanged();
}

qreal HeadCore::orientation() const
{
    return m_orientation;
}

void HeadCore::setOrientation(qreal newOrientation)
{
    if (qFuzzyCompare(m_orientation, newOrientation))
        return;
    m_orientation = newOrientation;
    emit orientationChanged();
}

void HeadCore::processReceivedFrame()
{
    while(canDevice->framesAvailable()) {
        QCanBusFrame frame = canDevice->readFrame();
        QByteArray payload = frame.payload();
        for(int i= 0; i< PAYLOAD_SIZE;i++){
            data[i] = static_cast<quint8>(payload[i]);
        }

        if(frame.frameId() == steering_id){
            decryption = data[1] + data[2] *0.01;
            if(data[0] == 1){
                decryption *= -1;
            }

            setSteering(decryption);
            continue;
        }


        if(frame.frameId() == throttle_id){
            decryption = data[1] + data[2] *0.01;
            if(data[0] == 1){
                decryption *= -1;
            }

            setThrottle(decryption);
            continue;
        }



        if(frame.frameId() == xposition_id){
            decryption = data[1] + data[2] *0.01;
            if(data[0] == 1){
                decryption *= -1;
            }

            setXposition(decryption);
            continue;
        }



        if(frame.frameId() == yposition_id){
            decryption = data[1] + data[2] *0.01;
            if(data[0] == 1){
                decryption *= -1;
            }

            setYposition(decryption);
            continue;
        }


        if(frame.frameId() == oriention_id){
            decryption = data[1] + data[2] *0.01;
            if(data[0] == 1){
                decryption *= -1;
            }

            setOrientation(decryption);
            continue;
        }

    }
}
