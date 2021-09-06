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
        id: imageFileDialog
        title: "Open image file"
        folder: Platform.StandardPaths.writableLocation(Platform.StandardPaths.PicturesLocation)
        fileMode: Platform.FileDialog.OpenFile
        nameFilters: ["Image files (*.jpg *.PNG)"]

        signal sendImagePath(var path)

        onAccepted: {
            console.log("You chose: " + imageFileDialog.file.toString())
            filename = imageFileDialog.file.toString()
            sendImagePath(filename)

            imageFileDialog.folder = imageFileDialog.file
            imageFileDialog.close()
        }

        onRejected: {
            console.log("Canceled")
            imageFileDialog.close()
        }
    }

    Platform.FileDialog {
        id: videoFileDialog
        title: "Open video file"
        folder: Platform.StandardPaths.writableLocation(Platform.StandardPaths.MoviesLocation)
        fileMode: Platform.FileDialog.OpenFile
        nameFilters: ["Video files (*.avi *.mp4)"]

        signal sendVideoPath(var path)

        onAccepted: {
            console.log("You chose: " + videoFileDialog.file.toString())
            filename = videoFileDialog.file.toString()
            sendVideoPath(filename)

            videoFileDialog.folder = videoFileDialog.file
            videoFileDialog.close()
        }

        onRejected: {
            console.log("Canceled")
            videoFileDialog.close()
        }
    }

    Controls.StackView {
        id: stackView
        anchors.fill: parent
        focus: true
        initialItem: "qrc:/home.qml"
        signal backPressed()
        Keys.onPressed: {
            if (event.key === Qt.Key_Backspace) {
                backPressed()
            }
        }
    }
}
