/*
    Copyright 2011 - Tommi Laukkanen (www.substanceofcode.com)

    This file is part of TwimGo.

    TwimGo is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    TwimGo is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with TwimGo. If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 1.1

Item {
    id: settingsDialogItem
    signal clicked()
    width: parent.width;
    //height: settingsColumn.height
    height: parent.height < settingsDialog.height ? parent.height : settingsDialog.height
    state: "hidden"
    property bool useList: false
    property bool useSound: false
    property bool useLightTheme: false
    property string autoRefresh: "5"
    property string pocketUsername: ""
    property string pocketPassword: ""

    function setPocketUsername(username) {
        pocketUsername = username;
        pocketUsernameInput.setText( username );
    }

    function setPocketPassword(password) {
        pocketPassword = password;
        pocketPasswordInput.setText( password );
    }

    Flickable {
        y: 0
        id: settingsFlickable
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: settingsDialog.height

        Rectangle {
            id: settingsDialog
            width: parent.width
            y: 0
            height: settingsColumn.y + settingsColumn.height + 30
            color: theme.dialogBG

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("Preventing click leaking to underneath");
                }
            }

            Text {
                text: qsTr("Auto-refresh")
                wrapMode: Text.NoWrap
                font.pixelSize: 22
                color: "#ddd"
                x: -width/2 + 52
                rotation: -90
                y: width
            }

            Column {
                id: settingsColumn
                x: 10
                y: 10
                width: parent.width - 20
                spacing: 10

                Row {
                    x: 64
                    spacing: 10
                    width: parent.width - 64

                    Rectangle {
                        border.width: 1
                        border.color: "#444"
                        color: useListMouseArea.pressed ? "#555" : "#111"
                        radius: 5
                        width: 42
                        height: 42

                        Image {
                            anchors.centerIn: parent
                            source: "../pics/delete.png"
                            visible: settingsDialogItem.useList
                        }

                        MouseArea {
                            id: useListMouseArea
                            anchors.fill: parent
                            onClicked: {
                                settingsDialogItem.useList = !settingsDialogItem.useList;
                            }
                        }
                    }

                    Text {
                        text: qsTr("List in landscape")
                        width: parent.width - 64
                        wrapMode: Text.Wrap
                        font.pixelSize: 22
                        anchors.verticalCenter: parent.verticalCenter
                        color: theme.dialogInfoTextColor //"#ddd"
                    }


                }

                Rectangle {
                    x: 64
                    width: parent.width - 128
                    height: 1
                    color: "#ccc"
                }

                Row {
                    x: 64
                    spacing: 10
                    width: parent.width - 64

                    Rectangle {
                        border.width: 1
                        border.color: "#444"
                        color: noneMouseArea.pressed ? "#555" : "#111"
                        radius: 5
                        width: 42
                        height: 42

                        Image {
                            anchors.centerIn: parent
                            source: "../pics/delete.png"
                            visible: settingsDialogItem.autoRefresh == "0"
                        }

                        MouseArea {
                            id: noneMouseArea
                            anchors.fill: parent
                            onClicked: {
                                settingsDialogItem.autoRefresh = "0";
                            }
                        }
                    }

                    Text {
                        text: qsTr("None")
                        wrapMode: Text.Wrap
                        font.pixelSize: 22
                        anchors.verticalCenter: parent.verticalCenter
                        color: theme.dialogInfoTextColor // "#ddd"
                    }
                }

                Row {
                    x: 64
                    spacing: 10
                    width: parent.width - 64

                    Rectangle {
                        border.width: 1
                        border.color: "#444"
                        color: minuteMouseArea.pressed ? "#555" : "#111"
                        radius: 5
                        width: 42
                        height: 42

                        Image {
                            anchors.centerIn: parent
                            source: "../pics/delete.png"
                            visible: settingsDialogItem.autoRefresh == "1"
                        }

                        MouseArea {
                            id: minuteMouseArea
                            anchors.fill: parent
                            onClicked: {
                                settingsDialogItem.autoRefresh = "1";
                            }
                        }
                    }

                    Text {
                        text: qsTr("1 minute")
                        wrapMode: Text.Wrap
                        font.pixelSize: 22
                        anchors.verticalCenter: parent.verticalCenter
                        color: theme.dialogInfoTextColor //"#ddd"
                    }
                }

                Row {
                    x: 64
                    spacing: 10
                    width: parent.width - 64

                    Rectangle {
                        border.width: 1
                        border.color: "#444"
                        color: fiveMouseArea.pressed ? "#555" : "#111"
                        radius: 5
                        width: 42
                        height: 42

                        Image {
                            anchors.centerIn: parent
                            source: "../pics/delete.png"
                            visible: settingsDialogItem.autoRefresh == "5"
                        }

                        MouseArea {
                            id: fiveMouseArea
                            anchors.fill: parent
                            onClicked: {
                                settingsDialogItem.autoRefresh = "5";
                            }
                        }
                    }

                    Text {
                        text: qsTr("5 minutes")
                        wrapMode: Text.Wrap
                        font.pixelSize: 22
                        anchors.verticalCenter: parent.verticalCenter
                        color: theme.dialogInfoTextColor //"#ddd"
                    }
                }

                Row {
                    x: 64
                    spacing: 10
                    width: parent.width - 64

                    Rectangle {
                        border.width: 1
                        border.color: "#444"
                        color: fifteenMouseArea.pressed ? "#555" : "#111"
                        radius: 5
                        width: 42
                        height: 42

                        Image {
                            anchors.centerIn: parent
                            source: "../pics/delete.png"
                            visible: settingsDialogItem.autoRefresh == "15"
                        }

                        MouseArea {
                            id: fifteenMouseArea
                            anchors.fill: parent
                            onClicked: {
                                settingsDialogItem.autoRefresh = "15";
                            }
                        }
                    }

                    Text {
                        text: qsTr("15 minutes")
                        wrapMode: Text.Wrap
                        font.pixelSize: 22
                        anchors.verticalCenter: parent.verticalCenter
                        color: theme.dialogInfoTextColor //"#ddd"
                    }
                }

                Rectangle {
                    x: 64
                    width: parent.width - 128
                    height: 1
                    color: "#ccc"
                }
    /*
                Row {
                    x: 64
                    spacing: 10
                    width: parent.width - 64

                    Rectangle {
                        border.width: 1
                        border.color: "#444"
                        color: useSoundMouseArea.pressed ? "#555" : "#111"
                        radius: 5
                        width: 42
                        height: 42

                        Image {
                            anchors.centerIn: parent
                            source: "../pics/delete.png"
                            visible: settingsDialogItem.useSound
                        }

                        MouseArea {
                            id: useSoundMouseArea
                            anchors.fill: parent
                            onClicked: {
                                settingsDialogItem.useSound = !settingsDialogItem.useSound;
                            }
                        }
                    }

                    Text {
                        text: "Sound notification"
                        width: parent.width - 64
                        wrapMode: Text.Wrap
                        font.pixelSize: 22
                        anchors.verticalCenter: parent.verticalCenter
                        color: "#ddd"
                    }
                }*/

                Row {
                    x: 64
                    spacing: 10
                    width: parent.width - 64

                    Rectangle {
                        border.width: 1
                        border.color: "#444"
                        color: useWhiteThemeMouseArea.pressed ? "#555" : "#111"
                        radius: 5
                        width: 42
                        height: 42

                        Image {
                            anchors.centerIn: parent
                            source: "../pics/delete.png"
                            visible: settingsDialogItem.useLightTheme
                        }

                        MouseArea {
                            id: useWhiteThemeMouseArea
                            anchors.fill: parent
                            onClicked: {
                                settingsDialogItem.useLightTheme = !settingsDialogItem.useLightTheme;
                                theme.switchTheme();
                            }
                        }
                    }

                    Text {
                        text: qsTr("Use light theme")
                        width: parent.width - 64
                        wrapMode: Text.Wrap
                        font.pixelSize: 22
                        anchors.verticalCenter: parent.verticalCenter
                        color: theme.dialogInfoTextColor //"#ddd"
                    }

                }

                Rectangle {
                    x: 64
                    width: parent.width - 128
                    height: 1
                    color: "#ccc"
                }

                Row {
                    x: 64
                    spacing: 10
                    width: parent.width - 64

                    Column {
                        width: parent.width
                        spacing: 10

                        Text {
                            text: qsTr("Pocket (Read It Later) credentials")
                            width: parent.width - 64
                            font.pixelSize: 22
                            wrapMode: Text.Wrap
                            color: theme.dialogInfoTextColor
                        }

                        CustomTextInput {
                            id: pocketUsernameInput
                            placeholderText: qsTr("Username")
                            width: parent.width - 64
                        }

                        CustomTextInput {
                            id: pocketPasswordInput
                            placeholderText: qsTr("Password")
                            width: parent.width - 64
                            isPassword: true
                        }
                    }
                }

                Rectangle {
                    id: settingsButtonContainer
                    radius: 5
                    color: theme.dialogButtonAreaBG
                    width: parent.width
                    height: 70

                    Button {
                        id: settingsButton
                        label: qsTr("Save")
                        width: parent.width/2 - 15
                        x: 10
                        y: 10 //
                        onClicked: {
                            pocketUsername = pocketUsernameInput.getText();
                            pocketPassword = pocketPasswordInput.getText();
                            settingsDialogItem.clicked();
                            settingsDialogItem.state = "hidden"
                        }
                    }

                    Button {
                        id: cancelButton
                        label: qsTr("Cancel")
                        width: parent.width/2 - 15
                        x: parent.width/2 + 5
                        y: 10 //
                        onClicked: {
                            settingsDialogItem.state = "hidden"
                        }
                    }
                }

            }

            Image {
                source: "../pics/top-shadow.png"
                y: parent.height
                height: 16
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
            }

        }
    }

    states:
        State {
            name: "hidden"
            PropertyChanges {
                target: settingsDialogItem
                y: settingsFlickable.contentHeight<parent.height ? 0 - parent.height - 30 : 0 - settingsFlickable.contentHeight - 30
            }
        }
        State {
            name: "shown"
            PropertyChanges {
                target: settingsDialogItem
                y: 0
            }
        }

    transitions: Transition {
        SequentialAnimation {
            PropertyAnimation {
                target: settingsDialogItem
                properties: "y"
                duration: 600
                easing.type: "OutQuad"
            }
        }
    }

}
