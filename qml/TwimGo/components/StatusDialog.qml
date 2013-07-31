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
//import QtMobility.location 1.1

Item {
    id: statusDialogItem
    signal clicked(string text, string reply, string dm, string lat, string lon)
    width: parent.width; height: 150
    state: "hidden"
    property string statusText: ""
    property string replyName: ""
    property string replyID: ""
    property string dmUserID: ""
    property bool useLocation: false

    Timer {
        id: lengthChecker
        interval: 1000
        repeat: true
        onTriggered: {
            var remaining = 140 - tweetText.getText().length;
            tweetLength.text = remaining;
        }
    }

    Rectangle {
        id: statusDialog
        width: parent.width
        y: 0
        height: statusButtonsColumn.y + statusButtonsColumn.height + 20
        color: theme.dialogBG

        MouseArea {
            anchors.fill: parent
            onClicked: {
                // Do nothing - Don't let the clicks leak underneath component
            }
        }

        Text {
            id: statusLabel
            text: replyID!="" ? (statusDialogItem.dmUserID!="" ? qsTr("Message to") : qsTr("Reply to")) + " " + statusDialogItem.replyName : (statusDialogItem.dmUserID!="" ? qsTr("Direct message") : qsTr("Status update"))
            font.pixelSize: 22
            color: theme.dialogInfoTextColor //theme.dialogTextBG // "#eee"
            y: 20
            x: 10
        }

        Text {
            id: tweetLength
            text: ""
            font.pixelSize: 22
            color: theme.dialogInfoTextColor //theme.dialogTextBG //"#ddd"
            y: 20
            x: 10
            width: parent.width-20
            horizontalAlignment: Text.AlignRight
        }

        CustomTextEdit {
            id: tweetText
            height: windowHelper.isSymbian ? ((window.height>window.width) ? 160 : 100) : ((window.height>window.width) ? 200 : 140)
            width: parent.width-20
            x: 10
            y: statusLabel.y + statusLabel.height
            //color: theme.dialogInfoTextColor //"#111"
            //font.pixelSize: 22
        }

        Column {
            id: statusButtonsColumn
            x: 10
            width: parent.width - 20
            spacing: 10
            y: tweetText.y + tweetText.height + 20

            Row {
                id: locationRow
                spacing: 10
                width: parent.width - 64
                height: 42
                visible: window.locationAvailable

                Rectangle {
                    border.width: 1
                    border.color: "#444"
                    color: useLocationMouseArea.pressed ? "#555" : "#111"
                    radius: 5
                    width: 42
                    height: 42

                    Image {
                        anchors.centerIn: parent
                        source: "../pics/delete.png"
                        visible: statusDialogItem.useLocation
                    }

                    MouseArea {
                        id: useLocationMouseArea
                        anchors.fill: parent
                        onClicked: {
                            statusDialogItem.useLocation = !statusDialogItem.useLocation;
                            positionSource.active = true;
                        }
                    }
                }

                Text {
                    text: qsTr("Share location")
                    width: parent.width - 128
                    wrapMode: Text.Wrap
                    font.pixelSize: 22
                    anchors.verticalCenter: parent.verticalCenter
                    color: theme.dialogInfoTextColor //"#ddd"
                }

                Text {
                    text: window.lat=="NaN"||window.lat=="" ? "<span>Please<br/>Wait</span>" : "<span>Location<br/>OK</span>"
                    width: 100
                    wrapMode: Text.Wrap
                    font.pixelSize: 10
                    anchors.verticalCenter: parent.verticalCenter
                    color: theme.dialogInfoTextColor
                    visible: statusDialogItem.useLocation
                }

            }

            Rectangle {
                id: statusButtonContainer
                radius: 5
                color: theme.dialogButtonAreaBG
                width: parent.width
                height: 70
                //

                Row {
                    id: buttonRow
                    x: 10
                    width: parent.width - 10
                    height: 50
                    spacing: 10
                    y: 10

                    Button {
                        id: tweetButton
                        label: qsTr("Tweet")
                        width: (parent.width / 3) * 2 - 10
                        height: 50
                        onClicked: {
                            var lat = "";
                            var lon = "";
                            if(statusDialogItem.useLocation) {
                                lat = window.lat;
                                lon = window.lon;
                            }
                            statusDialogItem.clicked(
                                        tweetText.getText(),
                                        statusDialogItem.replyID,
                                        statusDialogItem.dmUserID,
                                        lat,
                                        lon);
                            statusDialogItem.state = "hidden";
                            //tweetText.closeSoftwareInputPanel();
                        }
                    }

                    Button {
                        id: cancelButton
                        label: qsTr("Cancel")
                        width: parent.width / 3 - 10
                        height: 50
                        onClicked: {
                            statusDialogItem.statusText = "";
                            statusDialogItem.state = "hidden"
                            statusDialogItem.replyID = "";
                            statusDialogItem.dmUserID = "";
                            //tweetText.closeSoftwareInputPanel();
                        }
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

    states: [
        State {
            name: "hidden"
            PropertyChanges {
                target: statusDialog
                y: 0 - statusDialog.height - 16
            }
        },
        State {
            name: "shown"
            changes: [
                PropertyChanges {
                    target: statusDialog
                    y: 0
                },
                PropertyChanges {
                    target: statusDialog
                    visible: true
                }
            ]
        }
    ]

    transitions: [
        Transition {
            to: "hidden"
            SequentialAnimation {
                PropertyAnimation {
                    target: statusDialog
                    properties: "y"
                    duration: 600
                    easing.type: "OutQuad"
                }
                ScriptAction {
                    script: {
                        console.log("Stopping timer");
                        lengthChecker.stop();
                        statusDialog.visible = false;
                    }
                }
            }
        },
        Transition {
            to: "shown"
            SequentialAnimation {
                PropertyAnimation {
                    target: statusDialog
                    properties: "y"
                    duration: 600
                    easing.type: "OutQuad"
                }
                ScriptAction {
                    script: {
                        console.log("Starting timer");
                        lengthChecker.start();
                    }
                }
            }
        }
    ]

}
