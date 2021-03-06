#include "opencv_image_provider.h"

OpencvImageProvider::OpencvImageProvider(QObject *parent) : QObject(parent), QQuickImageProvider(QQuickImageProvider::Image)
{
    connect(&timer, &QTimer::timeout, this, &OpencvImageProvider::updateImage);
    warp_flag = false;
    draw_flag = false;
}

QImage OpencvImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    Q_UNUSED(id);

    if (warp_flag)
        image = warp_qimage;

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

    /* Undistortion of Image */
    cv::Mat mtx = (cv::Mat1d(3, 3) << 440.861198, 0., 960.0, 0., 440.861198, 540.0, 0., 0., 1.); // (fx, 0, cx, 0, fy, cy, 0, 0, 1)
    cv::Mat dist = (cv::Mat1d(1, 4) << -0.271749, 0.042005, 0.006296, 0.002448); // (k1, k2, p1, p2)
    int frame_height = frame.rows;
    int frame_width = frame.cols;
    cv::Mat newcameramtx = cv::getOptimalNewCameraMatrix(mtx, dist, cv::Size(frame_width, frame_height), 1, cv::Size(frame_width, frame_height));
    cv::Mat mapx, mapy;
    cv::initUndistortRectifyMap(mtx, dist, cv::Mat(), newcameramtx, cv::Size(frame_width, frame_height), CV_32FC1, mapx, mapy);

//    cv::Mat newcameramtx;
//    cv::fisheye::estimateNewCameraMatrixForUndistortRectify(mtx, dist, cv::Size(frame_width, frame_height), cv::Matx33d::eye(), newcameramtx, 1);
//    cv::fisheye::undistortImage(frame, frame, mtx, dist, newcameramtx);

    // undistortion
    cv::remap(frame, frame, mapx, mapy, cv::INTER_LINEAR);
//    cv::undistort(frame, frame, mtx, dist, newcameramtx);

    /* Convert OpenCV to QImage */
    image = QImage(frame.data, frame.cols, frame.rows, QImage::Format_RGB888).rgbSwapped();
    original_image = image.copy();
    return emit openImage(true);
}
void OpencvImageProvider::updateImage()
{
    image = original_image;
    if (draw_flag)
        emit getDrawnImage(image);
    else
        emit imageChanged();
}

void OpencvImageProvider::setWarpFlag(bool status)
{
    warp_flag = status;
}

void OpencvImageProvider::setDrawFlag(bool status)
{
    draw_flag = status;
}

void OpencvImageProvider::drawingDone()
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
    warp_flag = false;
    draw_flag = false;
}

void OpencvImageProvider::getPers(cv::Point2f *src, cv::Point2f *dst)
{
    /* Get Perspective Transformation Image */
    int tmp_width = dst[1].x + 1 ;
    int tmp_height = dst[2].y + 1;
    pers = getPerspectiveTransform(src, dst);
    warpPerspective(frame, warp_image, pers, Size(tmp_width, tmp_height), INTER_CUBIC);

    /* Convert OpenCV to QImage */
    warp_qimage = QImage(warp_image.data, warp_image.cols, warp_image.rows, QImage::Format_RGB888).rgbSwapped();

    this->setWarpFlag(true);
    this->updateImage();
}
