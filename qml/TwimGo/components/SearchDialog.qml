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
    id: searchDialogItem
    signal clicked(string query, string lat, string lon)
    property string searchText: ""
    property bool useLocation: false
    property bool saveSearch: false
    width: parent.width; height: 160
    state: "hidden"

    Rectangle {
        id: searchDialog
        width: parent.width
        y: 0
        height: searchButtonContainer.y + searchButtonContainer.height + 30

        color: theme.dialogBG
        /*
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#ccc" }
            GradientStop { position: 0.9; color: "#ccc" }
            GradientStop { position: 1.0; color: "#999" }
        }*/

        MouseArea {
            anchors.fill: parent
            onClicked: {
                // Do nothing - Don't let the clicks leak underneath component
            }
        }

        Text {
            id: searchLabel
            text: qsTr("Search tweets")
            font.pixelSize: 22
            y: 20
            x: 10
            color: "#eee"
        }

        CustomTextInput {
            id: searchText
            height: 40
            width: parent.width-20
            x: 10
            y: searchLabel.y + searchLabel.height
            //anchors.fill: parent
            //color: "#111"
            //font.pixelSize: 22
        }

        Row {
            id: locationRow
            visible: window.locationAvailable
            spacing: 10
            width: parent.width - 64
            height: 42
            y: searchText.y + searchText.height + 20
            x: 10

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
                    visible: searchDialogItem.useLocation
                }

                MouseArea {
                    id: useLocationMouseArea
                    anchors.fill: parent
                    onClicked: {
                        searchDialogItem.useLocation = !searchDialogItem.useLocation;
                        if(searchDialogItem.useLocation) {
                            positionSource.active = true;
                        }
                    }
                }
            }

            Text {
                text: qsTr("Search nearby")
                width: parent.width - 128
                wrapMode: Text.Wrap
                font.pixelSize: 22
                anchors.verticalCenter: parent.verticalCenter
                color: "#ddd"
            }

            Text {
                text: window.lat=="NaN"||window.lat=="" ? "<span>" + qsTr("Please Wait") + "</span>" : "<span>" + qsTr("Location OK") + "</span>"
                width: 100
                wrapMode: Text.Wrap
                font.pixelSize: 11
                anchors.verticalCenter: parent.verticalCenter
                color: "#ddd"
                visible: searchDialogItem.useLocation
            }

        }

        Row {
            id: saveRow
            spacing: 10
            width: parent.width - 64
            height: 42
            y: window.locationAvailable ? locationRow.y + locationRow.height + 20 : searchText.y + searchText.height + 20
            //y: locationRow.y + locationRow.height + 10
            x: 10

            Rectangle {
                border.width: 1
                border.color: "#444"
                color: saveMouseArea.pressed ? "#555" : "#111"
                radius: 5
                width: 42
                height: 42

                Image {
                    anchors.centerIn: parent
                    source: "../pics/delete.png"
                    visible: searchDialogItem.saveSearch
                }

                MouseArea {
                    id: saveMouseArea
                    anchors.fill: parent
                    onClicked: {
                        searchDialogItem.saveSearch = !searchDialogItem.saveSearch;
                    }
                }
            }

            Text {
                text: qsTr("Save")
                width: parent.width - 128
                wrapMode: Text.Wrap
                font.pixelSize: 22
                anchors.verticalCenter: parent.verticalCenter
                color: "#ddd"
            }
        }


        Rectangle {
            id: searchButtonContainer
            radius: 5
            color: theme.dialogButtonAreaBG // "#999"
            //y: tweetTextContainer.y + tweetTextContainer.height + 20
            x: 10
            width: parent.width - 20
            height: 70
            y: saveRow.y + saveRow.height + 20

            Button {
                id: searchButton
                label: qsTr("Search")
                width: parent.width/2 - 15
                x: 10
                y: 10
                onClicked: {
                    //searchText.closeSoftwareInputPanel();
                    searchDialogItem.searchText = searchText.getText();
                    searchDialogItem.clicked(searchText.getText(), window.lat, window.lon);
                    searchDialogItem.state = "hidden"
                }
            }

            Button {
                id: cancelButton
                label: qsTr("Cancel")
                width: parent.width/2 - 15
                x: parent.width/2 + 5
                y: 10 //
                onClicked: {
                    //searchText.closeSoftwareInputPanel();
                    searchDialogItem.state = "hidden"
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

    states:
        State {
        name: "hidden"
        PropertyChanges {
            target: searchDialog
            y: 0 - searchDialog.height - 16
        }
    }
    State {
        name: "shown"
        PropertyChanges {
            target: searchDialog
            y: 0
        }
    }

    transitions: Transition {
        SequentialAnimation {
            PropertyAnimation {
                target: searchDialog
                properties: "y"
                duration: 600
                easing.type: "OutQuad"
            }
        }
    }

}
