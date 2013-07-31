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
    id: theme
    property color dialogBG: "#606a6f"
    property color dialogTextBG: "#949a9f"
    property color dialogButtonAreaBG: "#505a5f"
    property color dialogTextColor: "#ddd"
    property color dialogInfoTextColor: "#333"
    property color detailBG: "#303a3f"
    property color buttonTextColor: "#1F171B" // "#300018"
    property color toolbarTextColor: "#999"
    property bool isBlack: true

    property color tweetTopColor: "#242c2f"
    property color tweetMiddleColor: "#101212"
    property color tweetBottomColor: "#050909"
    property color tweetBottomMineColor: "#311"
    property color tweetBottomForMeColor: "#131"

    property color tweetTextColor: "#eee"
    property color tweetInfoTextColor: "#a0b0c0"
    property color tweetsBackground: "#2d2f33"

    function switchTheme() {
        theme.isBlack = !theme.isBlack;
        if(theme.isBlack) {
            theme.dialogBG = "#606a6f";
            theme.dialogTextBG = "#949a9f";
            theme.dialogButtonAreaBG = "#505a5f";
            theme.detailBG = "#303a3f";
            theme.dialogTextColor = "#ddd";
            theme.dialogInfoTextColor = "#333";
            theme.buttonTextColor = "#1F171B"; //  "#300018";
            theme.toolbarTextColor = "#999";

            theme.tweetTopColor = "#242c2f";
            theme.tweetMiddleColor = "#101212";
            theme.tweetBottomColor = "#050909";
            theme.tweetBottomMineColor = "#311";
            theme.tweetBottomForMeColor = "#131";

            theme.tweetTextColor = "#eee";
            theme.tweetInfoTextColor = "#a0b0c0";
            theme.tweetsBackground = "#2d2f33";
        } else {
            theme.dialogBG = "#ddd";
            theme.dialogTextBG = "#ccc";
            theme.dialogButtonAreaBG = "#999";
            theme.detailBG = "#eee";
            theme.dialogTextColor = "#333";
            theme.dialogInfoTextColor = "#333";
            theme.buttonTextColor = "#191822";
            theme.toolbarTextColor = "#555";

            theme.tweetTopColor = "#e9e9e9";
            theme.tweetMiddleColor = "#fff";
            theme.tweetBottomColor = "#f4f4f5";
            theme.tweetBottomMineColor = "#fdd";
            theme.tweetBottomForMeColor = "#dfd";

            theme.tweetTextColor = "#222";
            theme.tweetInfoTextColor = "#777";
            theme.tweetsBackground = "#eaeaea";
        }
    }
}
