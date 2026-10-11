import QtQuick
import QtQuick.Controls
import DesignTokens as Tokens

// Runtime composition of the exported screens and modal prompts.
Rectangle {
    id: root
    required property var controller
    anchors.fill: parent
    color: Tokens.FlowZen.colors.color_canvas

    Loader {
        id: pageLoader
        anchors.fill: parent
        enabled: root.controller.state.prompt === ""
        sourceComponent: {
            switch (root.controller.state.page) {
            case "history": return historyPage
            case "details": return detailsPage
            case "settings": return settingsPage
            default: return root.controller.state.active ? sessionPage : readyPage
            }
        }
    }
    Component { id: readyPage; Focus_Ready { controller: root.controller } }
    Component { id: sessionPage; Focus_In_session { controller: root.controller } }
    Component { id: historyPage; History { controller: root.controller } }
    Component { id: detailsPage; History_Session_details { controller: root.controller } }
    Component { id: settingsPage; Settings { controller: root.controller } }

    Loader {
        id: promptLoader
        anchors.fill: parent
        focus: active
        active: root.controller.state.prompt !== ""
        sourceComponent: {
            switch (root.controller.state.prompt) {
            case "camera": return cameraPrompt
            case "end": return endPrompt
            case "distraction": return distractionPrompt
            default: return null
            }
        }
    }
    Component { id: cameraPrompt; Prompt_Camera_permission { controller: root.controller } }
    Component { id: endPrompt; Prompt_End_session { controller: root.controller } }
    Component { id: distractionPrompt; Prompt_Distraction_takeover { controller: root.controller } }

    Rectangle {
        id: errorBanner
        width: 912; height: 72
        visible: root.controller.state.error !== ""
        scale: Math.min((root.width - 208) / 992, root.height / 800)
        transformOrigin: Item.TopLeft
        x: 208 + (root.width - 208 - width * scale) / 2 + 40 * scale
        y: (root.height - height * scale) / 2 + 708 * scale
        radius: 12
        color: Tokens.FlowZen.colors.color_sage
        border.color: Tokens.FlowZen.colors.color_line
        Text {
            x: 16; y: 12; width: parent.width - 68; height: 48
            text: root.controller.state.error
            wrapMode: Text.Wrap
            color: Tokens.FlowZen.colors.color_ink
            font.family: "IBM Plex Sans"
            font.pixelSize: 13
        }
        ToolButton {
            anchors.right: parent.right
            text: "?"
            Accessible.name: "Dismiss message"
            onClicked: root.controller.clearError()
        }
    }
}
