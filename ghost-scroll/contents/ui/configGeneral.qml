import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: page

    property string cfg_iconPath0: ""
    property string cfg_iconPath1: ""
    property string cfg_iconPath2: ""
    property string cfg_iconPath3: ""
    property string cfg_iconPath4: ""

    property string cfg_command0: ""
    property string cfg_command1: ""
    property string cfg_command2: ""
    property string cfg_command3: ""
    property string cfg_command4: ""

    property string cfg_label0: ""
    property string cfg_label1: ""
    property string cfg_label2: ""
    property string cfg_label3: ""
    property string cfg_label4: ""

    property int cfg_slotCount:   3
    property int cfg_iconSize:    48
    property int cfg_idleOpacity: 8

    property int _iconTarget: 0
    property int _cmdTarget:  0

    FileDialog {
        id: iconDialog
        title: i18n("Escolher imagem para o ícone")
        nameFilters: [ "Imagens (*.png *.svg *.svgz *.jpg *.jpeg *.xpm *.ico)",
                       "Todos os ficheiros (*)" ]
        onAccepted: {
            var p = selectedFile.toString().replace(/^file:\/\//, "")
            if      (page._iconTarget === 0) { page.cfg_iconPath0 = p; f_icon0.text = p }
            else if (page._iconTarget === 1) { page.cfg_iconPath1 = p; f_icon1.text = p }
            else if (page._iconTarget === 2) { page.cfg_iconPath2 = p; f_icon2.text = p }
            else if (page._iconTarget === 3) { page.cfg_iconPath3 = p; f_icon3.text = p }
            else                             { page.cfg_iconPath4 = p; f_icon4.text = p }
        }
    }

    FileDialog {
        id: cmdDialog
        title: i18n("Escolher programa ou ficheiro")
        onAccepted: {
            var p = selectedFile.toString().replace(/^file:\/\//, "")
            if      (page._cmdTarget === 0) { page.cfg_command0 = p; f_cmd0.text = p }
            else if (page._cmdTarget === 1) { page.cfg_command1 = p; f_cmd1.text = p }
            else if (page._cmdTarget === 2) { page.cfg_command2 = p; f_cmd2.text = p }
            else if (page._cmdTarget === 3) { page.cfg_command3 = p; f_cmd3.text = p }
            else                            { page.cfg_command4 = p; f_cmd4.text = p }
        }
    }

    // ════════════════════════════════════════════════════════════════
    // COMPORTAMENTO
    // ════════════════════════════════════════════════════════════════
    Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18n("Comportamento")
    }

    RowLayout {
        Kirigami.FormData.label: i18n("Número de ícones:")
        QQC2.SpinBox {
            id: sb_slotCount
            from: 1; to: 5; stepSize: 1
            value: page.cfg_slotCount
            onValueChanged: page.cfg_slotCount = value
        }
        QQC2.Label { text: i18n("(1 a 5)") }
    }

    RowLayout {
        Kirigami.FormData.label: i18n("Tamanho dos ícones:")
        QQC2.SpinBox {
            id: sb_size
            from: 16; to: 256; stepSize: 8
            value: page.cfg_iconSize
            onValueChanged: page.cfg_iconSize = value
        }
        QQC2.Label { text: "px" }
    }

    RowLayout {
        Kirigami.FormData.label: i18n("Opacidade em repouso:")
        QQC2.Label { text: "0%" }
        QQC2.Slider {
            id: sl_opacity
            Layout.preferredWidth: Kirigami.Units.gridUnit * 10
            from: 0; to: 100; stepSize: 1
            value: page.cfg_idleOpacity
            onValueChanged: page.cfg_idleOpacity = value
        }
        QQC2.Label { text: "100%" }
        QQC2.Label {
            text: "(" + Math.round(sl_opacity.value) + "%)"
            color: Kirigami.Theme.disabledTextColor
        }
    }

    // ════════════════════════════════════════════════════════════════
    // ÍCONE 1
    // ════════════════════════════════════════════════════════════════
    Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18n("Ícone 1")
    }

    RowLayout {
        Kirigami.FormData.label: i18n("Imagem ou nome do tema:")
        QQC2.TextField {
            id: f_icon0
            Layout.preferredWidth: Kirigami.Units.gridUnit * 16
            placeholderText: "/home/user/icon.png   ou   system-run"
            text: page.cfg_iconPath0
            onTextChanged: page.cfg_iconPath0 = text
        }
        QQC2.Button {
            text: i18n("Procurar…"); icon.name: "document-open"
            onClicked: { page._iconTarget = 0; iconDialog.open() }
        }
        Rectangle {
            width: 32; height: 32; color: Kirigami.Theme.backgroundColor
            radius: 4; border.color: Kirigami.Theme.separatorColor; border.width: 1
            Image {
                anchors { fill: parent; margins: 4 }
                fillMode: Image.PreserveAspectFit; smooth: true
                source: f_icon0.text.startsWith("/") ? "file://" + f_icon0.text
                      : f_icon0.text.startsWith("file://") ? f_icon0.text
                      : f_icon0.text !== "" ? "image://icon/" + f_icon0.text
                      : "image://icon/system-run"
            }
        }
    }
    RowLayout {
        Kirigami.FormData.label: i18n("Display Name:")
        QQC2.TextField {
            id: f_lbl0
            Layout.preferredWidth: Kirigami.Units.gridUnit * 16
            placeholderText: i18n("ex: Ficheiros")
            text: page.cfg_label0
            onTextChanged: page.cfg_label0 = text
        }
    }
    RowLayout {
        Kirigami.FormData.label: i18n("Comando ou caminho:")
        QQC2.TextField {
            id: f_cmd0
            Layout.preferredWidth: Kirigami.Units.gridUnit * 16
            placeholderText: "dolphin   ou   /home/user/ficheiro.pdf"
            text: page.cfg_command0
            onTextChanged: page.cfg_command0 = text
        }
        QQC2.Button {
            text: i18n("Procurar…"); icon.name: "document-open"
            onClicked: { page._cmdTarget = 0; cmdDialog.open() }
        }
    }

    // ════════════════════════════════════════════════════════════════
    // ÍCONE 2
    // ════════════════════════════════════════════════════════════════
    Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18n("Ícone 2")
    }

    RowLayout {
        Kirigami.FormData.label: i18n("Imagem ou nome do tema:")
        QQC2.TextField {
            id: f_icon1
            Layout.preferredWidth: Kirigami.Units.gridUnit * 16
            placeholderText: "/home/user/icon.png   ou   system-run"
            text: page.cfg_iconPath1
            onTextChanged: page.cfg_iconPath1 = text
        }
        QQC2.Button {
            text: i18n("Procurar…"); icon.name: "document-open"
            onClicked: { page._iconTarget = 1; iconDialog.open() }
        }
        Rectangle {
            width: 32; height: 32; color: Kirigami.Theme.backgroundColor
            radius: 4; border.color: Kirigami.Theme.separatorColor; border.width: 1
            Image {
                anchors { fill: parent; margins: 4 }
                fillMode: Image.PreserveAspectFit; smooth: true
                source: f_icon1.text.startsWith("/") ? "file://" + f_icon1.text
                      : f_icon1.text.startsWith("file://") ? f_icon1.text
                      : f_icon1.text !== "" ? "image://icon/" + f_icon1.text
                      : "image://icon/system-run"
            }
        }
    }
    RowLayout {
        Kirigami.FormData.label: i18n("Display Name:")
        QQC2.TextField {
            id: f_lbl1
            Layout.preferredWidth: Kirigami.Units.gridUnit * 16
            placeholderText: i18n("ex: Música")
            text: page.cfg_label1
            onTextChanged: page.cfg_label1 = text
        }
    }
    RowLayout {
        Kirigami.FormData.label: i18n("Comando ou caminho:")
        QQC2.TextField {
            id: f_cmd1
            Layout.preferredWidth: Kirigami.Units.gridUnit * 16
            placeholderText: "dolphin   ou   /home/user/ficheiro.pdf"
            text: page.cfg_command1
            onTextChanged: page.cfg_command1 = text
        }
        QQC2.Button {
            text: i18n("Procurar…"); icon.name: "document-open"
            onClicked: { page._cmdTarget = 1; cmdDialog.open() }
        }
    }

    // ════════════════════════════════════════════════════════════════
    // ÍCONE 3
    // ════════════════════════════════════════════════════════════════
    Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18n("Ícone 3")
    }

    RowLayout {
        Kirigami.FormData.label: i18n("Imagem ou nome do tema:")
        QQC2.TextField {
            id: f_icon2
            Layout.preferredWidth: Kirigami.Units.gridUnit * 16
            placeholderText: "/home/user/icon.png   ou   system-run"
            text: page.cfg_iconPath2
            onTextChanged: page.cfg_iconPath2 = text
        }
        QQC2.Button {
            text: i18n("Procurar…"); icon.name: "document-open"
            onClicked: { page._iconTarget = 2; iconDialog.open() }
        }
        Rectangle {
            width: 32; height: 32; color: Kirigami.Theme.backgroundColor
            radius: 4; border.color: Kirigami.Theme.separatorColor; border.width: 1
            Image {
                anchors { fill: parent; margins: 4 }
                fillMode: Image.PreserveAspectFit; smooth: true
                source: f_icon2.text.startsWith("/") ? "file://" + f_icon2.text
                      : f_icon2.text.startsWith("file://") ? f_icon2.text
                      : f_icon2.text !== "" ? "image://icon/" + f_icon2.text
                      : "image://icon/system-run"
            }
        }
    }
    RowLayout {
        Kirigami.FormData.label: i18n("Display Name:")
        QQC2.TextField {
            id: f_lbl2
            Layout.preferredWidth: Kirigami.Units.gridUnit * 16
            placeholderText: i18n("ex: Terminal")
            text: page.cfg_label2
            onTextChanged: page.cfg_label2 = text
        }
    }
    RowLayout {
        Kirigami.FormData.label: i18n("Comando ou caminho:")
        QQC2.TextField {
            id: f_cmd2
            Layout.preferredWidth: Kirigami.Units.gridUnit * 16
            placeholderText: "dolphin   ou   /home/user/ficheiro.pdf"
            text: page.cfg_command2
            onTextChanged: page.cfg_command2 = text
        }
        QQC2.Button {
            text: i18n("Procurar…"); icon.name: "document-open"
            onClicked: { page._cmdTarget = 2; cmdDialog.open() }
        }
    }

    // ════════════════════════════════════════════════════════════════
    // ÍCONE 4
    // ════════════════════════════════════════════════════════════════
    Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18n("Ícone 4")
    }

    RowLayout {
        Kirigami.FormData.label: i18n("Imagem ou nome do tema:")
        QQC2.TextField {
            id: f_icon3
            Layout.preferredWidth: Kirigami.Units.gridUnit * 16
            placeholderText: "/home/user/icon.png   ou   system-run"
            text: page.cfg_iconPath3
            onTextChanged: page.cfg_iconPath3 = text
        }
        QQC2.Button {
            text: i18n("Procurar…"); icon.name: "document-open"
            onClicked: { page._iconTarget = 3; iconDialog.open() }
        }
        Rectangle {
            width: 32; height: 32; color: Kirigami.Theme.backgroundColor
            radius: 4; border.color: Kirigami.Theme.separatorColor; border.width: 1
            Image {
                anchors { fill: parent; margins: 4 }
                fillMode: Image.PreserveAspectFit; smooth: true
                source: f_icon3.text.startsWith("/") ? "file://" + f_icon3.text
                      : f_icon3.text.startsWith("file://") ? f_icon3.text
                      : f_icon3.text !== "" ? "image://icon/" + f_icon3.text
                      : "image://icon/system-run"
            }
        }
    }
    RowLayout {
        Kirigami.FormData.label: i18n("Display Name:")
        QQC2.TextField {
            id: f_lbl3
            Layout.preferredWidth: Kirigami.Units.gridUnit * 16
            placeholderText: i18n("ex: Editor")
            text: page.cfg_label3
            onTextChanged: page.cfg_label3 = text
        }
    }
    RowLayout {
        Kirigami.FormData.label: i18n("Comando ou caminho:")
        QQC2.TextField {
            id: f_cmd3
            Layout.preferredWidth: Kirigami.Units.gridUnit * 16
            placeholderText: "dolphin   ou   /home/user/ficheiro.pdf"
            text: page.cfg_command3
            onTextChanged: page.cfg_command3 = text
        }
        QQC2.Button {
            text: i18n("Procurar…"); icon.name: "document-open"
            onClicked: { page._cmdTarget = 3; cmdDialog.open() }
        }
    }

    // ════════════════════════════════════════════════════════════════
    // ÍCONE 5
    // ════════════════════════════════════════════════════════════════
    Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18n("Ícone 5")
    }

    RowLayout {
        Kirigami.FormData.label: i18n("Imagem ou nome do tema:")
        QQC2.TextField {
            id: f_icon4
            Layout.preferredWidth: Kirigami.Units.gridUnit * 16
            placeholderText: "/home/user/icon.png   ou   system-run"
            text: page.cfg_iconPath4
            onTextChanged: page.cfg_iconPath4 = text
        }
        QQC2.Button {
            text: i18n("Procurar…"); icon.name: "document-open"
            onClicked: { page._iconTarget = 4; iconDialog.open() }
        }
        Rectangle {
            width: 32; height: 32; color: Kirigami.Theme.backgroundColor
            radius: 4; border.color: Kirigami.Theme.separatorColor; border.width: 1
            Image {
                anchors { fill: parent; margins: 4 }
                fillMode: Image.PreserveAspectFit; smooth: true
                source: f_icon4.text.startsWith("/") ? "file://" + f_icon4.text
                      : f_icon4.text.startsWith("file://") ? f_icon4.text
                      : f_icon4.text !== "" ? "image://icon/" + f_icon4.text
                      : "image://icon/system-run"
            }
        }
    }
    RowLayout {
        Kirigami.FormData.label: i18n("Display Name:")
        QQC2.TextField {
            id: f_lbl4
            Layout.preferredWidth: Kirigami.Units.gridUnit * 16
            placeholderText: i18n("ex: Browser")
            text: page.cfg_label4
            onTextChanged: page.cfg_label4 = text
        }
    }
    RowLayout {
        Kirigami.FormData.label: i18n("Comando ou caminho:")
        QQC2.TextField {
            id: f_cmd4
            Layout.preferredWidth: Kirigami.Units.gridUnit * 16
            placeholderText: "dolphin   ou   /home/user/ficheiro.pdf"
            text: page.cfg_command4
            onTextChanged: page.cfg_command4 = text
        }
        QQC2.Button {
            text: i18n("Procurar…"); icon.name: "document-open"
            onClicked: { page._cmdTarget = 4; cmdDialog.open() }
        }
    }
}
