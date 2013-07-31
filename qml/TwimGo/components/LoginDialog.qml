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
    id: welcomeItem
    anchors.fill: parent
    signal exit()
    state: "hidden"
    property bool showButtons: false

    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log("..");
        }
    }

    Rectangle {
        id: welcomePage
        //anchors.fill: parent
        width: parent.width
        height: parent.height
        //color: theme.dialogBG

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#E73525" }
            GradientStop { position: 0.25; color: "#DB3223" }
            GradientStop { position: 0.75; color: "#D23022" }
            GradientStop { position: 1.0; color: "#9D1B0F" }
        }

        Image {
            id: logo
            source: "../pics/icon.png"
            x: parent.width/2 - width/2
            y: parent.height/8

            SequentialAnimation on scale {
                NumberAnimation {
                    from: 0.8
                    to: 1.0
                    duration: 700
                    easing.type: "InOutCubic"
                }
            }
            SequentialAnimation on opacity {
                NumberAnimation {
                    from: 0.0
                    to: 1.0
                    duration: 900
                }
            }
        }
/*
        Button {
            id: reloadButton
            label: "Reload"
            x: 10
            y: 10
            visible: welcomeItem.showButtons
            width: 140
            height: 60
            onClicked: {
                window.loadTimelineIndex();
            }
        }

        Button {
            id: logoutButton
            label: "Logout"
            visible: welcomeItem.showButtons
            x: 10
            y: 80
            width: 140
            height: 60
            onClicked: {
                window.logout();
            }
        }

        BackButton {
            id: quitButton
            icon: "../pics/delete.png"
            x: parent.width - width
            visible: welcomeItem.showButtons
            y: 0
            onClicked: {
                Qt.quit();
            }
        }
*/
        Text {
            id: copy
            text: "v3.3.2 © 2011-2013 Tommi Laukkanen\nTwitter: @tlaukkanen\nwww.substanceofcode.com"
            y: parent.height - height - 8
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            color: "#E8DDCB"
        }
    }

    states: [
        State {
            name: "hidden"
        },
        State {
            name: "shown"
            changes: [
                PropertyChanges {
                    target: welcomeItem
                    visible: true
                }
            ]
        }
    ]
}
