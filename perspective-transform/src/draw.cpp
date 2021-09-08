#include "draw.h"

Draw::Draw(QObject *parent) : QObject(parent)
{
    point_pen.setWidth(10);
    point_pen.setColor(QColor("black"));
    point_pen.setJoinStyle(Qt::RoundJoin);
    point_pen.setCapStyle(Qt::RoundCap);

    hover_pen.setWidth(10);
    hover_pen.setColor(QColor("darkGray"));
    hover_pen.setJoinStyle(Qt::RoundJoin);
    hover_pen.setCapStyle(Qt::RoundCap);

    line_pen.setWidth(3);
    line_pen.setColor(QColor("darkGreen"));
    line_pen.setJoinStyle(Qt::RoundJoin);
    line_pen.setCapStyle(Qt::RoundCap);

    text_pen.setWidth(1);
    text_pen.setColor(QColor("red"));

    rect_pen.setWidth(1);
    rect_pen.setColor(QColor("black"));

    rect_brush.setStyle(Qt::SolidPattern);

    point_num = 0;
    max_point_num = 4;
    move_flag = false;
}

void Draw::drawPoint(vector<FsPoint> &points)
{
    painter.begin(&image);

    for (int i = 0; i < points.size(); i++) {
        painter.setPen(point_pen);

        FsPoint fs_point = points[i];

        if (fs_point.hover) {
            painter.setPen(hover_pen);
        }
        painter.drawPoint(fs_point.point);

    }

    painter.end();

    if (points.size() >= 4)
        this->drawPolygon(points);

    this->drawText(points);
}

void Draw::checkPointHover()
{
    for (int i = 0; i < points.size(); i++) {

        FsPoint *fs_point = &points[i];

        if (this->getPointHover(fs_point->point, mouse_point)) {
            fs_point->hover = true;
            break;
        }
        fs_point->hover = false;
    }
    this->drawing();
}

bool Draw::getPointHover(QPoint &point, QPoint &mouse_point)
{
    int point_x = point.x();
    int point_y = point.y();
    int mouse_point_x = mouse_point.x();
    int mouse_point_y = mouse_point.y();
    int margin = 10;

    if (mouse_point_x >= point_x - margin && mouse_point_x <= point_x + margin) {
        if (mouse_point_y >= point_y - margin && mouse_point_y <= point_y + margin) {
            return true;
        }
    }

    return false;
}

void Draw::updatePoint()
{
    for (int i = 0; i < points.size(); i++) {

        FsPoint *fs_point = &points[i];

        if (fs_point->hover) {
            fs_point->point = mouse_point;
            break;
        }
    }

    this->drawing();
}

void Draw::drawPolygon(vector<FsPoint> &points)
{
    painter.begin(&image);
    painter.setPen(line_pen);

    QPointF tmp_points[4];
    for (int i = 0; i < points.size(); i++) {

        FsPoint fs_point = points[i];

        tmp_points[i] = fs_point.point;
    }

    painter.drawPolygon(tmp_points, 4);
    painter.end();
}

void Draw::drawText(vector<FsPoint> &points)
{
    painter.begin(&image);

    for (int i = 0; i < points.size(); i++) {
        FsPoint fs_point = points[i];

        string str = "(" + to_string(fs_point.point.x()) + ", " + to_string(fs_point.point.y()) + ")";
        QString qstr = QString::fromStdString(str);
        QRect rect = QRect(fs_point.point.x() - 25, fs_point.point.y() - 20, 54, 13);

        painter.setBrush(rect_brush);
        painter.setPen(rect_pen);
        painter.drawRect(rect);

        painter.setPen(text_pen);
        painter.drawText(rect, Qt::AlignCenter, qstr);
    }

    painter.end();
}

void Draw::drawing()
{
    vector<FsPoint> fs_point;
    for (int i = 0; i < points_vector.size(); i++) {
        fs_point = points_vector[i];
        drawPoint(fs_point);
    }

    if (points.size() > 0){
        drawPoint(points);
    }
}

void Draw::getSortedCvPoints(vector<FsPoint> &points, Point2f *dst)
{
    Point2f left_top, right_top, right_bottom, left_bottom;
    vector<pair<int, int>> y_vector;
    vector<QPoint> top_vector, bottom_vector;

    for (int i = 0; i < points.size(); i++) {
        FsPoint fs_point = points[i];
        y_vector.push_back(pair<int, int>(fs_point.point.y(), i));
    }

    sort(y_vector.begin(), y_vector.end());

    for (int i = 0; i < y_vector.size(); i++) {
        if (i < 2) {
            top_vector.push_back(points[y_vector[i].second].point);
        }
        else {
            bottom_vector.push_back(points[y_vector[i].second].point);
        }
    }

    if (top_vector[0].x() < top_vector[1].x()) {
        left_top = Point2f(top_vector[0].x(), top_vector[0].y());
        right_top = Point2f(top_vector[1].x(), top_vector[1].y());
    }
    if (top_vector[0].x() > top_vector[1].x()) {
        left_top = Point2f(top_vector[1].x(), top_vector[1].y());
        right_top = Point2f(top_vector[0].x(), top_vector[0].y());
    }
    if (bottom_vector[0].x() < bottom_vector[1].x()) {
        left_bottom = Point2f(bottom_vector[0].x(), bottom_vector[0].y());
        right_bottom = Point2f(bottom_vector[1].x(), bottom_vector[1].y());
    }
    if (bottom_vector[0].x() > bottom_vector[1].x()) {
        left_bottom = Point2f(bottom_vector[1].x(), bottom_vector[1].y());
        right_bottom = Point2f(bottom_vector[0].x(), bottom_vector[0].y());
    }

    dst[0] = left_top;
    dst[1] = right_top;
    dst[2] = right_bottom;
    dst[3] = left_bottom;
}

