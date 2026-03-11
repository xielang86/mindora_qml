import json
from PyQt5.QtGui import QFontDatabase
from PyQt5.QtCore import QObject, pyqtSlot, pyqtProperty

class Backend(QObject):
    def __init__(self):
        super().__init__()
        self.file = "data/config.json"
        self.load()

    def load(self):
        with open(self.file, "r") as f:
            self.data = json.load(f)

    def save(self):
        with open(self.file, "w") as f:
            json.dump(self.data, f, indent=4)

    # 读取多级路径
    @pyqtSlot('QVariantList', result='QVariant')
    def getValue(self, path):
        value = self.data
        for key in path:
            value = value[key]
        return value

    # 写入多级路径
    @pyqtSlot('QVariantList', 'QVariant')
    def setValue(self, path, value):
        obj = self.data

        for key in path[:-1]:
            obj = obj[key]

        obj[path[-1]] = value
        self.save()

class FontManager(QObject):
    def __init__(self, font_paths, parent=None):
        super().__init__(parent)
        self.font_db = QFontDatabase()
        self.registered_fonts = {}

        for path in font_paths:
            font_id = self.font_db.addApplicationFont(path)
            if font_id != -1:
                families = self.font_db.applicationFontFamilies(font_id)
                for family in families:
                    styles = self.font_db.styles(family)
                    for style in styles:
                        key = f"{family}_{style.replace(' ', '')}"
                        weight = self.font_db.weight(family, style)
                        self.registered_fonts[key] = {"family": family, "style": style, "weight": weight}
                        print(f"Registered: {key}, weight={weight}")

    @pyqtSlot(str, str, result=str)
    def getFamily(self, family, style):
        key = f"{family}_{style.replace(' ', '')}"
        return self.registered_fonts.get(key, {}).get("family", "")

    @pyqtSlot(str, str, result=str)
    def getStyle(self, family, style):
        key = f"{family}_{style.replace(' ', '')}"
        return self.registered_fonts.get(key, {}).get("style", "")