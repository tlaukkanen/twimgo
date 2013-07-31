//import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: menubar
    y: parent.height - 80
    height: 80
    x: 0
    width: parent.width
    state: "shown"
    gradient: theme.isBlack ? toolbarDark : lightToolbarColor // idleColor

    Gradient {
        id: toolbarDark
        GradientStop { position: 0.0; color: "#505660" }
        GradientStop { position: 0.08; color: "#303640" }
        GradientStop { position: 0.5; color: "#444" }
        GradientStop { position: 0.51; color: "#1a1a1a" }
        GradientStop { position: 1.0; color: "#111" } // "#1a1a1a"
    }

    Gradient {
        id: lightToolbarColor
        GradientStop { position: 0.0; color: "#bbb" }
        GradientStop { position: 0.1; color: "#ccc" }
        GradientStop { position: 0.3; color: "#ccc" }
        GradientStop { position: 1.0; color: "#bbb" }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log("I'm not letting this click to leak underneath me...");
        }
    }

    Image {
        y: 0-height
        width:parent.width
        source:"../pics/bottom-shadow.png"
    }

    states: [
        State {
            name: "shown"
            PropertyChanges {
                target: menubar
                y: tweetsContainer.height - 80
            }
        },
        State {
            name: "hidden"
            PropertyChanges {
                target: menubar
                y: tweetsContainer.height
            }
        }
    ]

    transitions: Transition {
        SequentialAnimation {
            NumberAnimation { target: menubar; property: "y"; duration: 600; easing.type: "InOutCubic" }
        }
    }
}
