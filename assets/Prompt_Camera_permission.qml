import QtQuick
import QtQuick.Controls
import DesignTokens as Tokens

Rectangle {
    id: prompt_Camera_permission

    required property var controller
    objectName: "Prompt_Camera_permission"
    height: 800
    width: 1200
    anchors.centerIn: parent
    scale: Math.min(parent.width / 1200, parent.height / 800)

    clip: true
    color: "transparent"



    Rectangle {
        id: overlay

        MouseArea { anchors.fill: parent }
        height: 800
        width: 1200

        color: Tokens.FlowZen.colors.color_ink
        opacity: 0.72
    }
    Rectangle {
        id: camera_permission_dialog

        x: 476
        y: 252

        height: 296
        width: 456

        clip: true
        color: Tokens.FlowZen.colors.color_sage
        radius: 24

        Text {
            id: cAMERA_1

            x: 32
            y: 32

            height: 15
            width: 55

            color: Tokens.FlowZen.colors.color_surface
            font.family: "IBM Plex Sans"
            font.letterSpacing: 0.96
            font.pixelSize: 12
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignLeft
            lineHeight: 15
            lineHeightMode: Text.FixedHeight
            text: qsTr("CAMERA")
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
        }
        Text {
            id: camera_access_needed

            x: 32
            y: 65

            height: 25
            width: 212

            color: Tokens.FlowZen.colors.color_ink
            font.family: "IBM Plex Sans"
            font.pixelSize: 20
            font.weight: Font.Medium
            horizontalAlignment: Text.AlignLeft
            lineHeight: 25
            lineHeightMode: Text.FixedHeight
            text: qsTr("Camera access needed")
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
        }
        Text {
            id: flowZen_uses_the_camera_only_to_check_whether_yo

            x: 32
            y: 108

            height: 36
            width: 393

            color: Tokens.FlowZen.colors.color_ink
            font.family: "IBM Plex Sans"
            font.pixelSize: 14
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignLeft
            lineHeight: 17.50
            lineHeightMode: Text.FixedHeight
            text: qsTr("FlowZen uses the camera only to check whether you are present during a focus session.")
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
        }
        Rectangle {
            id: info

            x: 32
            y: 162

            height: 40
            width: 392

            clip: true
            color: Tokens.FlowZen.colors.color_canvas
            radius: 10

            Text {
                id: the_preview_and_tracking_stay_on_this_device_

                x: 14
                y: 12.50

                height: 15
                width: 241

                color: Tokens.FlowZen.colors.color_surface
                font.family: "IBM Plex Sans"
                font.pixelSize: 12
                font.weight: Font.Normal
                horizontalAlignment: Text.AlignLeft
                lineHeight: 15
                lineHeightMode: Text.FixedHeight
                text: qsTr("The preview and tracking stay on this device.")
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
            }
        }
        Rectangle {
            id: actions

            x: 32
            y: 220

            height: 44
            width: 392

            clip: true
            color: "transparent"

            Rectangle {
                id: button_Not_now

                activeFocusOnTab: true
                Accessible.role: Accessible.Button
                Keys.onReturnPressed: { controller.cancelCamera() }
                Keys.onSpacePressed: { controller.cancelCamera() }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: { controller.cancelCamera() }
                }
                height: 44
                width: 184

                border.color: Tokens.FlowZen.colors.color_line
                border.width: 1
                clip: true
                color: Tokens.FlowZen.colors.color_canvas
                radius: 12

                Text {
                    id: not_now

                    x: 65
                    y: 13

                    height: 18
                    width: 55

                    color: Tokens.FlowZen.colors.color_ink
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 17.50
                    lineHeightMode: Text.FixedHeight
                    text: qsTr("Not now")
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
            Rectangle {
                id: button_Allow_camera

                enabled: !controller.state.cameraStarting
                opacity: enabled ? 1 : 0.5
                activeFocusOnTab: true
                Accessible.role: Accessible.Button
                Keys.onReturnPressed: { controller.allowCamera() }
                Keys.onSpacePressed: { controller.allowCamera() }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: { controller.allowCamera() }
                }
                x: 196

                height: 44
                width: 196

                clip: true
                color: Tokens.FlowZen.colors.color_ink
                radius: 12

                Text {
                    id: allow_camera

                    x: 54
                    y: 13

                    height: 18
                    width: 89

                    color: Tokens.FlowZen.colors.color_sage
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 17.50
                    lineHeightMode: Text.FixedHeight
                    text: controller.state.cameraStarting ? "Opening..." : "Allow camera"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
        }
    }
}