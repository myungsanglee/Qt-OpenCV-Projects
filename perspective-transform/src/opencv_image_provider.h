#ifndef OPENCVIMAGEPROVIDER_H
#define OPENCVIMAGEPROVIDER_H

#include <QObject>
#include <QQuickImageProvider>
#include <QImage>
#include <QPainter>
#include <QPen>
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

    Q_INVOKABLE void setImage(QString image_path);
    Q_INVOKABLE void start();
    Q_INVOKABLE void stop();

    /* For draw */
    Q_INVOKABLE void setWarpFlag(bool status);
    Q_INVOKABLE void setDrawFlag(bool status);

public slots:
    void updateImage();

    /* For draw */
    void drawingDone();
    void getPers(cv::Point2f *src, cv::Point2f *dst);

signals:
    void imageChanged();

    /* For draw */
    void getDrawnImage(QImage &img);
    void openImage(bool state);

private:
    QImage image, original_image, warp_qimage;
    Mat frame, warp_image, pers;
    QTimer timer;

    /* For draw */
    bool warp_flag, draw_flag;
};

#endif // OPENCVIMAGEPROVIDER_H
