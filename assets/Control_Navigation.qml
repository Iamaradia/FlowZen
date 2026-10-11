import QtQuick
import DesignTokens as Tokens

Rectangle {
    id: control_Navigation

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

    property alias navigationWidth: navigation.width
    property alias navigationX: navigation.x

    property string label: "Navigation"

    height: 44
    width: 176

    color: Tokens.FlowZen.colors.color_forest
    radius: Tokens.FlowZen.numbers.space_8

    Text {
        id: navigation

        x: 0
        y: 13

        height: 18
        width: parent.width

        color: Tokens.FlowZen.colors.color_nav
        font.family: "IBM Plex Sans"
        font.pixelSize: 14
        font.weight: Font.Medium
        horizontalAlignment: Text.AlignHCenter
        lineHeight: 17.50
        lineHeightMode: Text.FixedHeight
        text: control_Navigation.label
        verticalAlignment: Text.AlignTop
    }
}