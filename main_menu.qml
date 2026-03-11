import QtQuick 2.15
import QtQuick.Controls 2.15
import data 1.0
import "components"

Item {
    id: main_menu
    anchors.fill: parent
    property real pageWidth: width
    property int currentPage: 0
    property int startPage: 0
    property var pageImages: Constants.pageImages

    //按钮回调函数
    function handleButtonClick(page, btn){       
        if (page === 0 && btn === 0) {
            pageManager.loadPageDestroy("sleep_menu.qml")
        }
    }

    // --------------------------
    // 屏保 Timer
    // --------------------------
    Timer {
        id: screensaverTimer
        interval: 10000   // 10 秒
        repeat: true
        running: true
        triggeredOnStart: false
        onTriggered: {
            console.log("No operation for 30s, go to screensaver")
            // 停止计时器，屏保期间不再触发
            screensaverTimer.stop()
            pageManager.loadPageDestroy("clockPage.qml") // 替换成你的屏保 QML
        }
    }


    // 🔹 滑动分页区域
    Flickable {
        id: flickArea
        anchors.fill: parent
        contentWidth: pageWidth * pageImages.length
        contentHeight: height
        boundsBehavior: Flickable.DragOverBounds  // 保留边界回弹动画
        maximumFlickVelocity: 0                  // 禁止惯性
        interactive: true
        clip: true

        Row {
            width: pageWidth * pageImages.length
            height: parent.height

            Repeater {
                model: pageImages.length
                Rectangle {
                    width: pageWidth
                    height: parent.height
                    property int pageIndex: index  // 保存页索引
                    color: "transparent"

                    Row {
                        spacing: 50
                        anchors.centerIn: parent

                        Repeater {
                            model: pageImages[pageIndex]

                            Rectangle {
                                width: 276
                                height: 446
                                color: "transparent"

                                property bool isPressed: false
                                property bool isDragging: false
                                property real pressX: 0
                                property real pressY: 0

                                layer.enabled: true
                                layer.smooth: true
                                transformOrigin: Item.Center
                                scale: isPressed && !isDragging ? 1.1 : 1.0

                                Image {
                                    anchors.fill: parent
                                    source: modelData
                                    fillMode: Image.PreserveAspectCrop
                                    asynchronous: true
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    acceptedButtons: Qt.LeftButton
                                    drag.target: null  // 禁止 MouseArea 拖动影响 Flickable

                                    onPressed: {
                                        screensaverTimer.restart()
                                        parent.isPressed = true
                                        parent.isDragging = false
                                        parent.pressX = mouse.x
                                        parent.pressY = mouse.y
                                    }

                                    onPositionChanged: {
                                        screensaverTimer.restart()
                                        var dx = mouse.x - parent.pressX
                                        var dy = mouse.y - parent.pressY
                                        if (Math.abs(dx) > 10 || Math.abs(dy) > 10)
                                            parent.isDragging = true
                                    }

                                    onReleased: {
                                        screensaverTimer.restart()
                                        if (!parent.isDragging)
                                        {
                                            var btnIndex = index
                                            openSleep(pageIndex, btnIndex)
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
            }
        }

        onMovementStarted: startPage = currentPage

        onMovementEnded: {
            // 拖动距离
            var delta = contentX - startPage * pageWidth
            var threshold = pageWidth / 8
            var target = startPage

            // 内部页间翻页逻辑
            if (delta > threshold && currentPage < pageImages.length - 1)
                target = startPage + 1
            else if (delta < -threshold && currentPage > 0)
                target = startPage - 1

            // 只有非边界页触发 snap 动画
            if (delta == 0)
            {
                // 让 Flickable 自己回弹
                console.log("auto bounce back at page", target)
            }
            else
            {
                snapAnim.stop()
                snapAnim.to = target * pageWidth
                snapAnim.start()
                currentPage = target
            }
            // 边界页让 Flickable 自己回弹
        }

        NumberAnimation {
            id: snapAnim
            target: flickArea
            property: "contentX"
            duration: 250
            easing.type: Easing.OutCubic
        }
    }

    // 🔹 页码指示器
    Row {
        id: pageIndicator
        spacing: 14
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 80

        Repeater {
            model: pageImages.length

            Rectangle {
                width: index === currentPage ? 24 : 10
                height: 10
                radius: 5
                color: "white"
                opacity: index === currentPage ? 1 : 0.35

                Behavior on width { NumberAnimation { duration: 150 } }
                Behavior on opacity { NumberAnimation { duration: 150 } }
            }
        }
    }

    // 🔹 信号：按钮点击
    signal openSleep(int pageIndex, int btnIndex)
    // 组件加载完成后连接
    Component.onCompleted: {
        openSleep.connect(function(page, btn) {
            handleButtonClick(page, btn)
        })
    }
}
