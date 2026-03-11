import QtQuick 2.15

Item {

    id: manager
    anchors.fill: parent

    //--------------------------------
    // 当前页面
    //--------------------------------

    property Item currentPage: null


    //--------------------------------
    // 页面缓存
    //--------------------------------

    property var pageCache: ({})
    property var componentCache: ({})
    property var pageStack: []


    //--------------------------------
    // 切换状态
    //--------------------------------

    property bool switching: false
    property Item fadeOutPage: null
    property bool destroyAfterFade: false


    //--------------------------------
    // 加载页面（缓存）
    //--------------------------------

    function loadPage(qmlFile, pushStack=true) {

        var newPage = getPage(qmlFile)

        if (!newPage)
            return

        switchPage(newPage, false)

        if (pushStack)
            pageStack.push(qmlFile)
    }


    //--------------------------------
    // 加载页面（销毁旧页面）
    //--------------------------------

    function loadPageDestroy(qmlFile, pushStack=true) {

        var newPage = getPage(qmlFile)

        if (!newPage)
            return

        switchPage(newPage, true)

        if (pushStack)
            pageStack.push(qmlFile)
    }


    //--------------------------------
    // 获取页面
    //--------------------------------

    function getPage(qmlFile) {

        if (pageCache[qmlFile])
            return pageCache[qmlFile]

        var component

        if (componentCache[qmlFile]) {

            component = componentCache[qmlFile]

        } else {

            component = Qt.createComponent(Qt.resolvedUrl(qmlFile))

            if (component.status !== Component.Ready) {
                console.log(component.errorString())
                return null
            }

            componentCache[qmlFile] = component
        }

        var page = component.createObject(manager)

        if (!page) {
            console.log("页面创建失败")
            return null
        }

        page.anchors.fill = manager
        page.visible = false
        page.opacity = 0

        pageCache[qmlFile] = page

        return page
    }


    //--------------------------------
    // 页面切换
    //--------------------------------

    function switchPage(newPage, destroyOld=false) {

        if (switching)
            return

        switching = true

        var oldPage = currentPage

        currentPage = newPage

        newPage.visible = true
        newPage.opacity = 0


        //--------------------------------
        // 新页面淡入
        //--------------------------------

        fadeInAnim.stop()
        fadeInAnim.target = newPage
        fadeInAnim.start()


        //--------------------------------
        // 旧页面淡出
        //--------------------------------

        if (oldPage && oldPage !== newPage) {

            fadeOutPage = oldPage
            destroyAfterFade = destroyOld

            fadeOutAnim.stop()
            fadeOutAnim.target = oldPage
            fadeOutAnim.start()
        }
    }


    //--------------------------------
    // 返回上一页
    //--------------------------------

    function goBack() {

        if (pageStack.length <= 1)
            return

        pageStack.pop()

        var lastPage = pageStack[pageStack.length - 1]

        loadPage(lastPage, false)
    }


    //--------------------------------
    // 淡入动画
    //--------------------------------

    NumberAnimation {

        id: fadeInAnim

        property: "opacity"
        to: 1
        duration: 250
        easing.type: Easing.OutCubic

        onStopped: {
            switching = false
        }
    }


    //--------------------------------
    // 淡出动画
    //--------------------------------

    NumberAnimation {

        id: fadeOutAnim

        property: "opacity"
        to: 0
        duration: 180

        onStopped: {

            if (!fadeOutPage)
                return

            if (currentPage !== fadeOutPage) {

                if (destroyAfterFade) {

                    for (var key in pageCache) {
                        if (pageCache[key] === fadeOutPage) {
                            delete pageCache[key]
                            break
                        }
                    }

                    fadeOutPage.destroy()

                } else {

                    fadeOutPage.visible = false

                }
            }

            fadeOutPage = null
        }
    }

}