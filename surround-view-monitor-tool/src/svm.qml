import QtQuick 2.0
import QtQml 2.0
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.0

Item {
    id: svm_item

    property real warn_thickness: image.width * 0.03
    property real opacity_rate: 0.5
    property int warn_duration: 200
    property int warn_loop: 2

    Component.onCompleted: {
        opencv_image_provider.start()
    }

    Component.onDestruction: {
        opencv_image_provider.stop()
    }

    Connections {
        target: stack_view

        onBackPressed:
        {
            stack_view.pop()
        }
    }

    Connections {
        target: opencv_image_provider

        onImageChanged:
        {
            image.reload()
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
            width: parent.width
            height: parent.height * 0.1

            Text {
                id: title
                text: qsTr("SVM")
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
            color: background_color
            anchors.top: title_rect.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            width: parent.width * 0.8

            Image {
                id: image
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                property bool counter: false

                function reload() {
                    counter = !counter
                    source = "image://opencv/image" + counter
                }
            }

            Rectangle {
                id: front_warn_rect
                anchors.left: parent.left
                anchors.leftMargin: ((parent.width - image.paintedWidth) / 2) + front_warn_rect.height
                anchors.bottom: parent.bottom
                anchors.bottomMargin: (parent.height - image.paintedHeight) / 2
                width: image.paintedHeight
                height: warn_thickness
                opacity: 0.0

                transform: Rotation { origin.x: 0; origin.y: front_warn_rect.height; angle: -90}

                gradient: Gradient {
                    GradientStop { position: 0.0; color: "red" }
                    GradientStop { position: 1.0; color: "transparent" }
                }

                SequentialAnimation on opacity {
                    id: front_animation
                    running: false
                    loops: warn_loop
                    PropertyAnimation {to: opacity_rate; duration: warn_duration }
                    PropertyAnimation {to: 0.0; duration: warn_duration}
                }
            }

            Rectangle {
                id: right_warn_rect
                anchors.top: parent.top
                anchors.topMargin: (parent.height - image.paintedHeight) / 2
                anchors.horizontalCenter: parent.horizontalCenter
                width: image.paintedWidth
                height: warn_thickness
                opacity: 0.0

                gradient: Gradient {
                    GradientStop { position: 0.0; color: "red" }
                    GradientStop { position: 1.0; color: "transparent" }
                }

                SequentialAnimation on opacity {
                    id: right_animation
                    running: false
                    loops: warn_loop
                    PropertyAnimation {to: opacity_rate; duration: warn_duration }
                    PropertyAnimation {to: 0.0; duration: warn_duration}
                }
            }

            Rectangle {
                id: left_warn_rect
                anchors.bottom: parent.bottom
                anchors.bottomMargin: (parent.height - image.paintedHeight) / 2
                anchors.horizontalCenter: parent.horizontalCenter
                width: image.paintedWidth
                height: warn_thickness
                opacity: 0.0

                gradient: Gradient {
                    GradientStop { position: 1.0; color: "red" }
                    GradientStop { position: 0.0; color: "transparent" }
                }

                SequentialAnimation on opacity {
                    id: left_animation
                    running: false
                    loops: warn_loop
                    PropertyAnimation {to: opacity_rate; duration: warn_duration }
                    PropertyAnimation {to: 0.0; duration: warn_duration}
                }
            }

            Rectangle {
                id: back_warn_rect
                anchors.right: parent.right
                anchors.rightMargin: ((parent.width - image.paintedWidth) / 2) + back_warn_rect.height
                anchors.bottom: parent.bottom
                anchors.bottomMargin: (parent.height - image.paintedHeight) / 2
                width: image.paintedHeight
                height: warn_thickness
                opacity: 0.0

                transform: Rotation { origin.x: front_warn_rect.width; origin.y: front_warn_rect.height; angle: 90}

                gradient: Gradient {
                    GradientStop { position: 0.0; color: "red" }
                    GradientStop { position: 1.0; color: "transparent" }
                }

                SequentialAnimation on opacity {
                    id: back_animation
                    running: false
                    loops: warn_loop
                    PropertyAnimation {to: opacity_rate; duration: warn_duration }
                    PropertyAnimation {to: 0.0; duration: warn_duration}
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
                rows: 4
                columns: 1

                Button {
                    id: btn_1
                    text: qsTr("Front")
                    font.pixelSize: parent.height * 0.04
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.preferredWidth: parent.width * 0.8
                    Layout.preferredHeight: parent.height * 0.1

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
                        front_animation.start()
                    }
                }

                Button {
                    id: btn_2
                    text: qsTr("Right")
                    font.pixelSize: parent.height * 0.04
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.preferredWidth: parent.width * 0.8
                    Layout.preferredHeight: parent.height * 0.1

                    contentItem: Text {
                        text: btn_2.text
                        font: btn_2.font
                        opacity: enabled ? 1.0 : 0.3
                        color: btn_2.pressed ? basic_color : basic_bold_color
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    background: Rectangle {
                        color: background_color
                        border.width: btn_2.pressed ? 3 : 1
                        opacity: enabled ? 1 : 0.3
                        border.color: btn_2.pressed ? basic_color : basic_bold_color
                        radius: round
                    }

                    onClicked: {
                        right_animation.start()
                    }
                }

                Button {
                    id: btn_3
                    text: qsTr("Left")
                    font.pixelSize: parent.height * 0.04
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.preferredWidth: parent.width * 0.8
                    Layout.preferredHeight: parent.height * 0.1

                    contentItem: Text {
                        text: btn_3.text
                        font: btn_3.font
                        opacity: enabled ? 1.0 : 0.3
                        color: btn_3.pressed ? basic_color : basic_bold_color
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    background: Rectangle {
                        color: background_color
                        border.width: btn_3.pressed ? 3 : 1
                        opacity: enabled ? 1 : 0.3
                        border.color: btn_3.pressed ? basic_color : basic_bold_color
                        radius: round
                    }

                    onClicked: {
                        left_animation.start()
                    }
                }

                Button {
                    id: btn_4
                    text: qsTr("Back")
                    font.pixelSize: parent.height * 0.04
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.preferredWidth: parent.width * 0.8
                    Layout.preferredHeight: parent.height * 0.1

                    contentItem: Text {
                        text: btn_4.text
                        font: btn_4.font
                        opacity: enabled ? 1.0 : 0.3
                        color: btn_4.pressed ? basic_color : basic_bold_color
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    background: Rectangle {
                        color: background_color
                        border.width: btn_4.pressed ? 3 : 1
                        opacity: enabled ? 1 : 0.3
                        border.color: btn_4.pressed ? basic_color : basic_bold_color
                        radius: round
                    }

                    onClicked: {
                        back_animation.start()
                    }
                }
            }

        }
    }
}
