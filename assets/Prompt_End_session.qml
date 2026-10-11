import QtQuick
import QtQuick.Controls
import DesignTokens as Tokens

Rectangle {
    id: prompt_End_session

    required property var controller
    objectName: "Prompt_End_session"
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
        id: end_session_dialog

        Control_Secondary {
            x: 136; y: 220; width: 184
            label: "Discard session"
            onClicked: controller.discardSession()
        }
        x: 476
        y: 259

        height: 282
        width: 456

        clip: true
        color: Tokens.FlowZen.colors.color_sage
        radius: 24

        Text {
            id: fOCUS_SESSION_1

            x: 32
            y: 32

            height: 15
            width: 104

            color: Tokens.FlowZen.colors.color_surface
            font.family: "IBM Plex Sans"
            font.letterSpacing: 0.96
            font.pixelSize: 12
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignLeft
            lineHeight: 15
            lineHeightMode: Text.FixedHeight
            text: qsTr("FOCUS SESSION")
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
        }
        Text {
            id: end_this_session_

            x: 32
            y: 65

            height: 25
            width: 159

            color: Tokens.FlowZen.colors.color_ink
            font.family: "IBM Plex Sans"
            font.pixelSize: 20
            font.weight: Font.Medium
            horizontalAlignment: Text.AlignLeft
            lineHeight: 25
            lineHeightMode: Text.FixedHeight
            text: qsTr("End this session?")
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
        }
        Text {
            id: your_timer_detected_app_titles_and_distraction_h

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
            text: qsTr("Your timer, detected app titles, and distraction history will be saved.")
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
        }
        Rectangle {
            id: actions

            x: 32
            y: 162

            height: 44
            width: 392

            clip: true
            color: "transparent"

            Rectangle {
                id: button_Keep_focusing

                activeFocusOnTab: true
                Accessible.role: Accessible.Button
                Keys.onReturnPressed: { controller.cancelEnd() }
                Keys.onSpacePressed: { controller.cancelEnd() }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: { controller.cancelEnd() }
                }
                height: 44
                width: 184

                border.color: Tokens.FlowZen.colors.color_line
                border.width: 1
                clip: true
                color: Tokens.FlowZen.colors.color_canvas
                radius: 12

                Text {
                    id: keep_focusing

                    x: 46.50
                    y: 13

                    height: 18
                    width: 92

                    color: Tokens.FlowZen.colors.color_ink
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 17.50
                    lineHeightMode: Text.FixedHeight
                    text: qsTr("Keep focusing")
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
            Rectangle {
                id: button_End_session

                activeFocusOnTab: true
                Accessible.role: Accessible.Button
                Keys.onReturnPressed: { controller.saveSession() }
                Keys.onSpacePressed: { controller.saveSession() }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: { controller.saveSession() }
                }
                x: 196

                height: 44
                width: 196

                clip: true
                color: Tokens.FlowZen.colors.color_ink
                radius: 12

                Text {
                    id: end_session

                    x: 59.50
                    y: 13

                    height: 18
                    width: 78

                    color: Tokens.FlowZen.colors.color_sage
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 17.50
                    lineHeightMode: Text.FixedHeight
                    text: "Save session"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
        }
    }
}