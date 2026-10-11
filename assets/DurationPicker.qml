import QtQuick
import QtQuick.Controls
import DesignTokens as Tokens

SpinBox {
    id: control
    from: 1
    to: 120
    height: 44
    editable: true
    font.family: "IBM Plex Sans"
    font.pixelSize: 14
    Accessible.name: "Duration in minutes"
    textFromValue: function(value) { return value + " min" }
    valueFromText: function(text) { return parseInt(text) || 1 }
    background: Rectangle {
        radius: 8
        color: Tokens.FlowZen.colors.color_canvas
        border.width: control.activeFocus ? 2 : 1
        border.color: Tokens.FlowZen.colors.color_line
    }
}
