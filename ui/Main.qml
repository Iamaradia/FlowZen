import QtQuick
import QtQuick.Controls
import "../assets" as Assets

ApplicationWindow {
    id: window
    objectName: "flowZenWindow"
    required property var controller
    property bool allowClose: false
    visible: true
    title: "FlowZen"
    width: 1200
    height: 800
    minimumWidth: 900
    minimumHeight: 600
    color: "#051f20"
    palette.button: "#f3faf4"
    palette.buttonText: "#051f20"
    palette.text: "#051f20"
    palette.highlight: "#235347"
    palette.highlightedText: "#daf1de"

    onClosing: function(close) {
        close.accepted = allowClose || controller.requestClose()
    }

    Connections {
        target: window.controller
        function onQuitRequested() {
            window.allowClose = true
            window.close()
        }
    }

    Assets.Focus_Export_with_prompts {
        controller: window.controller
        anchors.fill: parent
    }
}
