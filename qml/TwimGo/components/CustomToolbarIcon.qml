// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Column {
    id: icon
    property string iconImage: ""
    property string iconText: ""
    property bool showNewIndicator: false;
    signal clicked()
    width: 52
    Item {
        width: 52
        height: 52
        Image {
            anchors.centerIn: parent
            source: icon.iconImage
            opacity: !homeMouseArea.pressed ? 1 : 0.5
            MouseArea {
                id: homeMouseArea
                anchors.centerIn: parent
                width: 60
                height: 60
                onClicked: {
                    icon.clicked();
                }
            }
        }
        Rectangle {
            visible: icon.showNewIndicator
            id: newHomeTweetsIndicator
            width: 36
            height: 14
            radius: 5
            color: "#d00"
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                color: "#fff"
                font.pixelSize: 11
                text: "NEW"
                anchors.centerIn: parent
            }
        }
    }
    Text {
        text: icon.iconText
        color: theme.toolbarTextColor
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: window.iconFontSize
    }
}

