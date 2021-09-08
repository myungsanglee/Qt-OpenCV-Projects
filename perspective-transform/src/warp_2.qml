import QtQuick 2.0
import QtQml 2.0
import QtQuick.Controls 2.0

Item {
    id: warp_2_item

    property bool move_flag: false
    property bool mouse_flag: false
    property bool src_btn_flag: true

    Component.onCompleted: {
        opencvProvider.start()
    }

    Component.onDestruction: {
        opencvProvider.stop()
        draw.reset()
    }

    Connections {
        target: stackView

        onBackPressed:
        {
            stackView.pop()
        }

        onDelPressed:
        {
            draw.reset()
            opencvProvider.setWarpFlag(false)
        }
    }

    Connections {
        target: opencvProvider

        onImageChanged:
        {
            image.reload()
        }
    }

    Connections {
        target: draw

        onMoveFlag:
        {
            warp_2_item.move_flag = true
        }

        onSignalReset:
        {
            warp_2_item.move_flag = false
            warp_2_item.mouse_flag = false
            warp_2_item.src_btn_flag = true
            dst_btn_rect.visible = false
            back_btn_rect.visible = false

            opencvProvider.setDrawFlag(false)
        }

        onShowResult:
        {
            dst_btn_rect.visible = true
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
                text: qsTr("Perspective Transform")
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
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: parent.width * 0.8

            Image {
                id: image
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                cache: false
                property bool counter: false

                function reload() {
                    counter = !counter
                    source = "image://opencv/image" + counter
                }

                MouseArea {
                    id: mouse_area
                    enabled: mouse_flag
                    width: image.paintedWidth
                    height: image.paintedHeight
                    anchors.verticalCenter: image.verticalCenter
                    anchors.horizontalCenter: image.horizontalCenter
                    hoverEnabled: true
                    property real rate_x: 0.0
                    property real rate_y: 0.0

                    onPressed: {
                        rate_x = (mouse_area.mouseX / image.paintedWidth);
                        rate_y = (mouse_area.mouseY / image.paintedHeight);
                        draw.setPoint(rate_x, rate_y)
                    }

                    onReleased: {
                        image_rect.color = background_color

                        if (warp_2_item.move_flag) {
                            draw.setMoveFlag(false)
                            warp_2_item.move_flag = false
                        }
                    }

                    onPositionChanged: {
                        rate_x = (mouse_area.mouseX / image.paintedWidth);
                        rate_y = (mouse_area.mouseY / image.paintedHeight);
                        draw.setMousePoint(rate_x, rate_y)
                    }

                    onPressAndHold: {
                        console.log("Press And Hold")
                        draw.setMoveFlag(true)
                    }
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

            Column {
                anchors.fill: parent
                anchors.topMargin: 50
                spacing: 10

                Rectangle {
                    id: src_btn_rect
                    width: tool_rect.width * 0.8
                    height: 50
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: background_color
                    border.color: src_btn.containsMouse ? basic_bold_color : basic_color
                    radius: round
                    border.width: src_btn_flag ? 2 : 4

                    Text {
                        text: qsTr("Set SRC 4 Points")
                        color: src_btn.containsMouse ? basic_bold_color : basic_color
                        anchors.fill: parent
                        font.pixelSize: parent.height * 0.7
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.bold: src_btn_flag ? false : true
                    }

                    MouseArea {
                        id: src_btn
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: src_btn_flag ? true : false

                        onPressed: {
                            opencvProvider.setDrawFlag(true)
                            src_btn_flag = false
                            mouse_flag = true
                        }
                    }
                }

                Rectangle {
                    id: dst_text_rect
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: background_color
                    width: parent.width
                    height: 30

                    Text {
                        text: qsTr("Set DST width & height")
                        color: basic_bold_color
                        anchors.fill: parent
                        font.pixelSize: parent.height * 0.7
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.bold: true
                    }
                }

                Rectangle {
                    id: dst_text_field
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: background_color
                    width: parent.width
                    height: 60

                    Column {
                       anchors.fill: parent
                       spacing: 2

                       Rectangle {
                           width: parent.width
                           height: 30
                           color: background_color

                           Row {
                               anchors.fill: parent
                               spacing: 10

                               Rectangle {
                                   width: parent.width * 0.3
                                   height: parent.height
                                   color: background_color

                                   Text {
                                       text: qsTr("Width")
                                       color: basic_bold_color
                                       anchors.fill: parent
                                       font.pixelSize: parent.height * 0.7
                                       horizontalAlignment: Text.AlignHCenter
                                       verticalAlignment: Text.AlignVCenter
                                       font.bold: true
                                   }
                               }

                               Rectangle {
                                   width: parent.width * 0.3
                                   height: parent.height
                                   color: background_color

                                   TextField {
                                       id: dst_width
                                       placeholderText: qsTr("Enter width")
                                       anchors.fill: parent
                                       color: basic_color
                                       font.pixelSize: parent.height * 0.7
                                       text: "500"

                                       background: Rectangle {
                                           implicitWidth: parent.width
                                           implicitHeight: parent.height
                                           color: background_color
                                           border.color: basic_color
                                       }
                                   }
                               }
                           }
                       }

                       Rectangle {
                           width: parent.width
                           height: 30
                           color: background_color

                           Row {
                               anchors.fill: parent
                               spacing: 10

                               Rectangle {
                                   width: parent.width * 0.3
                                   height: parent.height
                                   color: background_color

                                   Text {
                                       text: qsTr("Height")
                                       color: basic_bold_color
                                       anchors.fill: parent
                                       font.pixelSize: parent.height * 0.7
                                       horizontalAlignment: Text.AlignHCenter
                                       verticalAlignment: Text.AlignVCenter
                                       font.bold: true
                                   }
                               }

                               Rectangle {
                                   width: parent.width * 0.3
                                   height: parent.height
                                   color: background_color




                                   TextField {
                                       id: dst_height
                                       placeholderText: qsTr("Enter height")
                                       anchors.fill: parent
                                       color: basic_color
                                       font.pixelSize: parent.height * 0.7
                                       text: "500"

                                       background: Rectangle {
                                           implicitWidth: parent.width
                                           implicitHeight: parent.height
                                           color: background_color
                                           border.color: basic_color
                                       }
                                   }
                               }
                           }
                       }
                    }
                }

                Rectangle {
                    id: dst_btn_rect
                    width: tool_rect.width * 0.8
                    height: 50
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: background_color
                    border.color: dst_btn.containsMouse ? basic_bold_color : basic_color
                    radius: round
                    border.width: dst_btn.pressed ? 4 : 2
                    visible: false

                    Text {
                        id: dst_btn_text
                        text: qsTr("Show Result")
                        color: dst_btn.containsMouse ? basic_bold_color : basic_color
                        anchors.fill: parent
                        font.pixelSize: parent.height * 0.7
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.bold: dst_btn.pressed ? true : false
                    }

                    MouseArea {
                        id: dst_btn
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: true
                        property var dst_points

                        onPressed: {
                            dst_points = [
                                        dst_width.text,
                                        dst_height.text
                                    ]
                            draw.setDstPoints(dst_points)
                            draw.getResult()
                            mouse_flag = false
                            dst_btn_rect.visible = false
                            back_btn_rect.visible = true
                        }
                    }
                }

                Rectangle {
                    id: back_btn_rect
                    width: tool_rect.width * 0.8
                    height: 50
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: background_color
                    border.color: back_btn.containsMouse ? basic_bold_color : basic_color
                    radius: round
                    border.width: back_btn.pressed ? 4 : 2
                    visible: false

                    Text {
                        id: back_btn_text
                        text: qsTr("Back")
                        color: back_btn.containsMouse ? basic_bold_color : basic_color
                        anchors.fill: parent
                        font.pixelSize: parent.height * 0.7
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.bold: back_btn.pressed ? true : false
                    }

                    MouseArea {
                        id: back_btn
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: true

                        onPressed: {
                            opencvProvider.setWarpFlag(false)
                            dst_btn_rect.visible = true
                            back_btn_rect.visible = false
                            mouse_flag = true
                        }
                    }
                }
            }
        }
    }
}
