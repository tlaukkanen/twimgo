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

MouseArea {
    signal swipeRight;
    signal swipeLeft;

    property int startX;
    property int startY;

    onPressed: {
        startX = mouse.x;
        startY = mouse.y;
    }

    onReleased: {
        var deltax = mouse.x - startX;
        var deltay = mouse.y - startY;

        if (Math.abs(deltax) > 70) {
            if (deltax > 50 && Math.abs(deltay) < 60) {
                // swipe right
                swipeRight();
            } else if (deltax < -50 && Math.abs(deltay) < 60) {
                // swipe left
                swipeLeft();
            }
        }
    }
}
