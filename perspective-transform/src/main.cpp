#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlComponent>
#include "opencv_image_provider.h"
#include "draw.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    /* OpencvImageProvider */
    OpencvImageProvider *provider(new OpencvImageProvider);

    engine.rootContext()->setContextProperty("opencvProvider", provider);

    engine.addImageProvider("opencv", provider);

    /* Draw */
    Draw *draw(new Draw);

    engine.rootContext()->setContextProperty("draw", draw);

    /* Connect */
    QObject::connect(provider, &OpencvImageProvider::getDrawnImage, draw, &Draw::getDrawnImage);
    QObject::connect(draw, &Draw::drawingDone, provider, &OpencvImageProvider::drawingDone);
    QObject::connect(draw, &Draw::getPers, provider, &OpencvImageProvider::getPers);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
