import QtQuick 2.0
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.0
import QtQml 2.0

Item {
    id: home_item

    Rectangle {
        id: background
        color: background_color
        anchors.fill: parent

        Rectangle {
            id: rectangle1
            color: background_color
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            height: parent.height * 0.2

            Text {
                id: title
                color: basic_color
                text: qsTr("Image & Video Viewer")
                anchors.fill: parent
                font.pixelSize: parent.height * 0.6
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: false
            }
        }

        Rectangle {
            id: rectangle2
            color: background_color
            anchors.top: rectangle1.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10

            GridLayout {
                anchors.fill: parent
                rows: 1
                columns: 2

                Rectangle {
                    id: img_btn_rect
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.preferredWidth: parent.width * 0.35
                    Layout.preferredHeight: 200
                    color: background_color
                    border.color: basic_color
                    border.width: img_btn.pressed ? 3 : 1

                    Text {
                        text: qsTr("Image Viewer")
                        color: basic_bold_color
                        anchors.fill: parent
                        font.pixelSize: parent.height * 0.4
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.bold: img_btn.pressed ? true : false
                    }

                    MouseArea {
                        id: img_btn
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: true

                        onPressed: {
                            stackView.push('qrc:/image.qml')
                        }
                    }
                }

                Rectangle {
                    id: video_btn_rect
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.preferredWidth: parent.width * 0.35
                    Layout.preferredHeight: 200
                    color: background_color
                    border.color: basic_color
                    border.width: video_btn.pressed ? 3 : 1

                    Text {
                        text: qsTr("Video Viewer")
                        color: basic_bold_color
                        anchors.fill: parent
                        font.pixelSize: parent.height * 0.4
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.bold: video_btn.pressed ? true : false
                    }

                    MouseArea {
                        id: video_btn
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: true

                        onPressed: {
                            stackView.push('qrc:/video.qml')
                        }
                    }
                }
            }
        }
    }
}
