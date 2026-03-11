import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import "components"

ApplicationWindow {

    id: mainWin
    width: 1080
    height: 1080
    visible: true
    color: "black"

    Topbar {
        id: topBar
        anchors.top: parent.top
        z: 999
    }

    PageManager {
        id: pageManager
        anchors.fill: parent
    }

    Component.onCompleted: {

        pageManager.loadPage("main_menu.qml")

    }
}