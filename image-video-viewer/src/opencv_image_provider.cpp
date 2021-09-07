#include "opencv_image_provider.h"

OpencvImageProvider::OpencvImageProvider(QObject *parent) : QObject(parent), QQuickImageProvider(QQuickImageProvider::Image)
{
    connect(&tUpdate, &QTimer::timeout, this, &OpencvImageProvider::updateImage);
}

QImage OpencvImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    Q_UNUSED(id);

    if(size){
        *size = image.size();
    }

    if(requestedSize.width() > 0 && requestedSize.height() > 0) {
        image = image.scaled(requestedSize.width(), requestedSize.height(), Qt::KeepAspectRatio);
    }

    return image;
}

void OpencvImageProvider::updateImage()
{
    if (cap.read(frame)) {
        /* Convert OpenCV to QImage */
        image = QImage(frame.data, frame.cols, frame.rows, QImage::Format_RGB888).rgbSwapped();

        emit imageChanged(true);
    }
    else {
        emit imageChanged(false);
    }
}

void OpencvImageProvider::setImage(QString image_path)
{
    /* Get Image by OpenCV */
#ifdef _WIN32
    image_path.remove(0, 8);
#elif __linux__
    image_path.remove(0, 7);
#endif
    frame = imread(image_path.toStdString());
    if (frame.empty())
    {
        cerr << "Image Loaded Fail" << endl;
        return emit imageChanged(false);
    }

    /* Convert OpenCV to QImage */
    image = QImage(frame.data, frame.cols, frame.rows, QImage::Format_RGB888).rgbSwapped();

    return emit imageChanged(true);
}

void OpencvImageProvider::setVideo(QString video_path)
{
    /* Get Video by OpenCV */
#ifdef _WIN32
    video_path.remove(0, 8);
#elif __linux__
    video_path.remove(0, 7);
#endif
    cap = VideoCapture(video_path.toStdString());
    if (!cap.isOpened())
    {
        cerr << "Video Loaded Fail" << endl;
        return emit videoStatus(false);
    }

    fps = cap.get(CAP_PROP_FPS);
    return emit videoStatus(true);
}

void OpencvImageProvider::start()
{
    tUpdate.start(1000/fps);
}

void OpencvImageProvider::stop()
{
    tUpdate.stop();
    if (cap.isOpened()) {
        cap.release();
    }
}
