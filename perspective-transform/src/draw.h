#ifndef DRAW_H
#define DRAW_H

#include <QObject>
#include <QImage>
#include <QPainter>
#include <QDebug>
#include <opencv2/opencv.hpp>
#include <QJSValue>

using namespace std;
using namespace cv;

typedef struct
{
    QPoint point;
    bool hover;
} FsPoint;

class Draw : public QObject
{
    Q_OBJECT
public:
    explicit Draw(QObject *parent = nullptr);

    void drawPoint(vector<FsPoint> &points);
    void checkPointHover();
    bool getPointHover(QPoint &point, QPoint &mouse_point);
    void updatePoint();
    void drawPolygon(vector<FsPoint> &points);
    void drawText(vector<FsPoint> &points);
    void drawing();
    void getSortedCvPoints(vector<FsPoint> &points, Point2f *dst);

    Q_INVOKABLE void reset();
    Q_INVOKABLE void setPoint(float rate_x, float rate_y);
    Q_INVOKABLE void setMousePoint(float rate_x, float rate_y);
    Q_INVOKABLE void setMoveFlag(bool flag);
    Q_INVOKABLE void appendPoints();
    Q_INVOKABLE void getResult();
    Q_INVOKABLE void setSrcPoints(QVariant data);
    Q_INVOKABLE void setDstPoints(QVariant data);

public slots:
    void getDrawnImage(QImage &img);

signals:
    void moveFlag();
    void drawingDone();
    void signalReset();
    void showResult();
    void getPers(cv::Point2f *src, cv::Point2f *dst);

private:
    QImage image;
    QPainter painter;
    float width, height;
    QPoint mouse_point;
    QPen point_pen, line_pen, hover_pen, text_pen, rect_pen;
    QBrush rect_brush;
    int point_num, max_point_num;
    bool move_flag;

    vector<FsPoint> points;
    vector<vector<FsPoint>> points_vector;
    Point2f srcQuad[4], dstQuad[4];
};

#endif // DRAW_H
