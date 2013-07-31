// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: retweetDialog
    width: parent.width
    height: parent.height
    signal retweetWithEdit()
    signal retweetInstantly()

    Rectangle {
        anchors.fill: parent
        color: "#000"
        opacity: 0.6
    }

    Button {
        id: instantButton
        y: retweetDialog.height/2 - height/2 - height - 10
        x: retweetDialog.width/2 - 150
        width: 300
        label: qsTr("Reweet instantly")
        onClicked: {
            retweetDialog.visible = false;
            retweetDialog.retweetInstantly();
        }
    }

    Button {
        y: retweetDialog.height/2 - height/2
        x: instantButton.x
        width: 300
        label: qsTr("Retweet with comment")
        onClicked: {
            retweetDialog.visible = false;
            retweetDialog.retweetWithEdit();
        }
    }

    Button {
        y: retweetDialog.height/2 + height/2 + 10
        x: instantButton.x
        width: 300
        label: qsTr("Cancel")
        onClicked: {
            retweetDialog.visible = false;
        }
    }

}
