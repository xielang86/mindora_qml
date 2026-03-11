import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: clockPage
    width: 1080
    height: 1080

    function requestLoadMainMenu() {       
        pageManager.loadPageDestroy("main_menu.qml")
    }


    property var bgImages: [
        "resources/images/backScene/file_1.png",
        "resources/images/backScene/file_2.png",
        "resources/images/backScene/file_3.png",
        "resources/images/backScene/file_4.png",
        "resources/images/backScene/file_5.png",
        "resources/images/backScene/file_6.png",
        "resources/images/backScene/file_7.png",
        "resources/images/backScene/file_8.png",
        "resources/images/backScene/file_9.png",
        "resources/images/backScene/file_10.png",
        "resources/images/backScene/file_11.png",
        "resources/images/backScene/file_12.png",
        "resources/images/backScene/file_13.png",
        "resources/images/backScene/file_14.png",
        "resources/images/backScene/file_15.png",
        "resources/images/backScene/file_16.png",
        "resources/images/backScene/file_17.png",
        "resources/images/backScene/file_18.png",
        "resources/images/backScene/file_19.png",
        "resources/images/backScene/file_20.png"
    ]

    property int currentIndex: 0
    property int nextIndex: 1
    property int fadeDuration: 1000

    // 背景图片
    Image { id: bgOld; anchors.fill: parent; source: bgImages[currentIndex]; fillMode: Image.PreserveAspectCrop; opacity: 1 }
    Image { id: bgNew; anchors.fill: parent; source: bgImages[nextIndex]; fillMode: Image.PreserveAspectCrop; opacity: 0 }

    // 背景切换 Timer
    Timer {
        interval: 10000; running: true; repeat: true
        onTriggered: {
            bgNew.source = bgImages[nextIndex]
            bgNew.opacity = 0
            var anim = Qt.createQmlObject('import QtQuick 2.15; PropertyAnimation {}', clockPage)
            anim.target = bgNew; anim.property = "opacity"; anim.to = 1; anim.duration = fadeDuration; anim.easing.type = Easing.OutCubic
            anim.onStopped.connect(function() {
                currentIndex = nextIndex
                nextIndex = (nextIndex + 1) % bgImages.length
                bgOld.source = bgImages[currentIndex]; bgOld.opacity = 1; bgNew.opacity = 0
                anim.destroy()
            })
            anim.start()
        }
    }

    // 基线参考
    // property int baselineY: 540  // 这里是你希望时间基线的位置

    // 时间 Text
    Text { 
        id: timeText  
        font.family: FontManager.getFamily("PingFang SC", "Medium") 
        font.styleName: FontManager.getStyle("PingFang SC", "Medium") 
        font.pixelSize: 166 
        color: "white" 
        text: Qt.formatDateTime(new Date(), "hh:mm") 
        anchors.horizontalCenter: parent.horizontalCenter
        y: 904 - baselineOffset
    }

    // 日期 Text
    Text { 
        id: dateText 
        font.family: FontManager.getFamily("PingFang SC", "Medium") 
        font.styleName: FontManager.getStyle("PingFang SC", "Medium") 
        font.pixelSize: 35 
        color: "white" 
        text: Qt.formatDateTime(new Date(), "d MMM yyyy") 
        anchors.horizontalCenter: parent.horizontalCenter
        y: 960 - baselineOffset  // 50 是时间和日期的垂直间距
    }

    // 更新时间 Timer
    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: {
            var now = new Date()
            timeText.text = Qt.formatDateTime(now, "hh:mm")
            dateText.text = Qt.formatDateTime(now, "d MMM yyyy")
        }
    }

    // 捕获点击
    MouseArea {
        anchors.fill: parent
        onClicked: {
            requestLoadMainMenu() // 发出信号
        }
    }
}