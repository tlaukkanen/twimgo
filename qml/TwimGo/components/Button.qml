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
    id: button
    property alias label: buttonText.text
    signal clicked()
    width: parent.width; height: 50
    property bool showImage: false
    property string icon: ""

    Rectangle {
        id: buttonRect
        anchors.fill: parent
        radius: 4
        gradient: !mouseArea.pressed ? idleColor : pressedColor
        smooth: true

        Text {
            id: buttonText
            text: "What?"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color: theme.buttonTextColor
            font.pixelSize: 18
        }

        Image {
            visible: button.showImage
            source: button.icon
            anchors.centerIn: parent
        }
    }

    Gradient {
        id: pressedColor
    	GradientStop { position: 0.0; color: "#445" }
        GradientStop { position: 0.1; color: "#556" }
        GradientStop { position: 0.9; color: "#667" }
        GradientStop { position: 1.0; color: "#778" }
    }

    Gradient {
        id: idleColor
        GradientStop { position: 0.0; color: "#ddd" }
        GradientStop { position: 0.1; color: "#ccc" }
        GradientStop { position: 0.8; color: "#999" }
        GradientStop { position: 1.0; color: "#bbb" }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            button.clicked();
        }
    }	

}
