import QtQuick 1.1
//import com.nokia.symbian 1.1
import com.nokia.meego 1.0

TextField {
    id: textBox
    property bool isPassword: false
    placeholderText: qsTr("Search")
    text: searchDialogItem.searchText
    echoMode: textBox.isPassword ? TextInput.PasswordEchoOnEdit : TextInput.Normal
    function getText(){
        return textBox.text
    }
    function setText(text){
        textBox.text = text;
    }
}

//Rectangle {
//    id: checkinShoutBox
//    property bool isPassword: false
//    property string placeholderText: ""
//    width: parent.width
//    height: 40
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
//        return textBox.text
//    }

//    function setText(text){
//        textBox.text = text;
//    }

//    TextInput {
//        id: textBox
//        //wrapMode: TextEdit.Wrap
//        text: searchDialogItem.searchText
//        //textFormat: TextEdit.PlainText
//        width: parent.width - 10
//        height: parent.height - 10
//        x: 5
//        y: 5
//        color: "#111"
//        font.pixelSize: 20
//        echoMode: checkinShoutBox.isPassword ? TextInput.PasswordEchoOnEdit : TextInput.Normal

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
