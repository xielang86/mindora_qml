import sys
from PyQt5.QtGui import QGuiApplication, QFontDatabase
from PyQt5.QtQml import QQmlApplicationEngine
from misc import *
import json

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.addImportPath("/home/linaro/Desktop/qml_demo")
    with open("resources.json") as f:
        rsc = json.load(f)
    engine.rootContext().setContextProperty("rsc", rsc)
    with open("data/config.json") as f:
        config = json.load(f)
    engine.rootContext().setContextProperty("config", config)
    backend = Backend()
    engine.rootContext().setContextProperty("backend", backend)

    font_manager = FontManager(rsc["font_paths"])
    engine.rootContext().setContextProperty("FontManager", font_manager)

    engine.load("main_window.qml")

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())