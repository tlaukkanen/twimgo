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
    id: profileDialogItem
    signal showTweets()
    signal follow()
    signal unfollow()
    signal directTweet(string userID, string username)
    signal sendMsg(string userID, string username)
    signal goBack()
    anchors.fill: parent
    property string userID: ""
    property string profileImageURL: ""
    property string username: ""
    property string userURL: ""
    property string userLocation: "Unknown"
    property string followersCount: "0"
    property string followingCount: "0"
    property string tweetCount: "0"
    property string description: ""
    property bool isFollowing: true

    Rectangle {
        id: profileDialog
        width: parent.width
        y: 0
        height: parent.height
	
        color: theme.detailBG
        /*
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#ccc" }
            GradientStop { position: 0.8; color: "#ccc" }
            GradientStop { position: 1.0; color: "#999" }
        }*/

        Column {
            x: 10
            width: parent.width - 20
            spacing: 10
            y: 10

            Row {
                spacing: 10
                width: parent.width
                height: 96

                Image {
                    id: profileImage
                    source: profileImageURL
                    width: 96
                    height: 96
                    smooth: true
                }

                Column {
                    //anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - 66

                    Text {
                        id: usernameLabel
                        color: theme.dialogTextColor // "#eee"
                        text: username
                        wrapMode: Text.WordWrap
                        width: parent.width
                        //y: 10
                        font.pixelSize: 18
                    }

                    Text {
                        id: locationLabel
                        color: theme.dialogTextColor //"#ddd"
                        text: userLocation
                        wrapMode: Text.WordWrap
                        width: parent.width
                        font.pixelSize: 18
                    }

                }


            }

            Rectangle {
                height: profileDescription.height + 20
                width: parent.width
                radius: 5
                color: theme.dialogTextBG // "#bbb"

                Text {
                    id: profileDescription
                    text: description
                    font.pixelSize: 16
                    wrapMode: Text.WordWrap
                    width: parent.width - 20
                    x: 10
                    y: 10
                    color: theme.dialogTextColor // "#111"
                }
            }
            Row {
                width: parent.width - 5
                height: 60
                spacing: 10
                x: 0

                Rectangle {
                    y: 10
                    radius: 5
                    color: theme.dialogTextBG // "#aaa"
                    width: parent.width/3 - 5
                    height: 50
                    Text {
                        text: qsTr("Tweets")
                        font.pixelSize: 12
                        color: "#666"
                        x: 2
                        y: 2
                    }
                    Text {
                        text: tweetCount
                        width: parent.width-10
                        height: parent.height
                        font.pixelSize: 18
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        color: theme.dialogTextColor //"#111"
                    }
                }
                Rectangle {
                    y: 10
                    radius: 5
                    color: theme.dialogTextBG //"#aaa"
                    width: parent.width/3 - 5
                    height: 50
                    Text {
                        text: qsTr("Following")
                        font.pixelSize: 12
                        color: "#666"
                        x: 2
                        y: 2
                    }
                    Text {
                        width: parent.width-10
                        height: parent.height
                        text: followingCount
                        font.pixelSize: 18
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        color: theme.dialogTextColor //"#111"
                    }
                }
                Rectangle {
                    y: 10
                    radius: 5
                    color: theme.dialogTextBG //"#aaa"
                    width: parent.width/3 - 5
                    height: 50
                    Text {
                        text: qsTr("Followers")
                        font.pixelSize: 12
                        color: "#666"
                        x: 2
                        y: 2
                    }
                    Text {
                        text: followersCount
                        width: parent.width-10
                        height: parent.height
                        font.pixelSize: 18
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        color: theme.dialogTextColor //"#111"
                    }
                }
            }
        }

        CustomToolbar {
            id: detailsToolbar

            Row {
                y: 10
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: window.iconSpacing

                CustomToolbarIcon {
                    id: detailsBackIcon
                    iconImage: "../pics/toolbar/arrow_left_icon&32.png"
                    iconText: qsTr("Back")
                    onClicked: {
                        profileDialogItem.goBack();
                    }
                }

                CustomToolbarIcon {
                    iconImage: isFollowing ? "../pics/toolbar/invisible_revert_icon&32.png" : "../pics/toolbar/eye_inv_icon&32.png"
                    iconText: isFollowing ? qsTr("Unfollow") : qsTr("Follow")
                    onClicked: {
                        if(isFollowing) {
                            profileDialogItem.unfollow();
                        } else {
                            profileDialogItem.follow();
                        }
                        isFollowing = !isFollowing;
                    }
                }

                CustomToolbarIcon {
                    iconImage: "../pics/toolbar/twitter_2_icon&32.png"
                    iconText: qsTr("Tweets")
                    onClicked: {
                        profileDialogItem.showTweets();
                    }
                }

                CustomToolbarIcon {
                    iconImage: "../pics/toolbar/spechbubble_sq_line_icon&32.png"
                    iconText: qsTr("Send")
                    onClicked: {
                        profileDialogItem.sendMsg(profileDialogItem.userID, profileDialogItem.username);
                    }
                }

                CustomToolbarIcon {
                    iconImage: "../pics/toolbar/mail_icon&32.png"
                    iconText: qsTr("Message")
                    onClicked: {
                        profileDialogItem.directTweet(profileDialogItem.userID, profileDialogItem.username);
                    }
                }
            }
        } // Custom toolbar
    }

    states:
        State {
        name: "hidden"
        PropertyChanges {
            target: profileDialog
            y: 0 - profileDialog.height - 16
        }
    }
    State {
        name: "shown"
        PropertyChanges {
            target: profileDialog
            y: 0
        }
    }

    transitions: Transition {
        SequentialAnimation {
            PropertyAnimation {
                target: profileDialog
                properties: "y"
                duration: 600
                easing.type: "OutQuad"
            }
        }
    }

}
