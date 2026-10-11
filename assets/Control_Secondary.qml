import QtQuick
import DesignTokens as Tokens

Rectangle {
    id: control_Secondary

    signal clicked()
    activeFocusOnTab: true
    opacity: enabled ? 1 : 0.5
    Accessible.role: Accessible.Button
    Accessible.name: label
    Keys.onReturnPressed: clicked()
    Keys.onSpacePressed: clicked()
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: { parent.forceActiveFocus(); parent.clicked() }
    }
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        radius: parent.radius
        border.width: parent.activeFocus ? 2 : 0
        border.color: Tokens.FlowZen.colors.color_line
    }

    property alias secondaryWidth: secondary.width
    property alias secondaryX: secondary.x

    property string label: "Secondary"

    height: 44
    width: 176

    color: Tokens.FlowZen.colors.color_sage
    radius: Tokens.FlowZen.numbers.space_8

    Text {
        id: secondary

        x: 0
        y: 13

        height: 18
        width: parent.width

        color: Tokens.FlowZen.colors.color_ink
        font.family: "IBM Plex Sans"
        font.pixelSize: 14
        font.weight: Font.Medium
        horizontalAlignment: Text.AlignHCenter
        lineHeight: 17.50
        lineHeightMode: Text.FixedHeight
        text: control_Secondary.label
        verticalAlignment: Text.AlignTop
    }
}