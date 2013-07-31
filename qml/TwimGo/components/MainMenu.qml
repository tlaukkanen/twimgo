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
    id: mainMenu
    signal clicked()
    property string action: ""
    property string apiStatus: ""
    width: parent.width
    height: parent.height < statusDialog.height ? parent.height : statusDialog.height
    state: "hidden"

    Flickable {
        y: 0
        id: menuFlickable
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: statusDialog.height

        Rectangle {
            id: statusDialog
            width: parent.width
            y: 0
            height: buttonColumn.y + buttonColumn.height + 20
            color: theme.dialogBG

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // Do nothing - Don't let the clicks leak underneath component
                }
            }

            Column {
                id: buttonColumn
                x: 10
                y: 10
                width: parent.width - 20
                spacing: 10

                Rectangle {
                    y: 10
                    x: 10
                    radius: 5
                    color: theme.dialogButtonAreaBG
                    width: parent.width - 20
                    height: mainButtonColumn.height+10

                    Column {
                        id: mainButtonColumn
                        width: parent.width
                        spacing: 10
                        y: 10

                        Row {
                            x: 10
                            spacing: 10
                            width: parent.width - 10
                            height: 50

                            Button {
                                label: qsTr("My tweets")
                                height: 50
                                width: parent.width/2 - 10
                                onClicked: {
                                    action = "MyTweets";
                                    mainMenu.clicked();
                                    mainMenu.state = "hidden";
                                }
                            }

                            Button {
                                label: qsTr("Friends")
                                height: 50
                                width: parent.width/2 - 10
                                onClicked: {
                                    action = "Friends";
                                    mainMenu.state = "hidden";
                                    mainMenu.clicked();
                                }
                            }

                        }

                        Row {
                            x: 10
                            spacing: 10
                            width: parent.width - 10
                            height: 50

                            Button {
                                label: qsTr("Direct messages")
                                height: 50
                                width: parent.width/2 - 10
                                onClicked: {
                                    action = "Direct";
                                    mainMenu.clicked();
                                    mainMenu.state = "hidden";
                                }
                            }

                            Button {
                                label: qsTr("Followers")
                                height: 50
                                width: parent.width/2 - 10
                                onClicked: {
                                    action = "Followers";
                                    mainMenu.state = "hidden";
                                    mainMenu.clicked();
                                }
                            }

                        }

                        Row {
                            x: 10
                            spacing: 10
                            width: parent.width - 10
                            height: 50

                            Button {
                                label: qsTr("Retweets of me")
                                height: 50
                                width: parent.width/2 - 10
                                onClicked: {
                                    action = "Retweets";
                                    mainMenu.state = "hidden";
                                    mainMenu.clicked();
                                }
                            }

                            Button {
                                label: qsTr("Favourites")
                                height: 50
                                width: parent.width/2 - 10
                                onClicked: {
                                    action = "Favourites";
                                    mainMenu.state = "hidden";
                                    mainMenu.clicked();
                                }
                            }
                        }

                        Row {
                            x: 10
                            spacing: 10
                            width: parent.width - 10
                            height: 50

                            Button {
                                id: searchButton
                                label: qsTr("Search")
                                height: 50
                                width: parent.width/2 - 10
                                onClicked: {
                                    action = "Search";
                                    mainMenu.clicked();
                                    mainMenu.state = "hidden";
                                }
                            }

                            Button {
                                id: listsButton
                                label: qsTr("Your lists")
                                height: 50
                                width: parent.width/2 - 10
                                onClicked: {
                                    action = "Lists";
                                    mainMenu.clicked();
                                    mainMenu.state = "hidden";
                                }
                            }
                        }

                        Row {
                            x: 10
                            spacing: 10
                            width: parent.width - 10
                            height: 50

                            Button {
                                label: qsTr("Saved searches")
                                height: 50
                                width: parent.width/2 - 10
                                onClicked: {
                                    action = "SavedSearches";
                                    mainMenu.clicked();
                                    mainMenu.state = "hidden";
                                }
                            }

                            Button {
                                label: qsTr("Trends")
                                height: 50
                                width: parent.width/2 - 10
                                onClicked: {
                                    action = "Trends";
                                    mainMenu.state = "hidden";
                                    mainMenu.clicked();
                                }
                            }
                        }

                        Row {
                            x: 10
                            spacing: 10
                            width: parent.width - 10
                            height: 60

                            Button {
                                label: qsTr("Settings")
                                height: 50
                                width: parent.width/2 - 10
                                onClicked: {
                                    action = "Settings";
                                    mainMenu.clicked();
                                    mainMenu.state = "hidden";
                                }
                            }

                            Button {
                                label: qsTr("Logout")
                                height: 50
                                width: parent.width/2 - 10
                                onClicked: {
                                    action = "Logout";
                                    mainMenu.state = "hidden";
                                    mainMenu.clicked();
                                }
                            }
                        } // Row

                    } // Column

                } // Rectangle (gray)

                Rectangle {
                    id: exitButtonContainer
                    radius: 5
                    color: theme.dialogButtonAreaBG
                    x: 10
                    width: parent.width - 20
                    height: 70

                    Button {
                        id: exitButton
                        label: qsTr("Exit")
                        width: parent.width/2 - 15
                        x: 10
                        y: 10
                        onClicked: {
                            Qt.quit();
                        }
                    }

                    Button {
                        id: cancelButton
                        label: qsTr("Cancel")
                        width: parent.width/2 - 15
                        x: parent.width/2 + 5
                        y: 10 //
                        onClicked: {
                            action = "Cancel";
                            mainMenu.state = "hidden";
                            mainMenu.clicked();
                            mainMenu.state = "hidden"
                        }
                    }
                }

                Text {
                    //width: parent.width - 20
                    wrapMode: Text.WrapAnywhere
                    //x: 10

                    anchors.horizontalCenter: parent.horizontalCenter
                    text: mainMenu.apiStatus
                    color: "#001018"
                    font.pixelSize: 12
                }

            } // Column

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
            target: mainMenu
            y: menuFlickable.contentHeight<parent.height ? 0 - parent.height - 30 : 0 - menuFlickable.contentHeight - 30
        }
    }
    State {
        name: "shown"
        PropertyChanges {
            target: mainMenu
            y: 0
        }
    }

    transitions: Transition {
        SequentialAnimation {
            PropertyAnimation {
                target: mainMenu
                properties: "y"
                duration: 500
                easing.type: "OutQuad"
            }
        }
    }

}
