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

import QtQuick 1.1 // 4.7
import QtMobility.location 1.1
//import QtMultimediaKit 1.1
//import com.nokia.symbian 1.1
import com.nokia.meego 1.0

import "js/script.js" as Script
import "js/pocket.js" as Pocket
import "js/twitter.js" as Twitter
import "js/storage.js" as Storage
import "js/translate.js" as AzureTranslate
import "components"

PageStackWindow {
    initialPage: window
    showToolBar: false

Rectangle {
    id: window
    width: 360 // 360 // 640 //800
    height: 640 // 640 // 360 //424
    anchors.fill: parent
    property int tweetHeight: 138 // 132 //180
    property int tweetFontSize: 17 // 16
    property int iconFontSize: 10
    property string token: ""
    property int iconSpacing: 17
    property int startup: 0
    property int timelineIndex: 0
    property int gridColumns: 2
    property string lat: ""
    property string lon: ""
    color: "#333"

    //property variant positionSource
    property bool locationAvailable: true

    PositionSource {
        id: positionSource
        updateInterval: 1500
        active: false
    }

/*    Audio {
        id: birdSound
        source: "sounds/Birds.wav"
        volume:  0
        muted: true
    }
*/
    Timer {
        id: autoRefreshTimer
        interval: 300000 // 5 minutes
        repeat: true
        onTriggered: {
            if(container.flipped==false &&
                    statusDialog.state!="shown" &&
                    searchDialog.state!="shown" &&
                    mainMenu.state!="shown" &&
                    listsDialog.state!="shown" &&
                    searchesDialog.state!="shown" &&
                    trendsDialog.state!="shown" ) {
                Script.autoFresh();
            }
        }
    }

    Timer {
        id: hideSplashTimer
        interval: 4000
        repeat: false
        onTriggered: {
            if(welcomePage.visible==true) {
                welcomePage.visible = false;
                authorizeWindow.visible = false;
                container.state = "shown";
            }
        }
    }

    Timer {
        id: locationTimer
        interval: 3000
        repeat: true
        onTriggered: {
            if(typeof(positionSource)!="undefined" &&
                    typeof(positionSource.position.coordinate.latitude)!="undefined") {

                //console.log("Update locations");

                var coord = positionSource.position.coordinate;
                window.lat = String(coord.latitude);
                window.lon = String(coord.longitude);

                //console.log("LAT: " + window.lat);

                if(window.lat.length>0 && window.lat!="NaN") {
                    Storage.setKeyValue("latitude", window.lat);
                    Storage.setKeyValue("longitude", window.lon);
                }
            }
        }
    }

    Timer {
        id: screenSizeChecker
        interval: 2500
        repeat: false
        onTriggered: {
            var biggerSide = window.width;
            var smallerSide = window.height;
            if(smallerSide>window.width) {
                smallerSide = window.width;
                biggerSide = window.height;
            }
            if(windowHelper.isMaemo()) { // smallerSide>410) {
                // Maemo
                minimize.visible = true;
                window.tweetHeight = 170;
                window.iconSpacing = 38;
                window.tweetFontSize = 20;
                window.iconFontSize = 14;
            } else if(smallerSide>360 && smallerSide<500) {
                // Harmattan
                window.tweetHeight = 170;
                window.iconSpacing = 38;
                window.tweetFontSize = 22;
                window.iconFontSize = 14;
            } else if(smallerSide>500) {
                // Tablet
                window.gridColumns = 4;
                window.tweetFontSize = 16;
            } else if(smallerSide==480 && biggerSide==640) {
                // Symbian E6
                window.tweetHeight = 160;
                window.iconSpacing = 17;
                window.tweetFontSize = 20;
                window.iconFontSize = 14;
            }
        }
    }

    Component.onCompleted: {
        AzureTranslate.setComponents(
                    waiting,
                    waitingText,
                    doneIndicator,
                    errorIndicator);
        Pocket.setComponents(
                    waiting,
                    waitingText,
                    doneIndicator,
                    errorIndicator);
        Script.setComponents(
                    waiting,
                    doneIndicator,
                    profileDialog,
                    container,
                    errorIndicator,
                    welcomePage,
                    homeIcon,
                    mentionsIcon,
                    mainMenu);
        Storage.setKeyValue("username", ":D");
        Storage.setKeyValue("password", ":)");
        Storage.getKeyValue("lastHomeID", window.valueLoaded);
        Storage.getKeyValue("lastMentionID", window.valueLoaded);
        Storage.getKeyValue("useListView", window.valueLoaded);
        Storage.getKeyValue("refresh", window.valueLoaded);
        Storage.getKeyValue("longitude", window.valueLoaded);
        Storage.getKeyValue("latitude", window.valueLoaded);
        Storage.getKeyValue("useLightTheme", window.valueLoaded);
        //Storage.getKeyValue("useSound", window.valueLoaded);
        Storage.getKeyValue("screenName", window.valueLoaded);
        Storage.getKeyValue("userId", window.valueLoaded);
        Storage.getKeyValue("pocketUsername", window.valueLoaded);
        Storage.getKeyValue("pocketPassword", window.valueLoaded);

        //createPositionSource();
        locationTimer.start();
        loadMoreTimer.start();
        screenSizeChecker.start();
    }

    function valueLoaded(key, value) {
        if(key=="latitude") {
            window.lat = value;
        } else if(key=="longitude") {
            window.lon = value;
        } else if(key=="pocketUsername") {
            settingsDialog.setPocketUsername(value);
        } else if(key=="pocketPassword") {
            settingsDialog.setPocketPassword(value);
        } else if(key=="lastHomeID") {
            Script.setLastHomeID(value);
        } else if(key=="lastMentionID") {
            Script.setLastMentionID(value);
        } else if(key=="useListView") {
            if(value=="yes") {
                settingsDialog.useList = true;
            } else {
                settingsDialog.useList = false;
            }

        } else if(key=="useLightTheme") {
            if(value=="yes") {
                settingsDialog.useLightTheme = true;
                theme.switchTheme();
            } else {
                settingsDialog.useLightTheme = false;
            }
        } else if(key=="useSound") {
            if(value=="yes") {
                settingsDialog.useSound = true;
                console.log("Sound activated");
//                birdSound.muted = false;
//                birdSound.volume = 0.4;
            } else {
//                birdSound.volume = 0;
//                birdSound.muted = true;
                console.log("Sound deactivated");
                settingsDialog.useSound = false;
            }
        } else if(key=="refresh") {
            try {
                settingsDialog.autoRefresh = value;
                if(value!="0") {
                    autoRefreshTimer.interval = parseInt(value) * 1000 * 60;
                    if(autoRefreshTimer.interval<59000) {
                        autoRefreshTimer.interval = 300000;
                    }
                    autoRefreshTimer.start();
                }
            } catch(exp) {
                console.log("Error while starting auto refresh");
            }
        } else if(key=="screenName") {
            if((typeof(value)=="undefined" || value=="") && authorizeWindow.visible==false) {
                Script.resetTokens();
                Script.getTwitterTimeAndToken();
                //Script.requestToken();
                authorizeWindow.visible = true;
            } else {
                hideSplashTimer.start();
                Script.currentScreenName = value;
                Script.myUsername = value;
                Script.getTwitterTimeAndLogin();
                //Script.login();
            }
        } else if(key=="userId") {
            Script.currentUserID = value;
        }
    }

    function loadTimelineIndex() {
        if(window.timelineIndex==0) {
            Script.loadHome();
        } else if(window.timelineIndex==1) {
            Script.loadMentions();
        } else {
            Script.loadDirectMessages();
        }
    }

    function logout() {
        welcomePage.showButtons = false;
        Script.showLogin();
    }

    ListModel {
        id: tweetsModel
    }

    ListModel {
        id: hashtagActionsModel
    }

    Rectangle {
        id: container
        property bool flipped: false;
        property int angle: 180;
        property int xAxis: 0
        property int yAxis: 1
        x: 0
        y: -parent.height
        width: parent.width
        height: parent.height
        opacity: 1

        Rectangle {
            id: tweetsContainer
            color: "#333"
            anchors.fill: parent
            x: parent.width

            states:
                State {
                name: "shown"
                PropertyChanges {
                    target: tweetsContainer
                    x: 0
                }
                PropertyChanges {
                    target: tweetsContainer
                    opacity: 1
                }
            }

            transitions: Transition {
                SequentialAnimation {
                    ScriptAction {
                        script: {
                            welcomePage.state = "hidden";
                        }
                    }
                    PropertyAnimation {
                        target: tweetsContainer
                        properties: "x"
                        duration: 600
                        easing.type: "OutQuad"
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: parent.height //- 80
                color: theme.tweetsBackground // "#2d2f33" // "#3d3f48" // #444d50" // "#050505" // "#999999"

                Timer {
                    id: loadMoreTimer
                    interval: 555
                    repeat: true
                    onTriggered: {
                        if((tweetsList.visible && tweetsList.atYEnd) || (tweetsGrid.visible && tweetsGrid.atYEnd)) {
                            if(tweetsModel.count>0) {
                                var last = tweetsModel.get(tweetsModel.count-1);
                                if(last.status.indexOf("Load more...")>=0) {
                                    console.log("Triggered load more...");
                                    last.status = qsTr("Please wait...") + "<br/><br/><br/><br/>";
                                    Script.loadNextPage();
                                }
                            }
                        }
                        if(tweetsList.visible && tweetsList.atYBeginning) {
                            if(!pullLabel.visible && tweetsList.contentY<-2) {
                                pullLabel.visible = true;
                            } else if(pullLabel.visible && tweetsList.contentY>=0) {
                                pullLabel.text = qsTr("Pull down to refresh");
                                pullLabel.visible = false;
                            }
                            if(tweetsList.contentY<-50) {
                                pullLabel.text = qsTr("Release to refresh");
                            }
                        } else if(tweetsGrid.visible && tweetsGrid.atYBeginning) {
                            if(!pullLabel.visible && tweetsGrid.contentY<-2) {
                                pullLabel.visible = true;
                            } else if(pullLabel.visible && tweetsGrid.contentY>=0) {
                                pullLabel.text = qsTr("Pull down to refresh");
                                pullLabel.visible = false;
                            }
                            if(tweetsGrid.contentY<-50) {
                                pullLabel.text = qsTr("Release to refresh");
                            }
                        }
                    }
                }

                Item {
                    id: pullText
                    width: window.width
                    height: 0

                    Text {
                        id: pullLabel
                        text: qsTr("Pull down to refresh")
                        font.pixelSize: window.tweetFontSize
                        font.bold: true
                        visible: false
                        width: window.width
//                        anchors.top: window.top
//                        anchors.horizontalCenter: window.horizontalCenter
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter
                        color: theme.tweetTextColor
                    }
                }

                ListView {
                    id: tweetsList
                    visible: settingsDialog.useList ? true : (parent.width>parent.height ? false : true)
                    anchors.fill: parent
                    model: tweetsModel
                    delegate: tweetsDelegate
                    header: pullText
                    onMovingChanged: {
                        if(tweetsList.atYBeginning && pullLabel.text==qsTr("Release to refresh")) {
                            // Refresh
                            pullLabel.text = qsTr("Pull to refresh");
                            pullLabel.visible = false;
                            Script.autoFresh();
                        }
                    }
                }

                GridView {
                    id: tweetsGrid
                    visible: settingsDialog.useList ? false : (parent.width>parent.height ? true : false)
                    cellWidth: parent.width/window.gridColumns - 1
                    cellHeight: window.tweetHeight;
                    anchors.fill: parent
                    model: tweetsModel
                    delegate: tweetsDelegate
                    header: pullText
                    onMovementEnded: {
                        if(tweetsGrid.atYBeginning && pullLabel.text==qsTr("Release to refresh")) {
                            // Refresh
                            pullLabel.text = qsTr("Pull to refresh");
                            pullLabel.visible = false;
                            Script.autoFresh();
                        }
                    }
                }

//                CustomGestureArea {
//                    anchors.fill: parent
//                    onSwipeRight: {
//                        timelineIndex--;
//                        if(timelineIndex<0) {
//                            timelineIndex = 2;
//                        }
//                        loadTimelineIndex();
//                    }
//                    onSwipeLeft: {
//                        timelineIndex++;
//                        if(timelineIndex>2) {
//                            timelineIndex = 0;
//                        }
//                        loadTimelineIndex();
//                    }
//                }
            }

            StatusDialog {
                id: statusDialog
                height: 140
                onClicked: {
                    console.log("Clicked, status: " + text);
                    console.log("Clicked, replyID: " + reply);
                    console.log("Clicked, DM: " + dm);
                    Script.updateStatus(text, reply, dm, lat, lon);
                }
            }

            SearchDialog {
                id: searchDialog
                onClicked: {
                    console.log("search for: " + searchText);
                    if(searchDialog.saveSearch) {
                        Script.saveSearch(query, lat, lon);
                    } else {
                        Script.doSearch(query, lat, lon);
                    }
                }
            }

            ListsDialog {
                id: listsDialog
                onClicked: {
                    console.log("list selected: " + action);
                    Script.loadList(action);
                }
            }

            TrendsDialog {
                y: 0
                id: trendsDialog
                onClicked: {
                    console.log("trend selected: " + action);
                    Script.doSearch(action);
                }
            }

            SearchesDialog {
                id: searchesDialog
                onClicked: {
                    console.log("search selected: " + action);
                    Script.doSearch(action);
                }
                onRemoveSearch: {
                    console.log("remove " + searchID);
                    Script.removeSearch(searchID);
                }
            }

            Item {
                height: 50
                width: 50
                y: parent.height - height
                anchors.horizontalCenter: parent.horizontalCenter

                Image {
                    id: showBarButton
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "pics/up.png"
                }

                MouseArea {
                    id: showBarMouseArea
                    anchors.fill: parent
                    onClicked: {
                        menubar.state = "shown";
                    }
                }
            }

            CustomToolbar {
                id: menubar

                Row {
                    y: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: window.iconSpacing

                    CustomToolbarIcon {
                        id: homeIcon
                        iconImage: "../pics/toolbar/home_icon&32.png"
                        iconText: qsTr("Home")
                        showNewIndicator: false
                        onClicked: {
                            window.timelineIndex = 0;
                            Script.loadHome();
                            container.flipped = false;
                        }
                    }

                    CustomToolbarIcon {
                        id: mentionsIcon
                        iconImage: "../pics/toolbar/mentions_icon&32.png"
                        iconText: qsTr("Mentions")
                        showNewIndicator: false
                        onClicked: {
                            window.timelineIndex = 1;
                            Script.loadMentions();
                            container.flipped = false;
                        }
                    }

                    CustomToolbarIcon {
                        id: directIcon
                        iconImage: "../pics/toolbar/mail_2_icon&32.png"
                        iconText: qsTr("Messages")
                        onClicked: {
                            window.timelineIndex = 2;
                            Script.loadDirectMessages();
                        }
                    }

                    CustomToolbarIcon {
                        id: statusIcon
                        iconImage: "../pics/toolbar/spechbubble_icon&32.png"
                        iconText: qsTr("Status")
                        onClicked: {
                            if(statusDialog.state=="shown") {
                                statusDialog.state = "hidden";
                            } else {
                                statusDialog.state = "shown";
                                console.log("Resetting status text");
                                statusDialog.statusText = "-";
                                statusDialog.statusText = "";
                                statusDialog.replyName = "";
                                statusDialog.replyID = "";
                                statusDialog.dmUserID = "";
                            }
                        }
                    }

                    Image {
                        visible: (window.width>window.height ? true : false)
                        source: "pics/down.png"
                        opacity: !hideToolbarMouseArea.pressed ? 1 : 0.5
                        anchors.verticalCenter: parent.verticalCenter
                        MouseArea {
                            id: hideToolbarMouseArea
                            anchors.fill: parent
                            onClicked:  {
                                menubar.state = "hidden";
                            }
                        }
                    }

                    CustomToolbarIcon {
                        id: searchIcon
                        visible: (window.width>window.height ? true : false)
                        iconImage: "../pics/toolbar/zoom_icon&32.png"
                        iconText: qsTr("Search")
                        onClicked: {
                            if(searchDialog.state == "Shown") {
                                searchDialog.state = "hidden";
                            } else {
                                searchDialog.state = "Shown";
                            }
                        }
                        Behavior on visible {
                            ScriptAction {
                                script: menubar.state = "shown";
                            }
                        }
                    }

                    CustomToolbarIcon {
                        id: starIcon
                        visible: (window.width>window.height ? true : false)
                        iconImage: "../pics/toolbar/heart_icon&32.png"
                        iconText: qsTr("Favourites")
                        onClicked: Script.loadFavourites();
                    }

                    CustomToolbarIcon {
                        visible: (window.width>window.height ? true : false)
                        iconImage: "../pics/toolbar/refresh_icon&32.png"
                        iconText: qsTr("Refresh")
                        onClicked: {
                            container.flipped = false;
                            Script.autoFresh();
                        }
                    }

                    CustomToolbarIcon {
                        iconImage: "../pics/toolbar/align_just_icon&32.png"
                        iconText: qsTr("More")
                        onClicked: {
                            container.flipped = false;
                            if(mainMenu.state=="shown") {
                                mainMenu.state = "hidden";
                            } else {
                                mainMenu.state = "shown";
                                Script.loadRateLimit();
                            }
                        }
                    }
                }
            } // Toolbar
        } // Tweets container

        states: [
            State {
                name: "initialized"
                PropertyChanges {
                    target: container
                    y: container.height
                }
            },
            State {
                name: "hidden"
                PropertyChanges {
                    target: container
                    x: 0 - container.width
                }
                PropertyChanges {
                    target: container
                    y: 0
                }
                PropertyChanges {
                    target: detailsFlipable
                    x: 0
                }
            },
            State {
                name: "shown"
                PropertyChanges {
                    target: container
                    x: 0
                    y: 0
                }
                PropertyChanges {
                    target: detailsFlipable
                    x: container.width
                }
                //when: !detailsFlipable.flipped
            }
        ]
	
        transitions: Transition {
            SequentialAnimation {
                ScriptAction {
                    script: welcomePage.visible = false;
                }
                ParallelAnimation {
                    //NumberAnimation { target: welcomePage; property: "y"; duration: 400;  }
                    //NumberAnimation { target: containerRotation; property: "angle"; duration: 600;  }
                    //NumberAnimation { target: detailsShowRotation; property: "angle"; duration: 600;  }
                    NumberAnimation { target: container; property: "x"; duration: 600; easing.type: "InOutCubic" }
                    NumberAnimation { target: container; property: "y"; duration: 10; easing.type: "InOutCubic" }
                    NumberAnimation { target: detailsFlipable; property: "x"; duration: 600; easing.type: "InOutCubic" }
                }
            }
        }
    }

    CustomTheme {
        id: theme
    }

    Flipable {
        id: detailsFlipable
        width: parent.width
        height: parent.height
        property bool flipped: false
        x: parent.width
        front:
            Rectangle {
            anchors.fill: parent
            color: theme.detailBG // "#999"

            Flickable {
                //id: tweetDetailsContainer
                id: tweetDetailsFlickable
                anchors.fill: parent
                contentWidth: parent.width
                contentHeight: parent.height>detailsColumn.y + detailsColumn.height ? parent.height : detailsColumn.y + detailsColumn.height + 20
                //color: "#ddd"

                Rectangle {
                    id: tweetDetailsContainer
                    opacity: 1
                    color: theme.detailBG
                    width: parent.width
                    height: parent.height>detailsColumn.y + detailsColumn.height ? parent.height : detailsColumn.y + detailsColumn.height + 20
                    property string username: ""
                    property string tweetID: ""
                    property bool isFavourite: false
                    property bool isMine: false
                    property string replyID: ""
                    property string replyBlock: ""

                    Column {
                        id: detailsColumn
                        //anchors.fill: parent
                        y: 20
                        x: 10
                        width: parent.width - 20
                        /*height: backButton.y + backButton.height*/
                        spacing: 20

                        Row {
                            spacing: 20
                            width: parent.width
                            Image {
                                id: tweetProfileImage
                                source: ""
                                width: 72
                                height: 72
                                smooth: true
                            }

                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 102

                                Text {
                                    id: selectedTweetSource
                                    width: parent.width
                                    color: theme.dialogTextColor // "#ddd"
                                    text: "..."
                                    wrapMode: Text.WordWrap
                                    font.pixelSize: 18
                                }

                                Text {
                                    id: selectedTweetAge
                                    color: theme.dialogTextColor // "#ddd"
                                    text: qsTr("Moment ago")
                                    wrapMode: Text.WordWrap
                                    font.pixelSize: 18
                                }

                            }
                        }

                        Rectangle {
                            id: tweetTextContainer
                            radius: 5
                            width: parent.width
                            height: tweetTextAndPreview.height + 20
                            color: theme.dialogTextBG // "#eee"

                            Column {
                                id: tweetTextAndPreview
                                width: parent.width
                                spacing: 10
                                y: 10
                                anchors.horizontalCenter: parent.horizontalCenter

                                Text {
                                    id: selectedTweetText
                                    font.pixelSize: 22
                                    textFormat: Text.PlainText
                                    text: "..."
                                    color: theme.dialogInfoTextColor // "#333"
                                    wrapMode: Text.Wrap
                                    x: parent.x + 4
                                    width: parent.width - 8
                                }

                                Image {
                                    id: previewImage
                                    source: ""
                                    width: 200
                                    height: 200
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                            }
                        }

                        Rectangle {
                            id: replyTextContainer
                            radius: 5
                            width: parent.width
                            height: replyTextAndPreview.height + 20
                            color: theme.dialogTextBG
                            visible: false
                            property string replyText: "Loading..."

                            Column {
                                id: replyTextAndPreview
                                width: parent.width
                                spacing: 10
                                y: 10
                                anchors.horizontalCenter: parent.horizontalCenter

                                Text {
                                    id: replyTweetText
                                    font.pixelSize: 16
                                    //textFormat: Text..PlainText
                                    text: "<span><b>" + qsTr("In reply to") + " </b>" + replyTextContainer.replyText + "</span>"
                                    color: theme.dialogInfoTextColor // "#444"
                                    wrapMode: Text.Wrap
                                    x: parent.x + 4
                                    width: parent.width - 8
                                }
                            }
                        }

                        Rectangle {
                            id: hashtagsContainer
                            radius: 5
                            color: theme.dialogButtonAreaBG // "#999"
                            width: parent.width
                            height: hashtagActions.height+10

                            GridView {
                                id: hashtagActions
                                interactive: false
                                x: 10
                                y: 10
                                cellWidth: (parent.width-10)/2
                                cellHeight: 60
                                model: hashtagActionsModel
                                width: parent.width
                                height: 100
                                delegate: hashtagDelegate
                            }
                        }

                        Rectangle {
                            radius: 5
                            color: theme.dialogButtonAreaBG //"#999"
                            //y: tweetTextContainer.y + tweetTextContainer.height + 20
                            width: parent.width
                            height: tweetActions.height+10

                            Column {
                                id: tweetActions
                                x: 10
                                y: 10
                                //spacing: 2
                                width: parent.width - 10

                                Row {
                                    width: parent.width
                                    height: 60
                                    spacing: 10
                                    visible: (tweetDetailsContainer.replyID.length>0 || tweetDetailsContainer.isMine)
                                    Button {
                                        id: showOriginalButton
                                        visible: tweetDetailsContainer.replyID.length>0 ? true : false
                                        label: qsTr("Show original")
                                        height: 50
                                        width: parent.width/2-10
                                        onClicked: {
                                            Script.loadSingleTweet( tweetDetailsContainer.replyID );
                                        }
                                    }

                                    Button {
                                        id: deleteMyTweetButton
                                        visible: tweetDetailsContainer.isMine
                                        opacity: tweetDetailsContainer.replyID.length>0 ? 1 : 0
                                        label: qsTr("Delete")
                                        height: 50
                                        width: parent.width/2-10
                                        onClicked: {
                                            Script.destroy(tweetDetailsContainer.tweetID);
                                            container.state = "shown";
                                        }
                                    }
                                }

                                Row {
                                    width: parent.width
                                    height: 60
                                    spacing: 10
                                    Button {
                                        label: qsTr("Translate to english")
                                        height: 50
                                        width: parent.width-10
                                        onClicked: {
                                            console.log("Translating...");
                                            AzureTranslate.translate(selectedTweetText.text, selectedTweetText);
                                        }
                                    }

                                }
                            }
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
                            container.state = "shown";
                        }
                    }

                    CustomToolbarIcon {
                        iconImage: "../pics/toolbar/spechbubble_2_icon&32.png"
                        iconText: qsTr("Reply")
                        onClicked: {
                            container.state = "shown";
                            statusDialog.statusText = Script.parseUsernames( "@" + tweetDetailsContainer.username + " " + selectedTweetText.text);
                            statusDialog.replyName = "@" + tweetDetailsContainer.username;
                            statusDialog.replyID = tweetDetailsContainer.tweetID;
                            if(window.timelineIndex!=2) {
                                statusDialog.dmUserID = "";
                            } else {
                                statusDialog.dmUserID = tweetDetailsContainer.username;
                            }
                            statusDialog.state = "shown";
                        }
                    }

                    CustomToolbarIcon {
                        iconImage: "../pics/toolbar/refresh_icon&32.png"
                        iconText: qsTr("Retweet")
                        onClicked: {
                            retweetDialog.visible = true;
                        }
                    }

                    CustomToolbarIcon {
                        iconImage: "../pics/toolbar/star_fav_icon&32.png"
                        iconText: tweetDetailsContainer.isFavourite ? qsTr("Unfavourite") : qsTr("Favourite")
                        onClicked: {
                            if(tweetDetailsContainer.isFavourite) {
                                Script.unfavourite(tweetDetailsContainer.tweetID);
                            } else {
                                Script.favourite(tweetDetailsContainer.tweetID);
                            }
                            tweetDetailsContainer.isFavourite = false;
                        }
                    }

                    CustomToolbarIcon {
                        iconImage: "../pics/toolbar/user_icon&32.png"
                        iconText: qsTr("Profile")
                        onClicked: {
                            // Show profile dialog
                            profileDialog.userID = "";
                            profileDialog.profileImageURL = "";
                            profileDialog.username = "";
                            profileDialog.userURL = "";
                            profileDialog.userLocation = "";
                            profileDialog.followersCount = "0"
                            profileDialog.followingCount = "0"
                            profileDialog.tweetCount = "0"
                            detailsFlipable.flipped = true;
                            Script.fillProfile();
                        }
                    }
                }
            } // Custom toolbar
        }

        back:
            ProfileDialog {
            id: profileDialog
            //transform: Scale { origin.x: width/2; origin.y: height/2; xScale: -1}
            onGoBack: {
                detailsFlipable.flipped = false;
                //container.state = "shown";
            }
            onShowTweets: {
                detailsFlipable.flipped = false;
                container.state = "shown";
                Script.loadCurrentUserTweets();
            }
            onFollow: {
                Script.follow();
            }
            onUnfollow: {
                Script.unfollow();
            }
            onDirectTweet: {
                console.log("DM to " + userID + " and " + username);
                detailsFlipable.flipped = false;
                container.state = "shown";
                statusDialog.statusText = Script.parseUsernames( "@" + username + " ");
                statusDialog.replyID = "";
                statusDialog.dmUserID = userID;
                statusDialog.state = "shown";
            }
            onSendMsg: {
                console.log("msg to " + userID + " and " + username);
                detailsFlipable.flipped = false;
                container.state = "shown";
                statusDialog.statusText = Script.parseUsernames( "@" + username + " ");
                statusDialog.replyID = "";
                statusDialog.state = "shown";
            }
        }

        transform: [
            Rotation {
                id: detailsFlipableRotation
                origin.x: detailsFlipable.width/2
                origin.y: detailsFlipable.height/2
                axis.x: 1; axis.y: 0; axis.z: 0     // set axis.y to 1 to rotate around y-axis
                angle: 0    // the default angle
            }
        ]

        states: State {
            name: "back"
            PropertyChanges { target: detailsFlipableRotation; angle: 180 }
            when: detailsFlipable.flipped
        }

        transitions: Transition {
            ParallelAnimation {
                NumberAnimation { target: detailsFlipableRotation; property: "angle"; duration: 800; easing.type: "InOutCubic" }
                SequentialAnimation {
                    NumberAnimation { target: container; property: "scale"; to: 0.75; duration: 400 }
                    NumberAnimation { target: container; property: "scale"; to: 1.0; duration: 400 }
                }
            }
        }
    }

    RetweetDialog {
        id: retweetDialog
        visible: false
        onRetweetWithEdit: {
            container.state = "shown";
            var txt = "RT @" + tweetDetailsContainer.username + " " + selectedTweetText.text;
            console.log("Text: " + txt);
            statusDialog.statusText = txt;
            statusDialog.replyID = "";
            statusDialog.dmUserID = "";
            statusDialog.state = "shown";
        }
        onRetweetInstantly: {
            Script.instantretweet(tweetDetailsContainer.tweetID);
        }
    }

    MainMenu {
        id: mainMenu
        onClicked: {
            if(action=="Search") {
                searchDialog.state = "Shown";
            } else if(action=="MyTweets") {
                Script.loadUserTweets();
            } else if(action=="Friends") {
                Script.loadFriends();
            } else if(action=="Direct") {
                Script.loadDirectMessages();
            } else if(action=="Followers") {
                Script.loadFollowers();
            } else if(action=="Retweets") {
                Script.loadRetweets();
            } else if(action=="Favourites") {
                Script.loadFavourites();
            } else if(action=="Lists") {
                listsDialog.state = "Shown";
                Script.loadAndShowLists(listsDialog.listModel);
            } else if(action=="SavedSearches") {
                searchesDialog.state = "Shown";
                Script.loadSavedSearches(searchesDialog.searchesModel);
            } else if(action=="Settings") {
                settingsDialog.state = "Shown";
            } else if(action=="Trends") {
                trendsDialog.state = "Shown";
                Script.loadTrends(trendsDialog.trendsModel);
            } else if(action=="Logout") {
                //container.state = "hidden";
                container.visible = false;
                tweetsModel.clear();
                Script.showLogin();
            } else {
                console.log("Unknown action: " + action);
            }
        }
    }

    SettingsDialog {
        id: settingsDialog
        onClicked: {
            console.log("Saving settings...");
            var useList = "no";
            if(settingsDialog.useList===true) {
                useList = "yes";
            }

            var useSound = "no";
//            birdSound.muted = true;
            if(settingsDialog.useSound===true) {
                useSound = "yes";
//                birdSound.muted = false;
            }

            var useLightTheme = "no";
            if(settingsDialog.useLightTheme===true) {
                useLightTheme = "yes";
            }

            var refresh = settingsDialog.autoRefresh;
            try {
                if(refresh!="0") {
                    autoRefreshTimer.interval = parseInt(refresh) * 60 * 1000;
                    autoRefreshTimer.start();
                } else {
                    autoRefreshTimer.stop();
                }
            } catch(exp) {
                console.log("Error while starting auto refresh");
            }

            Storage.setKeyValue("pocketUsername", pocketUsername);
            Storage.setKeyValue("pocketPassword", pocketPassword);
            Storage.setKeyValue("useListView", useList);
            Storage.setKeyValue("useLightTheme", useLightTheme);
            Storage.setKeyValue("refresh", refresh);
            Storage.setKeyValue("useSound", useSound);
        }
    }

    Item {
        id: minimize
        height: 48
        width: 48

        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Minimizing");
                windowHelper.minimize();
            }
        }
    }

    LoginDialog {
        id: welcomePage
        onExit: {
            Qt.quit();
        }
    }

    Timer {
        id: loginTimer
        interval: 100
        repeat: false
        property string verifier: ""
        onTriggered: {
            console.log("LoginTimer triggered...");
            welcomePage.state = "hidden";
            authorizeWindow.visible = false;
            Script.login( verifier );
        }
    }

    AuthorizeDialog {
        id: authorizeWindow
        visible: false
        onFinished: {
            console.log("Finished with URL " + url);
            if(url.indexOf("/callback.php?")>0) {
//            if(url.indexOf("/authorize?")<0) {
                if(authorizeWindow.visible==true) {
                    console.log("Hiding authorize window...")
                    authorizeWindow.visible = false;
                    container.state = "shown";
                    container.visible = true;
                    loginTimer.verifier = parseParameter(url, "oauth_verifier");
                    loginTimer.start();
                }
            } else {
                authorizeWindow.visible = true;
            }

            console.log("Authorize window visible=" + authorizeWindow.visible);
        }

        /** Parse parameter from given URL */
        function parseParameter(url, parameter) {
            var parameterIndex = url.indexOf(parameter);
            if(parameterIndex<0) {
                // We didn't find parameter
                return "";
            }
            var equalIndex = url.indexOf("=", parameterIndex);
            if(equalIndex<0) {
                return "";
            }
            var value = "";
            var nextIndex = url.indexOf("&", equalIndex+1);
            if(nextIndex<0) {
                value = url.substring(equalIndex+1);
            } else {
                value = url.substring(equalIndex+1, nextIndex);
            }
            return value;
        }
    }

    Item { // Uncomment for MeeGo and Symbian
//    Rectangle { // Uncomment for Maemo
        id: waiting
        x: 0
        y: 0
        width: waitItems.width+20
        height: waitItems.height+20

        // Comment following
//        color: "#bbb" // Uncomment for Maemo
//        radius: 5 // Uncomment for Maemo
        smooth: true
        opacity: 0.9

        state: "hidden"

        BusyIndicator { // Uncomment for MeeGo and Symbian
            id: busyIndicator
            running: true
            x: window.width/2 - width/2
            y: window.height/2
            // These are for Symbian
            //width: 100
            //height: 100
            // This is for MeeGo
            platformStyle: BusyIndicatorStyle { size: "large"; inverted: theme.isBlack; }
        }

        Row {
            id: waitItems
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10
            // Hide if BusyIndicator is used (MeeGo and Symbian)
            visible: false

            Image {
                source: "pics/clock.png"
            }

            Text {
                id: waitingText
                text: qsTr("Please wait...")
                color: "#000"
                font.pixelSize: 22
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        states:
            State {
            name: "hidden"
            PropertyChanges {
                target: waiting
                y: 0 - waiting.height - 1
            }
        }
        State {
            name: "shown"
            PropertyChanges {
                target: waiting
                y: 10
            }
        }
	
        transitions: [
            Transition {
                SequentialAnimation {
                    ScriptAction { // Uncomment for MeeGo
                        script: {
                            busyIndicator.visible = true;
                        }
                    }
//                    PropertyAnimation { // Uncomment for Maemo
//                        target: waiting
//                        properties: "y"
//                        duration: 100
//                        easing.type: "InOutCubic"
//                    }
                }
            },
            Transition {
                to: "hidden"
                SequentialAnimation {
//                    PropertyAnimation { // Uncomment for Maemo
//                        target: waiting
//                        properties: "y"
//                        duration: 80
//                        easing.type: "InOutCubic"
//                    }
                    ScriptAction { // Uncomment for MeeGo
                        script: {
                            waitingText.text = "Please wait...";
                            busyIndicator.visible = false;
                        }
                    }
                }
            }
        ]
    }

    Rectangle {
        id: doneIndicator
        x: 10
        y: 10
        width: doneItems.width+30
        height: doneItems.height+20
        color: "#555"
        radius: 5
        opacity: 0.9
        smooth: true
        state: "hidden"

        Row {
            id: doneItems
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            Image {
                source: "pics/accepted_48.png"
            }

            Text {
                id: doneText
                text: qsTr("Done")
                color: "#eee"
                font.pixelSize: 22
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        states:
            State {
            name: "hidden"
            PropertyChanges {
                target: doneIndicator
                y: 0 - doneIndicator.height - 1
            }
        }
        State {
            name: "shown"
            PropertyChanges {
                target: doneIndicator
                y: 10
            }
        }
	
        transitions: [
            Transition {
                SequentialAnimation {
                    PropertyAnimation {
                        target: doneIndicator
                        properties: "y"
                        duration: 200
                        easing.type: "InOutCubic"
                    }
                    PropertyAnimation {
                        target: doneIndicator
                        properties: "y"
                        duration: 2000
                    }
                    ScriptAction {
                        script: {
                            doneIndicator.state = "hidden";
                        }
                    }
                }
            }
        ]
    }

    Rectangle {
        id: errorIndicator
        x: 10
        y: 10
        property string reason: ""
        width: window.width - 20
        height: errorItems.height+20
        color: "#555"
        radius: 5
        smooth: true
        state: "hidden"

        Row {
            id: errorItems
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10
            width: parent.width

            Image {
                id: errIcon
                source: "pics/error_48.png"
            }

            Column {
                width: parent.width - errIcon.width - 30
                spacing: 10

                Text {
                    id: errorText
                    text: qsTr("Oops... Something unexpected happened.")
                    color: "#eee"
                    wrapMode: Text.WordWrap
                    font.pixelSize: 18
                    width: parent.width
                }

                Text {
                    text: errorIndicator.reason
                    color: "#ccc"
                    wrapMode: Text.WordWrap
                    font.pixelSize: 18
                    width: parent.width
                }
            }
        }

        states:
            State {
            name: "hidden"
            PropertyChanges {
                target: errorIndicator
                y: 0 - errorIndicator.height - 1
            }
        }
        State {
            name: "shown"
            PropertyChanges {
                target: errorIndicator
                y: 10
            }
        }

        transitions: Transition {
            SequentialAnimation {
                ScriptAction {
                    script: {
                        waiting.state = "hidden";
                        doneIndicator.state = "hidden";
                    }
                }
                PropertyAnimation {
                    target: errorIndicator
                    properties: "y"
                    duration: 200
                    easing.type: "InOutCubic"
                }
                PropertyAnimation {
                    target: errorIndicator
                    properties: "y"
                    duration: 5000
                }
                ScriptAction {
                    script: {
                        errorIndicator.state = "hidden";
                    }
                }
            }
        }
    }
    Component {
        id: tweetsDelegate

        Item {
            //width: parent.width
            //height: tweeter.height + tweetTitle.height + tweetDateLabel.height + 16//window.tweetHeight // tweeter.height + tweetTitle.height + tweetDateLabel.height + 16 // tweetSummary.height + 12 // (tweetTitle.height<42 ? tweeter.height + 42 + 20 : tweeter.height + tweetTitle.height + 20)
            width: tweetsGrid.visible ? tweetsGrid.cellWidth : parent.width
            height: tweetsGrid.visible ? window.tweetHeight : tweeter.height + tweetTitle.height + 18 // tweetSummary.height + 12 // (tweetTitle.height<42 ? tweeter.height + 42 + 20 : tweeter.height + tweetTitle.height + 20)

            Rectangle {
                id: feedsBackground
                smooth: true
                gradient: !tweetMouseArea.pressed ? (isForMe ? isForMeColor : (isMine ? isMineColor : idleColor)) : pressedColor
                radius: 2
                x: tweetsGrid.visible ? 1 : 0
                y: 0
                width: parent.width - x*2
                height: parent.height - y*2 - 1

                Row {
                    id: tweetSummary
                    spacing: 8
                    x: 8
                    y: 8
                    width: parent.width

                    //Column {
                    //    width: 42
                    Item {
                        width: 42
                        height: 42
                        //x: parent.x
                        Image {
                            width: 42
                            height: 42
                            source: profileImageURL
                        }
                        Image {
                            width: 42
                            height: 42
                            visible: profileImageURL.length>0 && theme.isBlack
                            source: "pics/profile-round.png"
                        }
                    }
                    //}

                    Column {
                        id: tweetTexts
                        width: parent.width - 44
                        y: -4
                        spacing: 4

                        Text {
                            id: tweetTitle
                            color: theme.tweetTextColor
                            font.pixelSize: window.tweetFontSize
                            text: "<span>" + displayableStatus + "</span>"
                            wrapMode: Text.Wrap
                            width: feedsBackground.width - 58
                        }

                        Item {
                            width: feedsBackground.width - 64
                            //anchors.bottom: feedsBackground.bottom
                            //height: tweetsGrid.visible ? window.tweetHeight : tweeter.height
                            //x: -52
                            y: tweetsGrid.visible ? feedsBackground.height - tweeter.height - 8 : tweetTitle.y + tweetTitle.height + 2

                            Text {
                                id: tweeter
                                color: theme.tweetInfoTextColor // "#666"
                                opacity: 1
                                font.pixelSize: 16
                                font.bold: false
                                text: userName //+ replyBlock
                                wrapMode: Text.Wrap
                                width: parent.width
                                //x: (tweetTitle.height<42 && tweetsGrid.visible==false) ? 52 : 0
                                //x: 52
                                verticalAlignment: Text.AlignBottom
                            }

                            Text {
                                id: tweetDateLabel
                                color: theme.tweetInfoTextColor // "#666"
                                opacity: 1
                                font.pixelSize: 16
                                text: tweetDate
                                wrapMode: Text.Wrap
                                width: parent.width
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignBottom
                            }
                        }
                    }
                } // Row

                MouseArea {
                    id: tweetMouseArea
                    anchors.fill: parent
                    onClicked:  {
                        if(status.indexOf("Load more...")>=0) {
                            tweetTitle.text = qsTr("Please wait...") + "<br/><br/><br/><br/>";
                            Script.loadNextPage();
                        } else {
                            tweetDetailsContainer.replyBlock = replyBlock;
                            tweetDetailsContainer.replyID = replyID;
                            tweetDetailsContainer.username = userName;
                            tweetDetailsContainer.tweetID = tweetID;
                            if(userName == Script.currentScreenName) {
                                tweetDetailsContainer.isMine = true;
                            } else {
                                tweetDetailsContainer.isMine = false;
                            }

                            if(isFavourite!=null) {
                                tweetDetailsContainer.isFavourite = isFavourite;
                            } else {
                                tweetDetailsContainer.isFavourite = false;
                            }

                            replyTextContainer.replyText = qsTr("Loading...");
                            if(replyID.length>0) {
                                Script.loadReplyText(replyID, replyTextContainer.replyText);
                                replyTextContainer.visible = true;
                            } else {
                                replyTextContainer.visible = false;
                            }

                            var plainSource = Script.removeHTMLTags(source);

                            selectedTweetSource.text = "<span>" + userName + " " + qsTr("from") + " " + plainSource + replyBlock + "</span>";
                            selectedTweetText.text = status;
                            tweetProfileImage.source = profileImageURL;
                            selectedTweetAge.text = tweetDate;
                            previewImage.source = imagePreviewURL;
                            if(imagePreviewURL.length==0) {
                                previewImage.height = 0;
                            } else {
                                previewImage.height = 200;
                            }
                            tweetDetailsFlickable.contentY = 0;

                            hashtagActionsModel.clear();
                            var tagCount = Script.GetHashTags(status, hashtagActionsModel, tweetID);
                            hashtagActions.height = Math.ceil(tagCount/2) * 60;
                            if(tagCount==0) {
                                hashtagsContainer.opacity = 0
                            } else {
                                hashtagsContainer.opacity = 1
                            }
                            Script.setSelectedTweet(tweetID);
                            Script.setSelectedUser(userName);
                            container.state = "hidden"; //.flipped = !container.flipped
                        }
                    }
                }
            }

        }
    }	

    Component {
        id: hashtagDelegate

        Item {
            id: hashItem
            property string buttonLabel: ""
            width: hashtagActions.cellWidth - 10
            height: 50

            Component.onCompleted: {
                hashItem.buttonLabel = actionName;
                if(hashItem.buttonLabel.indexOf("/readitlaterlist.com/")>0) {
                    hashItem.buttonLabel = "Read it later...";

                }
                hashItem.buttonLabel = hashItem.buttonLabel.replace("http://", "");
                hashItem.buttonLabel = hashItem.buttonLabel.replace("https://", "");
                if(hashItem.buttonLabel.length>16) {
                    hashItem.buttonLabel = hashItem.buttonLabel.substring(0,16) + "..";
                }
            }

            Button {
                label: hashItem.buttonLabel
                //label: actionName.replace("http://", "").length>16 ? actionName.replace("http://", "").substring(0,16) + ".." : actionName.replace("http://", "")
                onClicked: {
                    if(actionName.indexOf("#")==0) {
                        Script.doSearch(actionName);
                    } else if(actionName.indexOf("@")==0){
                        detailsFlipable.flipped = true;
                        Script.setSelectedUser(actionName);
                        Script.fillProfile();
                    } else {
                        if(hashItem.buttonLabel.indexOf("Read it later...")>=0) {
                            if(settingsDialog.pocketUsername.length==0) {
                                settingsDialog.state = "shown";
                            } else {
                                Pocket.addLinkToPocket(actionName, settingsDialog.pocketUsername, settingsDialog.pocketPassword, tweetID);
                            }
                        } else {
                            Qt.openUrlExternally(actionName);
                        }
                        container.state = "shown";
                    }
                }
            }
        }
    }

    Gradient {
        id: pressedColor
        GradientStop { position: 0.0; color: "#333" }
        GradientStop { position: 0.1; color: "#222" }
        GradientStop { position: 0.3; color: "#333" }
        GradientStop { position: 1.0; color: "#444" }
    }

    Gradient {
        id: idleColor
        GradientStop { position: 0.0; color: theme.tweetTopColor }
        GradientStop { position: 0.2; color: theme.tweetMiddleColor }
        GradientStop { position: 1.0; color: theme.tweetBottomColor }
    }

    Gradient {
        id: isMineColor
        GradientStop { position: 0.0; color: theme.tweetTopColor }
        GradientStop { position: 0.3; color: theme.tweetMiddleColor }
        GradientStop { position: 0.8; color: theme.tweetMiddleColor }
        GradientStop { position: 1.0; color: theme.tweetBottomMineColor }
    }

    Gradient {
        id: isForMeColor
        GradientStop { position: 0.0; color: theme.tweetTopColor }
        GradientStop { position: 0.3; color: theme.tweetMiddleColor }
        GradientStop { position: 0.8; color: theme.tweetMiddleColor }
        GradientStop { position: 1.0; color: theme.tweetBottomForMeColor }
    }

}

} // Comment for Maemo
