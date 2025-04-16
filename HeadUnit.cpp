#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QCursor>
#include "HeadUnitQtClass.hpp"


#include "Infotainment/control/hvachandler.h"
#include "Infotainment/control/audiocontroller.h"
#include "Infotainment/control/system.h"
#include "youtubesearch.h"


int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QtWebEngine::initialize();

    QCursor cursor(Qt::BlankCursor);
    app.setOverrideCursor(cursor);
    
 
    QQmlApplicationEngine engine;
    HeadUnitQtClass carinfo;
    engine.rootContext()->setContextProperty("carinfo", &carinfo);
    qmlRegisterType<HeadUnitQtClass>("DataModule", 1, 0, "HeadUnitQtClass");
    qmlRegisterType<YouTubeSearch>("YouTubeSearch", 1, 0, "YouTubeSearch");
    System m_system_handler;
    HVACHandler m_driverHVACHandler;
    HVACHandler m_passengerHVACHandler;
    AudioController m_audioController;

    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
    &app, [url](QObject *obj, const QUrl &objUrl)
    {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    QQmlContext *context (engine.rootContext());

    context->setContextProperty( "systemHandler" , &m_system_handler);
    context->setContextProperty( "driverHVAC" , &m_driverHVACHandler);
    context->setContextProperty( "passengerHVAC" , &m_passengerHVACHandler);
    context->setContextProperty( "audioController" , &m_audioController);
    
    return app.exec();
}
