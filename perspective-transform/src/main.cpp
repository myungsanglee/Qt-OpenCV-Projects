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
    OpencvImageProvider *opencv_image_provider(new OpencvImageProvider);

    engine.rootContext()->setContextProperty("opencv_image_provider", opencv_image_provider);

    engine.addImageProvider("opencv", opencv_image_provider);

    /* Draw */
    Draw *draw(new Draw);

    engine.rootContext()->setContextProperty("draw", draw);

    /* Connect */
    QObject::connect(opencv_image_provider, &OpencvImageProvider::getDrawnImage, draw, &Draw::getDrawnImage);
    QObject::connect(draw, &Draw::drawingDone, opencv_image_provider, &OpencvImageProvider::drawingDone);
    QObject::connect(draw, &Draw::getPers, opencv_image_provider, &OpencvImageProvider::getPers);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
