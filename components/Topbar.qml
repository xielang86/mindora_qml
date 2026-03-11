import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: topbar       // 组件内部 id
    width: parent ? parent.width : 1080
    height: 90
    color: "transparent"
    opacity: 0.8

    Text {
        id: clockText
        anchors.centerIn: parent
        color: "white"
        font.pixelSize: 30
        text: Qt.formatDateTime(new Date(), "HH:mm")
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            clockText.text = Qt.formatDateTime(new Date(), "HH:mm")
        }
    }
}