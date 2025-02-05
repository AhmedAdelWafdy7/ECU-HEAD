#include "HeadUnitQtClass.hpp"

HeadUnitQtClass::HeadUnitQtClass(QObject *parent) : QObject(parent)
{
    m_steering = 0.0;
    m_throttle = 0.0;
    m_xpos = 0.0;
    m_ypos = 0.0;
    m_zpos = 0.0;
    QsensorRpm = 0;

    canDevice = QCanBus::instance()->createDevice("socketcan", "can0", &errorString); // Create a socketcan device
    if (!canDevice)
    {
        qDebug() << "Error creating device: " << errorString;
        return;
    }

    connect(canDevice, &QCanBusDevice::framesReceived, this, &HeadUnitQtClass::processFrame);

    if (!canDevice->connectDevice())
    {
        qDebug() << "Error connecting device: " << canDevice->errorString();
        delete canDevice;
        canDevice = nullptr;
    }
}

HeadUnitQtClass::~HeadUnitQtClass()
{
    if (canDevice)
    {
        canDevice->disconnectDevice();
        delete canDevice;
    }
}

qreal HeadUnitQtClass::steering() const
{
    return m_steering;
}

qreal HeadUnitQtClass::throttle() const
{
    return m_throttle;
}

qreal HeadUnitQtClass::xpos() const
{
    return m_xpos;
}

qreal HeadUnitQtClass::ypos() const
{
    return m_ypos;
}

qreal HeadUnitQtClass::zpos() const
{
    return m_zpos;
}

void HeadUnitQtClass::setSteering(qreal steering)
{
    if (qFuzzyCompare(m_steering, steering))// If the new value is the same as the old value, return
        return;

    m_steering = steering;
    emit steeringChanged();
}

void HeadUnitQtClass::setThrottle(qreal throttle)
{
    if (qFuzzyCompare(m_throttle, throttle))// If the new value is the same as the old value, return
        return;

    m_throttle = throttle;
    emit throttleChanged();
}

void HeadUnitQtClass::setXpos(qreal xpos)
{
    if (qFuzzyCompare(m_xpos, xpos))// If the new value is the same as the old value, return
        return;

    m_xpos = xpos;
    emit xposChanged();
}

void HeadUnitQtClass::setYpos(qreal ypos)
{
    if (qFuzzyCompare(m_ypos, ypos))// If the new value is the same as the old value, return
        return;

    m_ypos = ypos;
    emit yposChanged();
}

void HeadUnitQtClass::setZpos(qreal zpos)
{
    if (qFuzzyCompare(m_zpos, zpos))// If the new value is the same as the old value, return
        return;

    m_zpos = zpos;
    emit zposChanged();
}

void HeadUnitQtClass::processFrame()
{
    while (canDevice->framesAvailable())
    {
        QCanBusFrame frame = canDevice->readFrame();
        QByteArray payload = frame.payload();

        for(int i = 0; i < PAYLOAD_SIZE; i++)
        {
            data[i] = static_cast<quint8>(payload[i]);
        }

        if(frame.frameId() == steering_id)
        {
            decryption = data[1] + data[2] * 0.01;
            if(data[0] == 1)
            {
                decryption = -decryption;
            }
            setSteering(decryption);
            continue;
        }
        else if(frame.frameId() == throttle_id)
        {
            decryption = data[1] + data[2] * 0.01;
            if(data[0] == 1)
            {
                decryption = -decryption;
            }
            setThrottle(decryption);
            continue;
        }
        else if(frame.frameId() == xpos_id)
        {
            decryption = data[1] + data[2] * 0.01;
            if(data[0] == 1)
            {
                decryption = -decryption;
            }
            setXpos(decryption);
            continue;
        }
        else if(frame.frameId() == ypos_id)
        {
            decryption = data[1] + data[2] * 0.01;
            if(data[0] == 1)
            {
                decryption = -decryption;
            }
            setYpos(decryption);
            continue;
        }
        else if(frame.frameId() == zpos_id)
        {
            decryption = data[1] + data[2] * 0.01;
            if(data[0] == 1)
            {
                decryption = -decryption;
            }
            setZpos(decryption);
            continue;
        }
    }
}

Q_INVOKABLE void HeadUnitQtClass::sendAdsMessage(bool onoff)
{
    QCanBusFrame frame;
    QByteArray payload;

    if(onoff)
    {
        payload = QByteArray::fromHex("01000000");
    }
    else
    {
        payload = QByteArray::fromHex("00000000");
    }

    frame.setFrameId(adsmode_id);
    frame.setPayload(payload);
    canDevice->writeFrame(frame);
}

quint16 HeadUnitQtClass::sensorRpm() const
{
    return QsensorRpm;
}

quint16 HeadUnitQtClass::gear() const
{
    return Qgear;
}

quint16 HeadUnitQtClass::direction() const
{
    return Qdirection;
}

QString HeadUnitQtClass::light() const
{
    return Qlight;
}

void HeadUnitQtClass::setSensorRpm(uint16_t _sensorRpm)
{
    QsensorRpm = _sensorRpm;
    emit sensorRpmChanged();
}

void HeadUnitQtClass::setGear(uint16_t _gear)
{
    Qgear = _gear;
    emit gearChanged();
}

void HeadUnitQtClass::setDirection(uint16_t _direction)
{
    Qdirection = _direction;
    emit directionChanged();
}

void HeadUnitQtClass::setLight(QString _light)
{
    Qlight = _light;
    emit lightChanged();
}

