#ifndef HEADUNITQTCLASS_HPP
#define HEADUNITQTCLASS_HPP

#include <string>
#include <QObject>
#include <QString>
#include <cstdlib>
#include <QCanBus>
#include <QCanBusDevice>
#include <QCanBusFrame>
#include <QDebug>

class HeadUnitQtClass : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal steering READ steering WRITE setSteering NOTIFY steeringChanged)
    Q_PROPERTY(qreal throttle READ throttle WRITE setThrottle NOTIFY throttleChanged)
    Q_PROPERTY(qreal xpos READ xpos WRITE setXpos NOTIFY xposChanged)
    Q_PROPERTY(qreal ypos READ ypos WRITE setYpos NOTIFY yposChanged)
    Q_PROPERTY(qreal zpos READ zpos WRITE setZpos NOTIFY zposChanged)
    Q_PROPERTY(qreal gear READ gear WRITE setGear NOTIFY gearChanged)
    Q_PROPERTY(qreal direction READ direction WRITE setDirection NOTIFY directionChanged)
    Q_PROPERTY(quint16 sensorRpm READ sensorRpm WRITE setSensorRpm NOTIFY sensorRpmChanged)
    Q_PROPERTY(QString light READ light WRITE setLight NOTIFY lightChanged)

private:
    qreal m_steering;
    qreal m_throttle;
    qreal m_xpos;
    qreal m_ypos;
    qreal m_zpos;
    quint16 QsensorRpm;
    quint16 Qgear;
    quint16 Qdirection;
    QString Qlight;


    quint32 steering_id = QString("0x00").toUInt(nullptr, 16);
    quint32 throttle_id = QString("0x01").toUInt(nullptr, 16);
    quint32 xpos_id = QString("0x02").toUInt(nullptr, 16);
    quint32 ypos_id = QString("0x03").toUInt(nullptr, 16);
    quint32 zpos_id = QString("0x04").toUInt(nullptr, 16);
    quint32 adsmode_id = QString("0x05").toUInt(nullptr, 16); // 0x05 is the id for the ADS mode

    QCanBusDevice *canDevice = nullptr;
    QString errorString;
    static const int PAYLOAD_SIZE = 4;
    quint8 data[PAYLOAD_SIZE];
    qreal decryption;

private slots:
    void processFrame();

public:
    explicit HeadUnitQtClass(QObject *parent = nullptr);
    ~HeadUnitQtClass();

    quint16 sensorRpm() const;
    quint16 gear() const;
    quint16 direction() const;
    QString light() const;

    void setSensorRpm(uint16_t _sensorRpm);
    void setGear(uint16_t _gear);
    void setDirection(uint16_t _direction);
    void setLight(QString _light);

    qreal steering() const;
    void setSteering(qreal steering);

    qreal throttle() const;
    void setThrottle(qreal throttle);

    qreal xpos() const;
    void setXpos(qreal xpos);

    qreal ypos() const;
    void setYpos(qreal ypos);

    qreal zpos() const;
    void setZpos(qreal zpos);

    Q_INVOKABLE void sendAdsMessage(bool onoff);

signals:
    void steeringChanged();
    void throttleChanged();
    void xposChanged();
    void yposChanged();
    void zposChanged();
    void gearChanged();
    void directionChanged();
    void sensorRpmChanged();
    void lightChanged();
};
extern HeadUnitQtClass carinfo;


#endif

