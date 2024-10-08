#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "scenehelper.h"
#include "Core/headcore.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    qmlRegisterType<scenehelper>("Qt3D.Examples", 2, 0, "SceneHelper");

    QQmlApplicationEngine engine;

    HeadCore carinfo;

    engine.rootContext()->setContextProperty("carinfo",&carinfo);


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

    return app.exec();
}
