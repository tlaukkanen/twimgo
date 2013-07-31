import QtQuick 1.1
//import com.nokia.symbian 1.1
import com.nokia.meego 1.0      // MeeGo components

TextArea {
    id: textBox
    placeholderText: ""
    wrapMode: TextEdit.Wrap
    text: statusDialogItem.statusText
    textFormat: TextEdit.PlainText
    function getText(){
        return textBox.text;
    }
}

//Rectangle {
//    id: checkinShoutBox
//    width: parent.width
//    gradient: Gradient {
//        GradientStop { position: 0.0; color: "#ccc" }
//        GradientStop { position: 0.1; color: "#fafafa" }
//        GradientStop { position: 1.0; color: "#fff" }
//    }
//    radius: 5
//    border.width: 1
//    border.color: "#aaa"
//    smooth: true

//    function getText(){
//        return textBox.text;
//    }

//    TextEdit {
//        id: textBox
//        wrapMode: TextEdit.Wrap
//        text: statusDialogItem.statusText
//        textFormat: TextEdit.PlainText
//        width: parent.width - 10
//        height: parent.height - 10
//        x: 5
//        y: 5
//        color: "#111"
//        font.pixelSize: 20

//        MouseArea {
//            anchors.fill: parent
//            onClicked: {
//                if(textBox.text=="Search") {
//                    textBox.text = "";
//                    textBox.focus = true;
//                }
//                textBox.forceActiveFocus();
//                textBox.openSoftwareInputPanel();
//            }
//        }
//    }
//}
