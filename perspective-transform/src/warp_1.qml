import QtQuick 2.0
import QtQml 2.0
import QtQuick.Controls 2.0

Item {
    id: warp_1_item

    Component.onCompleted: {
        opencvProvider.setDrawFlag(true)
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
                spacing: 10

                Rectangle {
                    id: src_text_rect
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: background_color
                    width: parent.width
                    height: 30

                    Text {
                        text: qsTr("Set SRC 4 Points")
                        color: basic_bold_color
                        anchors.fill: parent
                        font.pixelSize: parent.height * 0.7
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.bold: true
                    }
                }

                Rectangle {
                    id: src_text_field
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: background_color
                    width: parent.width
                    height: 120

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
                                       text: qsTr("Left Top")
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
                                       id: left_top_x
                                       placeholderText: qsTr("Enter X")
                                       anchors.fill: parent
                                       color: basic_color
                                       font.pixelSize: parent.height * 0.7
                                       text: "0.41"

                                       background: Rectangle {
                                           implicitWidth: parent.width
                                           implicitHeight: parent.height
                                           color: background_color
                                           border.color: basic_color
                                       }
                                   }
                               }

                               Rectangle {
                                   width: parent.width * 0.3
                                   height: parent.height
                                   color: background_color

                                   TextField {
                                       id: left_top_y
                                       placeholderText: qsTr("Enter Y")
                                       anchors.fill: parent
                                       color: basic_color
                                       font.pixelSize: parent.height * 0.7
                                       text: "0.67"

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
                                       text: qsTr("Right Top")
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
                                       id: right_top_x
                                       placeholderText: qsTr("Enter X")
                                       anchors.fill: parent
                                       color: basic_color
                                       font.pixelSize: parent.height * 0.7
                                       text: "0.57"

                                       background: Rectangle {
                                           implicitWidth: parent.width
                                           implicitHeight: parent.height
                                           color: background_color
                                           border.color: basic_color
                                       }
                                   }
                               }

                               Rectangle {
                                   width: parent.width * 0.3
                                   height: parent.height
                                   color: background_color

                                   TextField {
                                       id: right_top_y
                                       placeholderText: qsTr("Enter Y")
                                       anchors.fill: parent
                                       color: basic_color
                                       font.pixelSize: parent.height * 0.7
                                       text: "0.67"

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
                                       text: qsTr("Right Bottom")
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
                                       id: right_bottom_x
                                       placeholderText: qsTr("Enter X")
                                       anchors.fill: parent
                                       color: basic_color
                                       font.pixelSize: parent.height * 0.7
                                       text: "0.93"

                                       background: Rectangle {
                                           implicitWidth: parent.width
                                           implicitHeight: parent.height
                                           color: background_color
                                           border.color: basic_color
                                       }
                                   }
                               }

                               Rectangle {
                                   width: parent.width * 0.3
                                   height: parent.height
                                   color: background_color

                                   TextField {
                                       id: right_bottom_y
                                       placeholderText: qsTr("Enter Y")
                                       anchors.fill: parent
                                       color: basic_color
                                       font.pixelSize: parent.height * 0.7
                                       text: "0.9"

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
                                       text: qsTr("Left Bottom")
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
                                       id: left_bottom_x
                                       placeholderText: qsTr("Enter X")
                                       anchors.fill: parent
                                       color: basic_color
                                       font.pixelSize: parent.height * 0.7
                                       text: "0.06"

                                       background: Rectangle {
                                           implicitWidth: parent.width
                                           implicitHeight: parent.height
                                           color: background_color
                                           border.color: basic_color
                                       }
                                   }
                               }

                               Rectangle {
                                   width: parent.width * 0.3
                                   height: parent.height
                                   color: background_color

                                   TextField {
                                       id: left_bottom_y
                                       placeholderText: qsTr("Enter Y")
                                       anchors.fill: parent
                                       color: basic_color
                                       font.pixelSize: parent.height * 0.7
                                       text: "0.9"

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
                    id: src_btn_rect
                    width: parent.width
                    height: 30
                    color: background_color
                    border.color: basic_color
                    border.width: src_btn.pressed ? 3 : 1

                    Text {
                        text: qsTr("Show Points")
                        color: basic_bold_color
                        anchors.fill: parent
                        font.pixelSize: parent.height * 0.7
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.bold: src_btn.pressed ? true : false
                    }

                    MouseArea {
                        id: src_btn
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: true
                        property var points

                        onPressed: {
                            points = [
                                        left_top_x.text,
                                        left_top_y.text,
                                        right_top_x.text,
                                        right_top_y.text,
                                        right_bottom_x.text,
                                        right_bottom_y.text,
                                        left_bottom_x.text,
                                        left_bottom_y.text
                                    ]
                            draw.setSrcPoints(points)
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
                    width: parent.width
                    height: 30
                    color: background_color
                    border.color: basic_color
                    border.width: dst_btn.pressed ? 3 : 1

                    Text {
                        text: qsTr("Show Result")
                        color: basic_bold_color
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
                            dst_btn_rect.visible = false
                            back_btn_rect.visible = true
                        }
                    }
                }

                Rectangle {
                    id: back_btn_rect
                    width: parent.width
                    height: 30
                    color: background_color
                    border.color: basic_color
                    border.width: back_btn.pressed ? 3 : 1
                    visible: false

                    Text {
                        text: qsTr("Back")
                        color: basic_bold_color
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
                            back_btn_rect.visible = false
                            dst_btn_rect.visible = true
                        }
                    }
                }
            }
        }
    }
}
