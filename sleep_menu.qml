import QtQuick 2.15
import QtQuick.Controls 2.15
import data 1.0

Item {
    id: sleepMenu
    anchors.fill: parent

    property int currentPage: 0
    property real pageWidth: width
    signal buttonClicked(int pageIndex, int btnIndex)

    //按钮回调函数
    function handleButtonClick(page, btn) {       
        if (btn === 0) 
        {
            console.log("BackHome")
            // 🔹 调用父窗口函数加载 main_menu.qml
            // mainWin.loadPage("main_menu.qml")
            pageManager.loadPageDestroy("main_menu.qml")

        }
        else
        {
            if (page==0)
                console.log("Page0")
            else if (page==1)
                //加载scenario.qml
                // console.log("Page1")
                pageManager.loadPage("scenario_menu.qml")
            else if (page==2)
                console.log("Page2")
            else if (page==3)
                console.log("Page3")
            else if (page==4)
                console.log("Page4")
        }
    }

    function goToPage(index) {
        subFlick.contentX = index * pageWidth
        currentPage = index
    }

    function rotateRight() {
        var first = sleepMenuModel.get(0)
        sleepMenuModel.remove(0)
        sleepMenuModel.append(first)
    }

    function rotateLeft() {
        var lastIndex = sleepMenuModel.count - 1
        var last = sleepMenuModel.get(lastIndex)
        sleepMenuModel.remove(lastIndex)
        sleepMenuModel.insert(0, last)
    }

    property var sleepMenuData: Constants.sleepMenuData
    property var sleepMenuModel: ListModel {}

    Component.onCompleted: {
        sleepMenuModel.clear()
        for (var i = 0; i < sleepMenuData.length; i++) {
            sleepMenuModel.append(sleepMenuData[i])
        }
    }

    // =========================
    // 🎯 背景层（全部加载，避免黑屏）
    // =========================
    Item {
        anchors.fill: parent

        Repeater {
            model: sleepMenuModel.count
            delegate: Image {
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                cache: true
                source: sleepMenuModel.get(index).bg
                opacity: 1.0 - Math.min(Math.abs(subFlick.contentX / pageWidth - index), 1.0)
            }
        }
    }

    // =========================
    // 🎯 前景分页层（懒加载 ±1 页）
    // =========================
    Flickable {
        id: subFlick
        anchors.fill: parent
        contentWidth: pageWidth * sleepMenuModel.count
        boundsBehavior: Flickable.DragOverBounds
        maximumFlickVelocity: 0
        clip: true

        property int startPage: currentPage
        
        onMovementStarted: startPage = currentPage

        onMovementEnded: {
            // 拖动距离
            var delta = contentX - startPage * pageWidth
            var threshold = pageWidth / 8
            var target = startPage

            // 内部页间翻页逻辑
            if (delta > threshold && currentPage < sleepMenuModel.count - 1)
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
        }

        Row {
            width: subFlick.contentWidth
            height: parent.height

            Repeater {
                model: sleepMenuModel
                delegate: Item {
                    width: pageWidth
                    height: parent.height

                    // 页面标题
                    Text {
                        text: model.title
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: 382 - baselineOffset
                        font.family: FontManager.getFamily("PingFang SC", "Medium")
                        font.styleName: FontManager.getStyle("PingFang SC", "Medium")
                        font.pixelSize: 75
                        color: "white"
                    }

                    // 页面描述
                    Text {
                        width: 1080                  // 控制换行区域宽度
                        wrapMode: Text.Wrap          // 自动换行
                        text: model.describtion
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: 446 - baselineOffset
                        font.family: FontManager.getFamily("PingFang SC", "Medium")
                        font.styleName: FontManager.getStyle("PingFang SC", "Medium")
                        font.pixelSize: 30
                        color: "white"

                        // 自定义行距
                        lineHeight: 42               // 每行文字占 40 像素高度
                        lineHeightMode: Text.FixedHeight  // lineHeight 是固定像素
                        horizontalAlignment: Text.AlignHCenter   // ✅ 关键，文字在框里水平居中
                    }

                    // 按钮
                    Row {
                        spacing: 78
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: 582

                        Repeater {
                            model: btns.split(",")
                            delegate: Rectangle {
                                property int btnIndex: index
                                width: 274
                                height: 88
                                radius: 44
                                color: "white"
                                border.width: 0
                             
                                property bool isPressed: false
                                property bool isDragging: false
                                property real pressX: 0
                                property real pressY: 0

                                layer.enabled: true
                                layer.smooth: true   // 抗锯齿关键
                                antialiasing: true   // 抗锯齿关键
                                transformOrigin: Item.Center
                                scale: isPressed && !isDragging ? 1.1 : 1.0

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData
                                    font.family: FontManager.getFamily("PingFang SC", "Bold")
                                    font.styleName: FontManager.getStyle("PingFang SC", "Bold")
                                    font.pixelSize: 30
                                    color: "black"
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
                                        if (!parent.isDragging)
                                            handleButtonClick(currentPage, parent.btnIndex)
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

        NumberAnimation {
            id: snapAnim
            target: subFlick
            property: "contentX"
            duration: 250
            easing.type: Easing.OutCubic
        }
    }

    Row {
        id: pageIndicator
        z: 10
        spacing: 14

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 80

        Repeater {
            model: sleepMenuModel.count

            Rectangle {
                width: index === currentPage ? 24 : 10
                height: 10
                radius: 5

                color: "white"
                opacity: index === currentPage ? 1 : 0.35

                Behavior on width {
                    NumberAnimation { duration: 150 }
                }

                Behavior on opacity {
                    NumberAnimation { duration: 150 }
                }
            }
        }
    }
}