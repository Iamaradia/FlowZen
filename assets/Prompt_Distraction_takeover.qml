import QtQuick
import QtQuick.Controls
import DesignTokens as Tokens

Rectangle {
    id: prompt_Distraction_takeover

    required property var controller
    objectName: "Prompt_Distraction_takeover"
    height: 800
    width: 1200
    anchors.centerIn: parent
    scale: Math.min(parent.width / 1200, parent.height / 800)

    clip: true
    color: Tokens.FlowZen.colors.color_ink

    Text {
        id: flowZen

        x: 40
        y: 28

        height: 35
        width: 117

        color: Tokens.FlowZen.colors.color_sage
        font.family: "Bodoni Moda"
        font.pixelSize: 28
        font.weight: Font.Bold
        horizontalAlignment: Text.AlignLeft
        lineHeight: 35
        lineHeightMode: Text.FixedHeight
        text: qsTr("FlowZen")
        textFormat: Text.PlainText
        verticalAlignment: Text.AlignTop
    }
    Text {
        id: element

        x: 1094
        y: 34

        height: 18
        width: 39

        color: Tokens.FlowZen.colors.color_sage
        font.family: "IBM Plex Sans"
        font.pixelSize: 14
        font.weight: Font.Medium
        horizontalAlignment: Text.AlignLeft
        lineHeight: 17.50
        lineHeightMode: Text.FixedHeight
        text: controller.state.remaining
        textFormat: Text.PlainText
        verticalAlignment: Text.AlignTop
    }
    Rectangle {
        id: distraction_prompt

        x: 260
        y: 120

        height: 531
        width: 680

        clip: true
        color: Tokens.FlowZen.colors.color_sage
        radius: 32

        Text {
            id: fOCUS_PAUSED

            x: 290.50
            y: 40

            height: 15
            width: 102

            color: Tokens.FlowZen.colors.color_surface
            font.family: "IBM Plex Sans"
            font.letterSpacing: 1.20
            font.pixelSize: 12
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignLeft
            lineHeight: 15
            lineHeightMode: Text.FixedHeight
            text: qsTr("FOCUS PAUSED")
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
        }
        Text {
            id: back_to_focus

            x: 241.50
            y: 73

            height: 40
            width: 198

            color: Tokens.FlowZen.colors.color_ink
            font.family: "IBM Plex Sans"
            font.pixelSize: 32
            font.weight: Font.Medium
            horizontalAlignment: Text.AlignLeft
            lineHeight: 40
            lineHeightMode: Text.FixedHeight
            text: qsTr("Back to focus")
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
        }
        Text {
            id: you_have_been_out_of_frame_for_18_seconds_

            x: 40
            y: 131

            height: 18
            width: 601

            color: Tokens.FlowZen.colors.color_ink
            font.family: "IBM Plex Sans"
            font.pixelSize: 14
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignHCenter
            lineHeight: 17.50
            lineHeightMode: Text.FixedHeight
            text: controller.state.distractionReason
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
        }
        Rectangle {
            id: camera_preview_16_9

            Image {
                anchors.fill: parent
                source: controller.state.cameraReady ? controller.cameraSource : ""
                cache: false
                fillMode: Image.PreserveAspectCrop
            }
            x: 180
            y: 167

            height: 180
            width: 320

            clip: true
            color: Tokens.FlowZen.colors.color_surface
            radius: 18

            Text {
                id: camera_preview

                visible: !controller.state.cameraReady
                x: 116.50
                y: 82.50

                height: 15
                width: 88

                color: Tokens.FlowZen.colors.color_sage
                font.family: "IBM Plex Sans"
                font.pixelSize: 12
                font.weight: Font.Normal
                horizontalAlignment: Text.AlignLeft
                lineHeight: 15
                lineHeightMode: Text.FixedHeight
                text: qsTr("Camera preview")
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
            }
        }
        Rectangle {
            id: detected_app

            x: 40
            y: 365

            height: 64
            width: 600

            clip: true
            color: Tokens.FlowZen.colors.color_canvas
            radius: 12

            Text {
                id: detected_app_title

                x: 16
                y: 10

                height: 15
                width: 98

                color: Tokens.FlowZen.colors.color_surface
                font.family: "IBM Plex Sans"
                font.pixelSize: 12
                font.weight: Font.Normal
                horizontalAlignment: Text.AlignLeft
                lineHeight: 15
                lineHeightMode: Text.FixedHeight
                text: qsTr("Detected app title")
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
            }
            Text {
                id: chrome_Google_Docs

                objectName: "detectedAppTitle"
                HoverHandler { id: appTitleHover }
                ToolTip.visible: appTitleHover.hovered
                ToolTip.text: controller.state.appTitle

                elide: Text.ElideRight
                x: 16
                y: 28

                height: 18
                width: parent.width - 32

                color: Tokens.FlowZen.colors.color_ink
                font.family: "IBM Plex Sans"
                font.pixelSize: 14
                font.weight: Font.Medium
                horizontalAlignment: Text.AlignLeft
                lineHeight: 17.50
                lineHeightMode: Text.FixedHeight
                text: controller.state.appTitle
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
            }
        }
        Rectangle {
            id: actions

            x: 40
            y: 447

            height: 44
            width: 600

            clip: true
            color: "transparent"

            Rectangle {
                id: button_End_session

                activeFocusOnTab: true
                Accessible.role: Accessible.Button
                Keys.onReturnPressed: { controller.requestEnd() }
                Keys.onSpacePressed: { controller.requestEnd() }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: { controller.requestEnd() }
                }
                x: 104

                height: 44
                width: 184

                border.color: Tokens.FlowZen.colors.color_line
                border.width: 1
                clip: true
                color: Tokens.FlowZen.colors.color_canvas
                radius: 12

                Text {
                    id: end_session

                    x: 53.50
                    y: 13

                    height: 18
                    width: 78

                    color: Tokens.FlowZen.colors.color_ink
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 17.50
                    lineHeightMode: Text.FixedHeight
                    text: qsTr("End session")
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
            Rectangle {
                id: button_I_m_back

                activeFocusOnTab: true
                Accessible.role: Accessible.Button
                Keys.onReturnPressed: { controller.resumeFocus() }
                Keys.onSpacePressed: { controller.resumeFocus() }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: { controller.resumeFocus() }
                }
                x: 300

                height: 44
                width: 196

                clip: true
                color: Tokens.FlowZen.colors.color_ink
                radius: 12

                Text {
                    id: i_m_back

                    x: 70
                    y: 13

                    height: 18
                    width: 57

                    color: Tokens.FlowZen.colors.color_sage
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 17.50
                    lineHeightMode: Text.FixedHeight
                    text: qsTr("I’m back")
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
        }
    }
}
