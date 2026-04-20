import QtQuick
import QtQuick.Controls as QQC2
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    preferredRepresentation: fullRepresentation

    // ── Configurações ─────────────────────────────────────────────
    property int slotCount:   Math.max(1, Math.min(5, Plasmoid.configuration.slotCount))
    property int iconSize:    Plasmoid.configuration.iconSize
    property int idleOpacity: Plasmoid.configuration.idleOpacity

    property var iconPaths: [
        Plasmoid.configuration.iconPath0,
        Plasmoid.configuration.iconPath1,
        Plasmoid.configuration.iconPath2,
        Plasmoid.configuration.iconPath3,
        Plasmoid.configuration.iconPath4
    ]
    property var commands: [
        Plasmoid.configuration.command0,
        Plasmoid.configuration.command1,
        Plasmoid.configuration.command2,
        Plasmoid.configuration.command3,
        Plasmoid.configuration.command4
    ]
    property var labels: [
        Plasmoid.configuration.label0,
        Plasmoid.configuration.label1,
        Plasmoid.configuration.label2,
        Plasmoid.configuration.label3,
        Plasmoid.configuration.label4
    ]

    property bool hasAnyLabel: {
        for (var i = 0; i < slotCount; i++) {
            if ((labels[i] || "").toString() !== "") return true
        }
        return false
    }

    property int  topIndex:    0
    property bool animating:   false
    property int  visibleRows: Math.min(3, slotCount)

    // Focus is ALWAYS on the top row (r0 = topIndex)
    property int focusedDataIndex: topIndex

    // Dimensões base
    property real rowH:  iconSize * 1.6
    property real colW:  iconSize * 1.6
    property real lblW:  iconSize * 3.0
    property real lblGap: iconSize * 0.2

    implicitWidth:  colW + (hasAnyLabel ? lblGap + lblW : 0)
    implicitHeight: rowH * visibleRows

    function resolveSource(idx) {
        var v = (iconPaths[idx] || "").toString()
        if (v === "") return "system-run"
        if (v.startsWith("/"))       return "file://" + v
        if (v.startsWith("file://")) return v
        return v
    }

    function getLabel(idx) {
        return (labels[idx] || "").toString()
    }

    // ── Representação principal ───────────────────────────────────
    fullRepresentation: Item {
        id: container
        implicitWidth:  root.implicitWidth
        implicitHeight: root.implicitHeight

        opacity: wheelArea.containsMouse ? 1.0 : (root.idleOpacity / 100.0)
        Behavior on opacity {
            NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
        }

        // ── Coluna de ícones (clip próprio) ───────────────────────
        Item {
            id: iconClip
            x: 0; y: 0
            width:  root.colW
            height: root.rowH * root.visibleRows
            clip: true

            // r0 = TOP = always FOCUSED
            IconSlot { id: r0;     slotY: 0;             dataIdx: root.topIndex % root.slotCount;        focused: true }
            IconSlot { id: r1;     slotY: root.rowH;      dataIdx: (root.topIndex+1) % root.slotCount;   focused: false; slotOpacity: root.visibleRows >= 2 ? 1.0 : 0.0 }
            IconSlot { id: r2;     slotY: root.rowH * 2;  dataIdx: (root.topIndex+2) % root.slotCount;   focused: false; slotOpacity: root.visibleRows >= 3 ? 1.0 : 0.0 }
            IconSlot { id: rStage; slotY: root.rowH * 3;  dataIdx: 0;                                    focused: false; slotOpacity: 0.0 }
        }

        // ── Coluna de labels (clip próprio, separado) ─────────────
        Item {
            id: labelClip
            x: root.colW + root.lblGap
            y: 0
            width:  root.lblW
            height: root.rowH * root.visibleRows
            visible: root.hasAnyLabel
            clip: true

            LabelSlot { id: lb0;     slotY: 0;             dataIdx: r0.dataIdx;      focused: r0.focused;     animEn: true }
            LabelSlot { id: lb1;     slotY: root.rowH;      dataIdx: r1.dataIdx;      focused: r1.focused;     animEn: true; slotOpacity: r1.slotOpacity }
            LabelSlot { id: lb2;     slotY: root.rowH * 2;  dataIdx: r2.dataIdx;      focused: r2.focused;     animEn: true; slotOpacity: r2.slotOpacity }
            LabelSlot { id: lbStage; slotY: root.rowH * 3;  dataIdx: rStage.dataIdx; focused: rStage.focused; animEn: true; slotOpacity: 0.0 }
        }

        // ── Sync: aplica simultaneamente icon e label ─────────────
        // Chamado uma única vez por scroll — garante timing idêntico
        function applySlide(dir, newTop) {
            var rH = root.rowH

            if (dir > 0) {
                // Scroll baixo: r0 sai pelo topo, r1→r0 (ganha foco), r2→r1, rStage→r2
                setRow(r0,     lb0,     -rH,    0.0,  false)
                setRow(r1,     lb1,      0,     1.0,  true)   // r1 sobe para r0 = novo foco
                setRow(r2,     lb2,      rH,    1.0,  false)
                setRow(rStage, lbStage,  rH*2,  root.visibleRows >= 3 ? 1.0 : 0.0, false)
            } else {
                // Scroll cima: r2 sai pela base, r1→r2, r0→r1, rStage→r0 (ganha foco)
                setRow(r2,     lb2,      rH*3,  0.0,  false)
                setRow(r1,     lb1,      rH*2,  root.visibleRows >= 3 ? 1.0 : 0.0, false)
                setRow(r0,     lb0,      rH,    1.0,  false)
                setRow(rStage, lbStage,  0,     1.0,  true)   // rStage entra no topo = foco
            }

            root.topIndex = newTop
        }

        // Aplica posição + opacidade + foco ao par icon+label simultaneamente
        function setRow(iSlot, lSlot, y, opacity, focused) {
            iSlot.slotY      = y
            iSlot.slotOpacity = opacity
            iSlot.focused    = focused
            lSlot.slotY      = y        // mesmo y, mesmo instante
            lSlot.slotOpacity = opacity
            lSlot.focused    = focused
        }

        function advance(dir) {
            if (root.animating || root.slotCount <= 1) return
            root.animating = true

            var newTop = (root.topIndex + dir + root.slotCount) % root.slotCount

            // 1) Posiciona rStage sem animação (fora do clip)
            rStage.animEn  = false
            lbStage.animEn = false
            if (dir > 0) {
                rStage.dataIdx     = (root.topIndex + 3) % root.slotCount
                rStage.slotY       = root.rowH * 3
                rStage.slotOpacity = 0.0
                rStage.focused     = false
                lbStage.dataIdx    = rStage.dataIdx
                lbStage.slotY      = root.rowH * 3
                lbStage.slotOpacity = 0.0
                lbStage.focused    = false
            } else {
                rStage.dataIdx     = (root.topIndex - 1 + root.slotCount) % root.slotCount
                rStage.slotY       = -root.rowH
                rStage.slotOpacity = 0.0
                rStage.focused     = false
                lbStage.dataIdx    = rStage.dataIdx
                lbStage.slotY      = -root.rowH
                lbStage.slotOpacity = 0.0
                lbStage.focused    = false
            }

            // 2) Aguarda 1 frame para o reposicionamento ser pintado, depois anima
            slideTimer.dir    = dir
            slideTimer.newTop = newTop
            slideTimer.restart()
        }

        Timer {
            id: slideTimer
            interval: 20
            property int dir:    1
            property int newTop: 0
            onTriggered: {
                // Religa animações de rStage/lbStage antes do slide
                rStage.animEn  = true
                lbStage.animEn = true
                // Dispara o slide — icons e labels movem no mesmo instante
                container.applySlide(dir, newTop)
                resetTimer.restart()
            }
        }

        Timer {
            id: resetTimer
            interval: 340  // >= duração da animação (300ms)
            onTriggered: {
                var rH = root.rowH

                // Desliga animações para reposicionamento silencioso
                r0.animEn = false;     lb0.animEn = false
                r1.animEn = false;     lb1.animEn = false
                r2.animEn = false;     lb2.animEn = false
                rStage.animEn = false; lbStage.animEn = false

                // Redistribui dataIndex para o novo topIndex
                r0.dataIdx = root.topIndex % root.slotCount
                r1.dataIdx = (root.topIndex + 1) % root.slotCount
                r2.dataIdx = (root.topIndex + 2) % root.slotCount
                lb0.dataIdx = r0.dataIdx
                lb1.dataIdx = r1.dataIdx
                lb2.dataIdx = r2.dataIdx

                // Reposiciona tudo para posições canónicas
                container.setRow(r0,     lb0,     0,      1.0,                               true)
                container.setRow(r1,     lb1,     rH,     root.visibleRows >= 2 ? 1.0 : 0.0, false)
                container.setRow(r2,     lb2,     rH*2,   root.visibleRows >= 3 ? 1.0 : 0.0, false)
                container.setRow(rStage, lbStage, rH*3,   0.0,                               false)

                reEnableTimer.restart()
            }
        }

        Timer {
            id: reEnableTimer
            interval: 16
            onTriggered: {
                r0.animEn = true;     lb0.animEn = true
                r1.animEn = true;     lb1.animEn = true
                r2.animEn = true;     lb2.animEn = true
                rStage.animEn = true; lbStage.animEn = true
                root.animating = false
            }
        }

        MouseArea {
            id: wheelArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                var cmd = (root.commands[root.focusedDataIndex] || "").toString()
                if (cmd !== "") Qt.openUrlExternally(cmd)
            }
            onWheel: function(wheel) {
                container.advance(wheel.angleDelta.y < 0 ? 1 : -1)
                wheel.accepted = true
            }
        }

        QQC2.ToolTip {
            visible: wheelArea.containsMouse && (root.commands[root.focusedDataIndex] || "") !== ""
            text: (root.commands[root.focusedDataIndex] || "").toString()
            delay: 700
        }
    }

    // ── Componente: slot de ícone ─────────────────────────────────
    component IconSlot : Item {
        id: islot
        property int     dataIdx:     0
        property bool    focused:     false
        property real    slotY:       0
        property real    slotOpacity: 1.0
        property bool    animEn:      true

        width:  root.colW
        height: root.rowH
        y:       slotY
        opacity: slotOpacity

        Behavior on y       { enabled: islot.animEn; NumberAnimation { duration: 300; easing.type: Easing.InOutCubic } }
        Behavior on opacity { enabled: islot.animEn; NumberAnimation { duration: 250; easing.type: Easing.InOutQuad  } }

        Kirigami.Icon {
            anchors.centerIn: parent
            width:  root.iconSize
            height: root.iconSize
            source: root.resolveSource(islot.dataIdx)
            scale:   islot.focused ? 1.0 : 0.62
            opacity: islot.focused ? 1.0 : 0.28
            Behavior on scale   { enabled: islot.animEn; NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
            Behavior on opacity { enabled: islot.animEn; NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
        }
    }

    // ── Componente: slot de label ─────────────────────────────────
    component LabelSlot : Item {
        id: lslot
        property int     dataIdx:     0
        property bool    focused:     false
        property real    slotY:       0
        property real    slotOpacity: 1.0
        property bool    animEn:      true

        width:  root.lblW
        height: root.rowH
        y:       slotY
        opacity: 1.0  

        Behavior on y { enabled: lslot.animEn; NumberAnimation { duration: 300; easing.type: Easing.InOutCubic } }

        // Glow: 4 cópias deslocadas 1px
        Text { x:  1; anchors.verticalCenter: parent.verticalCenter; width: parent.width
               text: root.getLabel(lslot.dataIdx); font.pixelSize: Math.round(root.iconSize * 0.30)
               font.weight: Font.Medium; color: Kirigami.Theme.highlightColor
               opacity: lslot.focused ? 0.50 : 0.0; elide: Text.ElideRight
               Behavior on opacity { enabled: lslot.animEn; NumberAnimation { duration: 220 } } }
        Text { x: -1; anchors.verticalCenter: parent.verticalCenter; width: parent.width
               text: root.getLabel(lslot.dataIdx); font.pixelSize: Math.round(root.iconSize * 0.30)
               font.weight: Font.Medium; color: Kirigami.Theme.highlightColor
               opacity: lslot.focused ? 0.50 : 0.0; elide: Text.ElideRight
               Behavior on opacity { enabled: lslot.animEn; NumberAnimation { duration: 220 } } }
        Text { x: 0; anchors.verticalCenter: parent.verticalCenter; anchors.verticalCenterOffset:  1; width: parent.width
               text: root.getLabel(lslot.dataIdx); font.pixelSize: Math.round(root.iconSize * 0.30)
               font.weight: Font.Medium; color: Kirigami.Theme.highlightColor
               opacity: lslot.focused ? 0.50 : 0.0; elide: Text.ElideRight
               Behavior on opacity { enabled: lslot.animEn; NumberAnimation { duration: 220 } } }
        Text { x: 0; anchors.verticalCenter: parent.verticalCenter; anchors.verticalCenterOffset: -1; width: parent.width
               text: root.getLabel(lslot.dataIdx); font.pixelSize: Math.round(root.iconSize * 0.30)
               font.weight: Font.Medium; color: Kirigami.Theme.highlightColor
               opacity: lslot.focused ? 0.50 : 0.0; elide: Text.ElideRight
               Behavior on opacity { enabled: lslot.animEn; NumberAnimation { duration: 220 } } }

        // Texto principal
        Text {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            text: root.getLabel(lslot.dataIdx)
            font.pixelSize: Math.round(root.iconSize * 0.30)
            font.weight: Font.Medium
            color: "#ffffff"
            opacity: lslot.focused ? 0.92 : 0.20
            elide: Text.ElideRight
            Behavior on opacity { enabled: lslot.animEn; NumberAnimation { duration: 220 } }
        }
    }
}
