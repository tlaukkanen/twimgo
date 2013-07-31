import QtQuick 1.1
import QtWebKit 1.0
import "../js/script.js" as Script

Rectangle {
    id: loginDialog
    signal finished(string url)
    signal loadFailed()
    property string token: ""
    anchors.fill: parent
    color: "#fff"

    function load(token) {
        webView.url = "https://api.twitter.com/oauth/authorize?oauth_token=" + token;
        //webView.re
        //webView.reload();
    }

    Flickable {
        width: parent.width
        height: parent.height
        contentWidth: webView.contentsSize.width
        contentHeight: Math.max(webView.contentsSize.height, 800)
        pressDelay: 200

        WebView {
            id: webView
            anchors.fill: parent
            //anchors.centerIn: parent
            //width: parent.width
            //height: parent.height
            preferredHeight: parent.height
            preferredWidth: parent.width // parent.width //Math.max(parent.width,640)
            url: ""

            onLoadStarted: {
                loadingIndicator.visible = true;
            }

            onLoadFinished: {
                loadingIndicator.visible = false;
                console.log("URL is now " + webView.url);
                loginDialog.finished( webView.url );
            }

            onLoadFailed: {
                loadingIndicator.visible = false;
                loginDialog.loadFailed();
            }

        }
    }

    Rectangle {
        id: loadingIndicator
        width: 200
        height: 40
        anchors.centerIn: parent
        color: "#333"
        visible: false

        Text {
            text: qsTr("Loading")
            anchors.centerIn: parent
            font.pixelSize: 20
            color: "#fff"
        }
    }

}
