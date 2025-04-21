#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QCursor>
#include <QQmlEngine>
#include <QDir>
#include "HeadUnitQtClass.hpp"


#include "Infotainment/control/hvachandler.h"
#include "Infotainment/control/audiocontroller.h"
#include "Infotainment/control/system.h"
#include "youtubesearch.h"


int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    QtWebEngine::initialize();
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);


    QCursor cursor(Qt::BlankCursor);
    app.setOverrideCursor(cursor);
    
 
    QQmlApplicationEngine engine;
    
    // Add QML import paths for the component modules
    engine.addImportPath("qrc:/Infotainment/Parts");
    engine.addImportPath("qrc:/Infotainment/Parts/Icons");
    engine.addImportPath("qrc:/Infotainment/Parts/LeftScreen");
    engine.addImportPath("qrc:/Infotainment/Parts/RightScreen");
    engine.addImportPath("qrc:/Infotainment/Parts/BottomBar");
    
    // Register C++ types
    HeadUnitQtClass carinfo;
    engine.rootContext()->setContextProperty("carinfo", &carinfo);
    qmlRegisterType<HeadUnitQtClass>("DataModule", 1, 0, "HeadUnitQtClass");
    qmlRegisterType<YouTubeSearch>("YouTubeSearch", 1, 0, "YouTubeSearch");
    
    // Create system handlers and controllers
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

    // Set context properties for system handlers
    QQmlContext *context (engine.rootContext());
    context->setContextProperty("systemHandler", &m_system_handler);
    context->setContextProperty("driverHVAC", &m_driverHVACHandler);
    context->setContextProperty("passengerHVAC", &m_passengerHVACHandler);
    context->setContextProperty("audioController", &m_audioController);
    
    // Load the main QML file
    engine.load(url);
    
    return app.exec();
}
