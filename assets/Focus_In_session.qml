import QtQuick
import QtQuick.Controls
import DesignTokens as Tokens

Rectangle {
    id: focus_In_session

    required property var controller
    objectName: "Focus_In_session"
    property real contentScale: Math.min((width - 208) / 992, height / 800)
    height: parent ? parent.height : 800
    width: parent ? parent.width : 1200

    clip: true
    color: Tokens.FlowZen.colors.color_canvas

    Rectangle {
        id: sidebar
        objectName: "appSidebar"

        height: parent.height
        width: 208

        clip: true
        color: Tokens.FlowZen.colors.color_forest

        Rectangle {
            id: brand

            x: 24
            y: 20

            height: 48
            width: 160

            clip: true
            color: "transparent"

            Text {
                id: flowZen_wordmark
                objectName: "flowZenWordmark"

                x: 0
                y: 12

                height: 36
                width: parent.width

                color: Tokens.FlowZen.colors.color_sage
                font.family: "Bodoni Moda"
                font.letterSpacing: -0.56
                font.pixelSize: 22
                font.weight: Font.Bold
                horizontalAlignment: Text.AlignHCenter
                lineHeight: 36
                lineHeightMode: Text.FixedHeight
                text: qsTr("FlowZen")
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
                wrapMode: Text.NoWrap
            }
        }
        Rectangle {
            id: navigation

            x: 20
            y: 100

            height: 148
            width: 168

            clip: true
            color: "transparent"

            Control_Selected {
                id: _focus

                x: 4

                width: 160

                label: "Focus"
                onClicked: controller.navigate("focus")


            }
            Control_Navigation {
                id: history

                x: 4
                y: 52

                width: 160

                label: "History"
                onClicked: controller.navigate("history")


            }
            Control_Navigation {
                id: settings

                x: 4
                y: 104

                width: 160

                label: "Settings"
                onClicked: controller.navigate("settings")

            }
        }
        Rectangle {
            id: flexible_space

            x: 20
            y: 280

            height: 453
            width: 168

            clip: true
            color: "transparent"
        }
        Text {
            id: flowZen_Desktop

            x: 53.50
            y: parent.height - height - 20

            height: 15
            width: 102

            color: Tokens.FlowZen.colors.color_nav
            font.family: "IBM Plex Sans"
            font.pixelSize: 12
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignLeft
            lineHeight: 15
            lineHeightMode: Text.FixedHeight
            text: qsTr("FlowZen / Desktop")
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
        }
    }
    Rectangle {
        id: content
        objectName: "appContent"

        x: 208 + (parent.width - 208 - width * scale) / 2
        y: (parent.height - height * scale) / 2

        height: 800
        width: 992
        scale: focus_In_session.contentScale
        transformOrigin: Item.TopLeft

        clip: true
        color: "transparent"

        Rectangle {
            id: page_header

            x: 40
            y: 40

            height: 70
            width: 912

            clip: true
            color: "transparent"

            Rectangle {
                id: title

                y: 15

                height: 40
                width: 680

                clip: true
                color: "transparent"

                Text {
                    id: _focus_1

                    height: 40
                    width: 87

                    color: Tokens.FlowZen.colors.color_ink
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 32
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 40
                    lineHeightMode: Text.FixedHeight
                    text: qsTr("Focus")
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
        }
        Rectangle {
            id: focusContent

            x: 40
            y: 134

            height: 352
            width: 912

            clip: true
            color: "transparent"

            Rectangle {
                id: timer_panel

                height: 352
                width: 560

                clip: true
                color: Tokens.FlowZen.colors.color_surface
                radius: Tokens.FlowZen.numbers.space_12

                Text {
                    id: fOCUS_SESSION

                    x: 226.50
                    y: 33.50

                    height: 15
                    width: 108

                    color: Tokens.FlowZen.colors.color_nav
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 12
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 15
                    lineHeightMode: Text.FixedHeight
                    text: qsTr("●  FOCUS SESSION")
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
                Rectangle {
                    id: task_field

                    x: 36
                    y: 64.50

                    height: 44
                    width: 488

                    clip: true
                    color: Tokens.FlowZen.colors.color_canvas
                    radius: Tokens.FlowZen.numbers.space_8

                    TextField {
                        id: taskName
                        objectName: "taskName"
                        anchors.fill: parent
                        anchors.margins: 4
                        text: controller.sessionTitle
                        placeholderText: "What are you focusing on?"
                        readOnly: controller.state.active
                        maximumLength: 160
                        font.family: "IBM Plex Sans"
                        font.pixelSize: 14
                        color: Tokens.FlowZen.colors.color_ink
                        background: Item {}
                        onEditingFinished: controller.setTitle(text)
                    }
                }
                Rectangle {
                    id: timer

                    x: 36
                    y: 124.50

                    height: 134
                    width: 488

                    clip: true
                    color: "transparent"

                    Text {
                        id: element

                        x: 0

                        height: 110
                        width: parent.width

                        color: Tokens.FlowZen.colors.color_light
                        font.family: "IBM Plex Sans"
                        font.pixelSize: 88
                        font.weight: Font.Normal
                        horizontalAlignment: Text.AlignHCenter
                        lineHeight: 110
                        lineHeightMode: Text.FixedHeight
                        text: controller.state.remaining
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                    Text {
                        id: of_25_minutes

                        x: 0
                        y: 110

                        height: 15
                        width: parent.width

                        color: Tokens.FlowZen.colors.color_nav
                        font.family: "IBM Plex Sans"
                        font.pixelSize: 12
                        font.weight: Font.Normal
                        horizontalAlignment: Text.AlignHCenter
                        lineHeight: 15
                        lineHeightMode: Text.FixedHeight
                        text: controller.state.sessionHint
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
                Rectangle {
                    id: session_actions

                    x: 36
                    y: 274.50

                    height: 44
                    width: 488

                    clip: true
                    color: "transparent"

                    Control_Primary {
                        id: pause_session

                    onClicked: controller.togglePause()
                        x: 70

                        width: 196

                        label: controller.state.paused ? "Resume session" : "Pause session"


                    }
                    Control_Secondary {
                        id: finish

                    onClicked: controller.requestEnd()
                        x: 278

                        width: 140

                        label: "Finish"


                    }
                }
            }
            Rectangle {
                id: detectionPanel

                x: 576

                height: 352
                width: 336

                clip: true
                color: Tokens.FlowZen.colors.color_sage
                radius: Tokens.FlowZen.numbers.space_12

                Text {
                    id: detection

                    x: 20
                    y: 16

                    height: 25
                    width: 90

                    color: Tokens.FlowZen.colors.color_ink
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 25
                    lineHeightMode: Text.FixedHeight
                    text: qsTr("Detection")
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
                Rectangle {
                    id: camera_status

                    x: 20
                    y: 53

                    height: 32
                    width: 296

                    clip: true
                    color: "transparent"

                    Text {
                        id: camera

                        y: 7

                        height: 18
                        width: 51

                        color: Tokens.FlowZen.colors.color_ink
                        font.family: "IBM Plex Sans"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignLeft
                        lineHeight: 17.50
                        lineHeightMode: Text.FixedHeight
                        text: qsTr("Camera")
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                    Text {
                        id: focused

                        x: 92
                        y: 8.50

                        height: 15
                        width: 204

                        color: Tokens.FlowZen.colors.color_green
                        font.family: "IBM Plex Sans"
                        font.pixelSize: 12
                        font.weight: Font.Normal
                        horizontalAlignment: Text.AlignRight
                        lineHeight: 15
                        lineHeightMode: Text.FixedHeight
                        text: controller.state.status
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
                Rectangle {
                    id: detection_divider

                    x: 20
                    y: 97

                    height: 1
                    width: 288

                    color: Tokens.FlowZen.colors.color_line
                }
                Rectangle {
                    id: camera_preview

                    Image {
                        anchors.fill: parent
                        source: controller.state.cameraReady ? controller.cameraSource : ""
                        visible: controller.state.cameraReady
                        cache: false
                        fillMode: Image.PreserveAspectCrop
                    }
                    x: 20
                    y: 110

                    height: 166.50
                    width: 296

                    clip: true
                    color: Tokens.FlowZen.colors.color_ink
                    radius: 12

                    Text {
                        id: preview_label

                        visible: !controller.state.cameraReady
                        x: 28
                        y: 62.25

                        height: 20
                        width: 241

                        color: Tokens.FlowZen.colors.color_light
                        font.family: "IBM Plex Sans"
                        font.pixelSize: 13
                        font.weight: Font.Normal
                        horizontalAlignment: Text.AlignHCenter
                        text: controller.state.cameraStarting ? "Opening camera..." : "Camera off"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                        wrapMode: Text.Wrap
                    }
                    Text {
                        id: camera_source

                        visible: !controller.state.cameraReady
                        x: 28
                        y: 86.25

                        height: 18
                        width: 241

                        color: Tokens.FlowZen.colors.color_nav
                        font.family: "IBM Plex Sans"
                        font.pixelSize: 11
                        font.weight: Font.Normal
                        horizontalAlignment: Text.AlignHCenter
                        text: "Preview stays on this device"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                        wrapMode: Text.Wrap
                    }
                }
                Rectangle {
                    id: detected_app_status

                    x: 20
                    y: 288.50

                    height: 36
                    width: 296

                    clip: true
                    color: "transparent"

                    Text {
                        id: detected_app_title

                        y: 9

                        height: 18
                        width: 116

                        color: Tokens.FlowZen.colors.color_ink
                        font.family: "IBM Plex Sans"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignLeft
                        lineHeight: 17.50
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
                        x: 132
                        y: 10.50

                        height: 15
                        width: 164

                        color: Tokens.FlowZen.colors.color_green
                        font.family: "IBM Plex Sans"
                        font.pixelSize: 12
                        font.weight: Font.Normal
                        horizontalAlignment: Text.AlignLeft
                        lineHeight: 15
                        lineHeightMode: Text.FixedHeight
                        text: controller.state.appTitle
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
            }
        }
        Rectangle {
            id: today_summary

            x: 40
            y: 510

            height: 112
            width: 912

            clip: true
            color: "transparent"

            Rectangle {
                id: fOCUSED_TODAY

                height: 112
                width: 288

                clip: true
                color: Tokens.FlowZen.colors.color_surface
                radius: Tokens.FlowZen.numbers.space_12

                Text {
                    id: fOCUSED_TODAY_1

                    x: 20
                    y: 20

                    height: 15
                    width: 94

                    color: Tokens.FlowZen.colors.color_nav
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 12
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 15
                    lineHeightMode: Text.FixedHeight
                    text: qsTr("FOCUSED TODAY")
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
                Text {
                    id: h_40m

                    x: 20
                    y: 39

                    height: 25
                    width: 71

                    color: Tokens.FlowZen.colors.color_light
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 25
                    lineHeightMode: Text.FixedHeight
                    text: controller.summary.todayFocus
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
                Text {
                    id: sessions

                    x: 20
                    y: 68

                    height: 15
                    width: 58

                    color: Tokens.FlowZen.colors.color_nav
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 12
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 15
                    lineHeightMode: Text.FixedHeight
                    text: controller.summary.todaySessions
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
            Rectangle {
                id: fOCUS_SCORE

                x: 312

                height: 112
                width: 288

                clip: true
                color: Tokens.FlowZen.colors.color_surface
                radius: Tokens.FlowZen.numbers.space_12

                Text {
                    id: fOCUS_SCORE_1

                    x: 20
                    y: 20

                    height: 15
                    width: 79

                    color: Tokens.FlowZen.colors.color_nav
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 12
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 15
                    lineHeightMode: Text.FixedHeight
                    text: qsTr("FOCUS SCORE")
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
                Text {
                    id: element_1

                    x: 20
                    y: 39

                    height: 25
                    width: 44

                    color: Tokens.FlowZen.colors.color_light
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 25
                    lineHeightMode: Text.FixedHeight
                    text: controller.summary.todayScore
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
                Text {
                    id: tracked_sessions

                    x: 20
                    y: 68

                    height: 15
                    width: 94

                    color: Tokens.FlowZen.colors.color_nav
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 12
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 15
                    lineHeightMode: Text.FixedHeight
                    text: qsTr("Tracked sessions")
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
            Rectangle {
                id: dAILY_GOAL

                x: 624

                height: 112
                width: 288

                clip: true
                color: Tokens.FlowZen.colors.color_surface
                radius: Tokens.FlowZen.numbers.space_12

                Text {
                    id: dAILY_GOAL_1

                    x: 20
                    y: 20

                    height: 15
                    width: 67

                    color: Tokens.FlowZen.colors.color_nav
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 12
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 15
                    lineHeightMode: Text.FixedHeight
                    text: qsTr("DAILY GOAL")
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
                Text {
                    id: min

                    x: 20
                    y: 39

                    height: 25
                    width: 130

                    color: Tokens.FlowZen.colors.color_light
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 25
                    lineHeightMode: Text.FixedHeight
                    text: controller.summary.goal
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
                Text {
                    id: minutes_left

                    x: 20
                    y: 68

                    height: 15
                    width: 83

                    color: Tokens.FlowZen.colors.color_nav
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 12
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 15
                    lineHeightMode: Text.FixedHeight
                    text: controller.summary.goalRemaining
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
        }
        Rectangle {
            id: recent_session

                activeFocusOnTab: true
                Accessible.role: Accessible.Button
                Keys.onReturnPressed: { controller.navigate("history") }
                Keys.onSpacePressed: { controller.navigate("history") }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: { controller.navigate("history") }
                }
            x: 40
            y: 646

            height: 44
            width: 912

            clip: true
            color: "transparent"

            Text {
                id: lAST_SESSION

                y: 14.50

                height: 15
                width: 82

                color: Tokens.FlowZen.colors.color_muted
                font.family: "IBM Plex Sans"
                font.pixelSize: 12
                font.weight: Font.Normal
                horizontalAlignment: Text.AlignLeft
                lineHeight: 15
                lineHeightMode: Text.FixedHeight
                text: qsTr("LAST SESSION")
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
            }
            Text {
                id: physics_practice_25_min_91_focus

                x: 97
                y: 13

                height: 18
                width: 236

                color: Tokens.FlowZen.colors.color_ink
                font.family: "IBM Plex Sans"
                font.pixelSize: 14
                font.weight: Font.Normal
                horizontalAlignment: Text.AlignLeft
                lineHeight: 17.50
                lineHeightMode: Text.FixedHeight
                text: controller.summary.lastSession
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
            }
        }
    }
}
