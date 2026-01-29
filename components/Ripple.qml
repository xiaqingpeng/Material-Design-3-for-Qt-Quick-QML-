import QtQuick
import md3

MouseArea {
    id: root
    
    property color rippleColor: Theme.color.onSurfaceColor
    property real rippleOpacity: 0.12
    property real clipRadius: 0
    property alias clipTopLeftRadius: maskRect.topLeftRadius
    property alias clipTopRightRadius: maskRect.topRightRadius
    property alias clipBottomLeftRadius: maskRect.bottomLeftRadius
    property alias clipBottomRightRadius: maskRect.bottomRightRadius
    
    hoverEnabled: true
    
    Rectangle {
        id: ripple
        property real targetSize: Math.max(root.width, root.height) * 2.5
        
        width: size
        height: size
        radius: size / 2
        color: root.rippleColor
        opacity: 0
        
        property real size: 0
        
        x: startX - width / 2
        y: startY - height / 2
        
        property real startX: 0
        property real startY: 0
    }
    
    ParallelAnimation {
        id: anim
        
        NumberAnimation {
            target: ripple
            property: "size"
            from: 0
            to: ripple.targetSize
            duration: 400
            easing.type: Easing.OutQuart
        }
        
        NumberAnimation {
            target: ripple
            property: "opacity"
            from: root.rippleOpacity
            to: 0
            duration: 400
            easing.type: Easing.InQuad
        }
    }
    
    PropertyAnimation {
        id: expandAnim
        target: ripple
        property: "size"
        to: ripple.targetSize
        duration: 450
        easing.type: Easing.OutQuart
    }
    
    NumberAnimation {
        id: fadeInAnim
        target: ripple
        property: "opacity"
        to: root.rippleOpacity
        duration: 200
    }
    
    NumberAnimation {
        id: fadeOutAnim
        target: ripple
        property: "opacity"
        to: 0
        duration: 300
    }

    onPressed: (mouse) => {
        expandAnim.stop()
        fadeOutAnim.stop()
        fadeInAnim.stop()
        
        ripple.startX = mouse.x
        ripple.startY = mouse.y
        ripple.size = 0
        ripple.opacity = 0
        
        fadeInAnim.start()
        expandAnim.start()
    }
    
    onReleased: fadeOutAnim.start()
    onCanceled: fadeOutAnim.start()
    onExited: if (!pressed) fadeOutAnim.start()
    
    Item {
        id: mask
        anchors.fill: parent
        visible: false
        
        Rectangle {
            id: maskRect
            anchors.fill: parent
            radius: root.clipRadius
            color: "black"
        }
    }
}
