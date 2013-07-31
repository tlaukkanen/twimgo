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
    id: listOfLists
    signal clicked()
    property string action: ""
    property ListModel listModel: listOfListsModel
    width: parent.width
    height: parent.height - 90
    state: "hidden"
    y: 0

    ListModel {
        id: listOfListsModel
    }

    Rectangle {
        id: listsContainer
        width: parent.width
        y: 0
        height: parent.height
        color: theme.dialogBG

        MouseArea {
            anchors.fill: parent
            onClicked: {
                // Do nothing - Don't let the clicks leak underneath component
            }
        }

        Rectangle {
            y: 10
            x: 10
            color: theme.dialogButtonAreaBG
            clip: true
            width: parent.width - 20
            height: listsContainer.height - 90

            ListView {
                model: listOfListsModel
                delegate:  listsDelegate
                id: listsColumn
                x: 10
                y: 0
                width: parent.width - 20
                height: parent.height
                spacing: 10
            }

            Image {
                source: "../pics/top-shadow.png"
                y: 0
                height: 16
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
            }

            Image {
                source: "../pics/top-shadow.png"
                y: parent.height
                height: 16
                transform: Rotation { origin.x: parent.width/2-10; origin.y: 0; angle: 180}
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
            }

        } // Rectangle (gray)

        Button {
            x: 10
            y: listsContainer.height - 70
            id: cancelButton
            label: qsTr("Back")
            height: 50
            width: parent.width - 20
            onClicked: {
                listOfLists.state = "hidden"
            }
        }
    } // Rectangle

    Image {
        source: "../pics/top-shadow.png"
        y: parent.height
        height: 16
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
    }

    states:
        State {
        name: "hidden"
        PropertyChanges {
            target: listOfLists
            y: 0 - listsContainer.height - 30
        }
    }
    State {
        name: "shown"
        PropertyChanges {
            target: listOfLists
            y: 0
        }
    }

    transitions: Transition {
        SequentialAnimation {
            /*ScriptAction {
				script: {
					if(listOfLists.state=="shown") {
						listOfLists.opacity = 1;
					}
				}
			}*/
            PropertyAnimation {
                target: listOfLists
                properties: "y"
                duration: 500
                easing.type: "OutQuad"
            }/*
			ScriptAction {
				script: {
					if(listOfLists.state=="hidden") {
						listOfLists.opacity = 0;
					}
				}
			}*/
        }
    }

    Component {
        id: listsDelegate

        Item {
            width: parent.width
            height: 50

            Button {
                label: slug
                onClicked: {
                    listOfLists.state = "hidden";
                    action = slug;
                    listOfLists.clicked();
                }
            }

        }
    }

}

