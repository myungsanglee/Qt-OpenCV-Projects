import QtQuick 2.0
import QtQml 2.0
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.0

Item {
    id: video_item

    Component.onCompleted: {
    }

    Component.onDestruction: {
    }

    Connections {
        target: stackView

        onBackPressed:
        {
            stackView.pop()
            opencvProvider.stop()
        }
    }

    Connections {
        target: opencvProvider

        onImageChanged:
        {
            if (status) {
                image.reload()
            }
            else {
                opencvProvider.stop()
                dialog_text.text = "video finished"
                dialog.open()
            }
        }

        onVideoStatus:
        {
            if (status) {
                opencvProvider.start()
            }
            else {
                dialog_text.text = "fail to load video"
                dialog.open()
            }
        }
    }

    Connections {
        target: videoFileDialog

        onSendVideoPath:
        {
            opencvProvider.setVideo(filename)
        }
    }

    Rectangle {
        id: background
        color: background_color
        anchors.fill: parent

        Rectangle {
            id: title_rect
            color: background_color
            anchors.top: parent.top
            width: parent.width
            height: parent.height * 0.1

            Text {
                id: title
                text: qsTr("Video Viewer")
                color: basic_color
                anchors.fill: parent
                font.pixelSize: parent.height * 0.7
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: false
            }
        }

        Rectangle {
            id: image_rect
            color:background_color
            anchors.top: title_rect.bottom
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: parent.width * 0.8

            Image {
                id: image
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                cache: false
//                source: "image://opencv/image"
                property bool counter: false

                function reload() {
                    counter = !counter
                    source = "image://opencv/image" + counter
                }
            }
        }

        Rectangle {
            id: tool_rect
            color: background_color
            anchors.left: image_rect.right
            anchors.right: parent.right
            anchors.verticalCenter: image_rect.verticalCenter
            height: image_rect.height * 0.8

            GridLayout {
                anchors.fill: parent
                rows: 1
                columns: 1

                Rectangle {
                    id: video_file_btn_rect
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.preferredWidth: parent.width * 0.8
                    Layout.preferredHeight: 100
                    color: background_color
                    border.color: basic_color
                    border.width: video_file_btn.pressed ? 3 : 1

                    Text {
                        text: qsTr("Open Video")
                        color: basic_bold_color
                        anchors.fill: parent
                        font.pixelSize: parent.height * 0.5
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.bold: video_file_btn.pressed ? true : false
                    }

                    MouseArea {
                        id: video_file_btn
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: true

                        onPressed: {
                            videoFileDialog.open()
                        }
                    }
                }
            }
        }
    }
}
