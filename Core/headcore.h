#ifndef HEADCORE_H
#define HEADCORE_H

#include <QObject>
#include <QCanBus>
#include <QCanBusDevice>
#include <QCanBusFrame>
#include <QDebug>



class HeadCore : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal steering READ steering WRITE setSteering NOTIFY steeringChanged FINAL)
    Q_PROPERTY(qreal throttle READ throttle WRITE setThrottle NOTIFY throttleChanged FINAL)
    Q_PROPERTY(qreal xposition READ xposition WRITE setXposition NOTIFY xpositionChanged FINAL)
    Q_PROPERTY(qreal yposition READ yposition WRITE setYposition NOTIFY ypositionChanged FINAL)
    Q_PROPERTY(qreal orientation READ orientation WRITE setOrientation NOTIFY orientationChanged FINAL)
public:
    explicit HeadCore(QObject *parent = nullptr);
    ~HeadCore();
    Q_INVOKABLE void sendAdsMessages(bool onoff);

    qreal steering() const;
    void setSteering(qreal newSteering);

    qreal throttle() const;
    void setThrottle(qreal newThrottle);

    qreal xposition() const;
    void setXposition(qreal newXposition);

    qreal yposition() const;
    void setYposition(qreal newYposition);

    qreal orientation() const;
    void setOrientation(qreal newOrientation);

signals:
    void steeringChanged();
    void throttleChanged();

    void xpositionChanged();

    void ypositionChanged();

    void orientationChanged();

private:
    qreal m_steering;
    qreal m_throttle;
    qreal m_xposition;
    qreal m_yposition;
    qreal m_orientation;
    quint32 steering_id = QString("0x00").toUInt(nullptr, 16);
    quint32 throttle_id = QString("0x01").toUInt(nullptr, 16);
    quint32 xposition_id = QString("0x02").toUInt(nullptr, 16);
    quint32 yposition_id = QString("0x03").toUInt(nullptr, 16);
    quint32 oriention_id = QString("0x04").toUInt(nullptr, 16);
    quint32 adsmode_id = QString("0x05").toUInt(nullptr, 16);

    QCanBusDevice *canDevice = nullptr;
    QString errorString;
    static const int PAYLOAD_SIZE = 4;
    quint8  data[PAYLOAD_SIZE];
    qreal decryption;

private slots:
    void processReceivedFrame();
};

#endif // HEADCORE_H
