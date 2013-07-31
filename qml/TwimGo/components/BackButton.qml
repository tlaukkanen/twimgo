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
    id: backButton
    signal clicked()
    y: parent.height - 80
    height: 80
    x: 0
    width: 80
    property string icon: "../pics/arrowleft.png"

    Image {
        source: "../pics/backbutton_shadow.png"

        Button {
            anchors.centerIn: parent
            width: 60
            height: 60
            label: ""

            onClicked: {
                backButton.clicked();
            }
        }
	
        Image {
            source: backButton.icon
            anchors.centerIn: parent
        }
	
    }

}
