#include <QGuiApplication>
#include <QQmlApplicationEngine>
//#include "Core/headcore.h"
#include "scenehelper.h"
#include "Infotainment/control/hvachandler.h"
#include "Infotainment/control/audiocontroller.h"
#include "Infotainment/control/system.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    qmlRegisterType<scenehelper>("Qt3D.Examples", 2, 0, "SceneHelper");

    QQmlApplicationEngine engine;

//    HeadCore carinfo;

//    engine.rootContext()->setContextProperty("carinfo", &carinfo);

    System m_system_handler;
    HVACHandler m_driverHVACHandler;
    HVACHandler m_passengerHVACHandler;
    AudioController m_audioController;

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    QQmlContext *context (engine.rootContext());

    context->setContextProperty( "systemHandler" , &m_system_handler);
    context->setContextProperty( "driverHVAC" , &m_driverHVACHandler);
    context->setContextProperty( "passengerHVAC" , &m_passengerHVACHandler);
    context->setContextProperty( "audioController" , &m_audioController);


    return app.exec();
}
