import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 2.0 as Controls
import Qt.labs.platform 1.0 as Platform
import QtQuick.Dialogs 1.2 as Dialogs


Window {
    width: 1920
    height: 1080
    visible: true
    title: qsTr("Viewer")

    property string background_color: "black"
    property string basic_color: "#17a81a"
    property string basic_bold_color: "#21be2b"
    property int round: 5
    property bool debug: false
    property string filename

    Dialogs.Dialog {
        id: dialog
        visible: false
        title: "Info"

        contentItem: Rectangle {
            color: background_color
            implicitWidth: 400
            implicitHeight: 100
            border.width: 1
            border.color: basic_color
            Text {
                id: dialog_text
                text: ""
                color: basic_color
                anchors.centerIn: parent
                font.pixelSize: 25
            }
        }
    }

    Platform.FileDialog {
        id: image_file_dialog
        title: "Open image file"
        folder: Platform.StandardPaths.writableLocation(Platform.StandardPaths.PicturesLocation)
        fileMode: Platform.FileDialog.OpenFile
        nameFilters: ["Image files (*.jpg *.PNG)"]

        signal sendImagePath(var path)

        onAccepted: {
            console.log("You chose: " + image_file_dialog.file.toString())
            filename = image_file_dialog.file.toString()
            sendImagePath(filename)

            image_file_dialog.folder = image_file_dialog.file
            image_file_dialog.close()
        }

        onRejected: {
            console.log("Canceled")
            image_file_dialog.close()
        }
    }

    Controls.StackView {
        id: stack_view
        anchors.fill: parent
        initialItem: "qrc:/home.qml"

        signal backPressed()
        signal delPressed()

        Keys.onPressed: {
            if (event.key === Qt.Key_Backspace) {
                console.log("backspace pressed")
                backPressed()
            }
        }

        /* For TextField lose focus when click outside */
        Controls.Pane {
            anchors.fill: parent
            focusPolicy: Qt.ClickFocus
        }
    }
}
