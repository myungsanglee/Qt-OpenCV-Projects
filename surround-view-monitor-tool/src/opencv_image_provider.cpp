#include "opencv_image_provider.h"

OpencvImageProvider::OpencvImageProvider(QObject *parent) : QObject(parent), QQuickImageProvider(QQuickImageProvider::Image)
{
    connect(&timer, &QTimer::timeout, this, &OpencvImageProvider::updateImage);
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
        return emit openImage(false);
    }

    /* Convert OpenCV to QImage */
    image = QImage(frame.data, frame.cols, frame.rows, QImage::Format_RGB888).rgbSwapped();
    return emit openImage(true);
}
void OpencvImageProvider::updateImage()
{
    emit imageChanged();
}

void OpencvImageProvider::start()
{
    timer.start(1);
}

void OpencvImageProvider::stop()
{
    timer.stop();
}
