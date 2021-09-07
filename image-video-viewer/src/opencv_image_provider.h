#ifndef OPENCVIMAGEPROVIDER_H
#define OPENCVIMAGEPROVIDER_H

#include <QObject>
#include <QQuickImageProvider>
#include <QImage>
#include <opencv2/opencv.hpp>
#include <iostream>
#include <QtDebug>
#include <QTimer>

using namespace cv;
using namespace std;

class OpencvImageProvider : public QObject, public QQuickImageProvider
{
    Q_OBJECT
public:
    explicit OpencvImageProvider(QObject *parent = nullptr);

    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;

    void updateImage();

    Q_INVOKABLE void setImage(QString image_path);
    Q_INVOKABLE void setVideo(QString video_path);
    Q_INVOKABLE void start();
    Q_INVOKABLE void stop();

public slots:

signals:
    void imageChanged(bool status);
    void videoStatus(bool status);

private:
    QImage image;
    Mat frame;
    VideoCapture cap;
    float fps;
    QTimer tUpdate;

};

#endif // OPENCVIMAGEPROVIDER_H