void Draw::reset()
{
    point_num = 0;
    move_flag = false;
    points.clear();
    points_vector.clear();

    emit signalReset();
}

void Draw::setPoint(float rate_x, float rate_y)
{
    int xpos = (int)(width * rate_x);
    int ypos = (int)(height * rate_y);
    QPoint point = QPoint(xpos, ypos);
    point_num++;
    if (point_num <= max_point_num)
    {
        FsPoint fs_point;
        fs_point.point = point;
        fs_point.hover = false;

        points.push_back(fs_point);

        this->drawing();

        if (point_num == 4) {
            emit showResult();
        }
    }
    else point_num--;
}

void Draw::setMousePoint(float rate_x, float rate_y)
{
    int xpos = (int)(width * rate_x);
    int ypos = (int)(height * rate_y);
    mouse_point = QPoint(xpos, ypos);

    if (point_num > 0) {
        if (!move_flag)
            this->checkPointHover();
        else
            this->updatePoint();
    }
}

void Draw::setMoveFlag(bool flag)
{
    if (flag && point_num >= 4) {

        for (int i = 0; i < points.size(); i++) {
            FsPoint fs_point = points[i];
            if (fs_point.hover) {
                move_flag = true;
                break;
            }
        }

        if (move_flag)
            emit moveFlag();
    }
    else {
        move_flag = false;
    }
}

void Draw::appendPoints()
{
    vector<FsPoint> fs_point;
    fs_point.assign(points.begin(), points.end());
    points_vector.push_back(fs_point);

    point_num = 0;
    move_flag = false;
    points.clear();
}

void Draw::getResult()
{
//    for (int i = 0; i < points_vector.size(); i++) {
//        qDebug() << "before sorting";
//        vector<FsPoint> fs_point = points_vector[i];
//        for (int j = 0; j < fs_point.size(); j++) {
//            FsPoint tmp_point = fs_point[j];
//            qDebug() << "X: " << tmp_point.point.x() << ", Y: " << tmp_point.point.y();
//        }

//        qDebug() << "after sorting";
//        if (i == 0) {
//            this->getSortedCvPoints(points_vector[0], srcQuad);

//            for (int k = 0; k < 4; k++){
//                qDebug() << "X: " << srcQuad[k].x << ", Y: " << srcQuad[k].y;
//            }
//        }
//        else {
//            this->getSortedCvPoints(points_vector[1], dstQuad);
//            for (int k = 0; k < 4; k++){
//                qDebug() << "X: " << dstQuad[k].x << ", Y: " << dstQuad[k].y;
//            }
//        }
//    }

    this->getSortedCvPoints(points, srcQuad);
    emit getPers(srcQuad, dstQuad);
}

void Draw::setSrcPoints(QVariant data)
{
    qDebug() << "getSrcPoints run: " << data;
    QJSValue points_list = data.value<QJSValue>();
    const int length = points_list.property("length").toInt();
    qDebug() << "length: " << length;
    int count = 0;
    int idx = 0;
    int xpos;
    int ypos;

    points.clear();
    for (int i = 0; i < length; i++) {
        QString qstr = points_list.property(i).toString();
        string str = qstr.toStdString();
        float rate = stof(str);

        if (count == 0) {
            xpos = (int)(width * rate);
            count++;
        }
        else {
            ypos = (int)(height * rate);
            QPoint point = QPoint(xpos, ypos);
            FsPoint fs_point;
            fs_point.point = point;
            fs_point.hover = false;
            points.push_back(fs_point);
            count = 0;

            qDebug() << "xpos: " << xpos << ", ypos: " << ypos;

            Point2f cv_point = Point2f(xpos, ypos);
            srcQuad[idx] = cv_point;
            idx++;
        }
    }
}

void Draw::setDstPoints(QVariant data)
{
    qDebug() << "setDstPoints run: " << data;
    QJSValue points_list = data.value<QJSValue>();
    const int length = points_list.property("length").toInt();
    qDebug() << "length: " << length;
    int count = 0;
    int dst_width;
    int dst_height;

    for (int i = 0; i < length; i++) {
        QString qstr = points_list.property(i).toString();
        string str = qstr.toStdString();
        int val = stoi(str);

        if (count == 0) {
            dst_width = val;
            count++;
        }
        else {
            dst_height = val;

            dstQuad[0] = Point2f(0, 0);
            dstQuad[1] = Point2f(dst_width - 1, 0);
            dstQuad[2] = Point2f(dst_width - 1, dst_height - 1);
            dstQuad[3] = Point2f(0, dst_height - 1);

            qDebug() << "width: " << dst_width << ", height: " << dst_height;
        }
    }
    emit getPers(srcQuad, dstQuad);
}

void Draw::getDrawnImage(QImage &img)
{
    image = img;

    width = image.width();
    height = image.height();

    this->drawing();

    img = image;
    emit drawingDone();
}
