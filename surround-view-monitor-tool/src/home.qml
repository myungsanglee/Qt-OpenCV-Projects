import QtQuick 2.0
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.0
import QtQml 2.0

Item {
    id: home_item

    Connections {
        target: image_file_dialog

        onSendImagePath:
        {
            opencv_image_provider.setImage(path)
        }
    }

    Connections {
        target: opencv_image_provider

        onOpenImage: {
            if (state) {
                stack_view.push('qrc:/svm.qml')
            }
            else {
                dialog_text.text = "Fail to load image. Select image file"
                dialog.open()
            }
        }
    }

    Rectangle {
        id: background_rect
        color: background_color
        anchors.fill: parent

        Rectangle {
            id: title_rect
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
                text: qsTr("Surround View Monitor")
                anchors.fill: parent
                font.pixelSize: parent.height * 0.5
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: false
            }
        }

        Rectangle {
            id: btn_rect
            color: background_color
            anchors.top: title_rect.bottom
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
                columns: 1

                Button {
                    id: btn_1
                    text: qsTr("Test")
                    font.pixelSize: parent.height * 0.04
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.preferredWidth: parent.width * 0.2
                    Layout.preferredHeight: parent.height * 0.2

                    contentItem: Text {
                        text: btn_1.text
                        font: btn_1.font
                        opacity: enabled ? 1.0 : 0.3
                        color: btn_1.pressed ? basic_color : basic_bold_color
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    background: Rectangle {
                        color: background_color
                        border.width: btn_1.pressed ? 3 : 1
                        opacity: enabled ? 1 : 0.3
                        border.color: btn_1.pressed ? basic_color : basic_bold_color
                        radius: round
                    }

                    onClicked: {
                        image_file_dialog.open()
                    }
                }

            }
        }
    }
}
