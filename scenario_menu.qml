import QtQuick 2.15
import QtQuick.Controls 2.15
import data 1.0

Item {
    id: scenario_menu
    width: parent.width
    height: parent.height
    property var scenarioMenuData: Constants.scenarioMenuData

    // 返回的目标页序号，可自定义
    property int targetSleepPage: 1

    // 按钮回调函数
    function handleButtonClick(btn) {       
        console.log("btn clicked", btn)
    }

    function slideOutAndGoBack(pageIndex) {
        var container = mainWin.pageContainer
        var targetPage = pageIndex  // 你希望回到的页序号

        // Flickable 下滑隐藏
        var slideOut = Qt.createQmlObject(
            'import QtQuick 2.15; NumberAnimation { property: "flickY"; to: parent.height; duration: 400; easing.type: Easing.InCubic }',
            buttonColumn
        )
        slideOut.target = buttonColumn

        slideOut.onStopped.connect(function() {
            pageManager.loadPageDestroy("sleep_menu.qml")
    
        })

        slideOut.start()
    }

    // // 点击返回时触发下滑
    // function slideOutAndGoBack() {
    //     slideOutAnim.to = scenario_menu.height
    //     slideOutAnim.start()
    // }

    // NumberAnimation {
    //     id: slideOutAnim
    //     target: scenario_menu
    //     property: "y"
    //     duration: 400
    //     easing.type: Easing.InCubic
    //     onStopped: {
    //         pageManager.loadPageDestroy("sleep_menu.qml")
    //     }
    // }

    // =========================
    // Flickable 主内容
    // =========================
    Flickable {
        id: flickArea
        anchors.fill: parent
        anchors.topMargin: 160
        contentHeight: buttonColumn.height + 180
        boundsBehavior: Flickable.DragOverBounds
        clip: true
        maximumFlickVelocity: 2500
        interactive: true

        Column {
            id: buttonColumn
            width: parent.width
            spacing: 28
            anchors.horizontalCenter: parent.horizontalCenter
            y: flickY
            property real flickY: parent.height  // 从屏幕下方开始滑入

            Repeater {
                model: scenarioMenuData.length
                Rectangle {
                    id: buttonContainer
                    width: 644
                    height: 174
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "transparent"

                    property bool isPressed: false
                    property bool isDragging: false
                    property real pressX: 0
                    property real pressY: 0

                    layer.enabled: true
                    layer.smooth: true   // 抗锯齿关键
                    antialiasing: true   // 抗锯齿关键
                    transformOrigin: Item.Center
                    scale: isPressed && !isDragging ? 1.1 : 1.0

                    Image {
                        anchors.fill: parent
                        source: scenarioMenuData[index].icon
                        fillMode: Image.PreserveAspectFit
                        smooth: true        // 开启平滑采样（抗锯齿）
                        mipmap: true        // GPU多级纹理，缩放更平滑
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton

                        onPressed: {
                            parent.isPressed = true
                            parent.isDragging = false
                            parent.pressX = mouse.x
                            parent.pressY = mouse.y
                        }

                        onPositionChanged: {
                            var dx = mouse.x - parent.pressX
                            var dy = mouse.y - parent.pressY
                            if (Math.abs(dx) > 10 || Math.abs(dy) > 10)
                                parent.isDragging = true
                        }

                        onReleased: {
                            if (!parent.isDragging) {
                                var btnIndex = index
                                handleButtonClick(btnIndex)
                            }
                            parent.isPressed = false
                            parent.isDragging = false
                        }

                        onCanceled: {
                            parent.isPressed = false
                            parent.isDragging = false
                        }
                    }

                    Behavior on scale {
                        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                    }
                }
            }
        }
    }

    // =========================
    // 返回按钮
    // =========================
    Rectangle {
        id: backBtn
        width: 70
        height: 70
        x: 78
        anchors.verticalCenter: parent.verticalCenter
        color: "transparent"

        property bool isPressed: false
        property bool isDragging: false
        property real pressX: 0
        property real pressY: 0

        layer.enabled: true
        layer.smooth: true   // 抗锯齿关键
        antialiasing: true   // 抗锯齿关键
        transformOrigin: Item.Center
        scale: isPressed && !isDragging ? 1.1 : 1.0

        Image {
            anchors.fill: parent
            source: "resources/images/returnArrowBTN.png"
            fillMode: Image.PreserveAspectFit
            smooth: true        // 开启平滑采样（抗锯齿）
            mipmap: true        // GPU多级纹理，缩放更平滑

        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            onPressed: {
                parent.isPressed = true
                parent.isDragging = false
                parent.pressX = mouse.x
                parent.pressY = mouse.y
            }

            onPositionChanged: {
                var dx = mouse.x - parent.pressX
                var dy = mouse.y - parent.pressY
                if (Math.abs(dx) > 10 || Math.abs(dy) > 10)
                    parent.isDragging = true
            }

            onReleased: {
                if (!parent.isDragging) {
                    slideOutAndGoBack(1)
                }
                parent.isPressed = false
                parent.isDragging = false
            }

            onCanceled: {
                parent.isPressed = false
                parent.isDragging = false
            }
        }

        Behavior on scale {
            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
        }
    }

    // =========================
    // Slide-in 动画
    // =========================
    function slideIn() {
        var anim = Qt.createQmlObject(
            'import QtQuick 2.15; NumberAnimation { property: "flickY"; to: 20; duration: 1000; easing.type: Easing.OutCubic }',
            buttonColumn
        )
        anim.target = buttonColumn
        anim.start()
    }

    Component.onCompleted: slideIn()

    signal buttonClicked(int btnIndex)
}