import QtQuick
import QtQuick.Controls
import DesignTokens as Tokens

Rectangle {
    id: history

    required property var controller
    objectName: "History"
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

            Control_Navigation {
                id: _focus

                x: 4

                width: 160

                label: "Focus"
                onClicked: controller.navigate("focus")


            }
            Control_Selected {
                id: history_1

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
        scale: history.contentScale
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
                    id: history_2

                    height: 40
                    width: 107

                    color: Tokens.FlowZen.colors.color_ink
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 32
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 40
                    lineHeightMode: Text.FixedHeight
                    text: qsTr("History")
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
        }
        Rectangle {
            id: weekly_summary

            x: 40
            y: 134

            height: 112
            width: 912

            clip: true
            color: "transparent"

            Rectangle {
                id: tHIS_WEEK

                height: 112
                width: 288

                clip: true
                color: Tokens.FlowZen.colors.color_surface
                radius: Tokens.FlowZen.numbers.space_12

                Text {
                    id: tHIS_WEEK_1

                    x: 20
                    y: 20

                    height: 15
                    width: 64

                    color: Tokens.FlowZen.colors.color_nav
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 12
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 15
                    lineHeightMode: Text.FixedHeight
                    text: qsTr("THIS WEEK")
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
                Text {
                    id: h_35m

                    x: 20
                    y: 39

                    height: 25
                    width: 248

                    color: Tokens.FlowZen.colors.color_light
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 25
                    lineHeightMode: Text.FixedHeight
                    text: controller.summary.weekFocus
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
                Text {
                    id: across_18_sessions

                    x: 20
                    y: 68

                    height: 15
                    width: 248

                    color: Tokens.FlowZen.colors.color_nav
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 12
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 15
                    lineHeightMode: Text.FixedHeight
                    text: controller.summary.weekSessions
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
            Rectangle {
                id: aVERAGE_FOCUS

                x: 312

                height: 112
                width: 288

                clip: true
                color: Tokens.FlowZen.colors.color_surface
                radius: Tokens.FlowZen.numbers.space_12

                Text {
                    id: aVERAGE_FOCUS_1

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
                    text: qsTr("AVERAGE FOCUS")
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
                Text {
                    id: element

                    x: 20
                    y: 39

                    height: 25
                    width: 248

                    color: Tokens.FlowZen.colors.color_light
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 25
                    lineHeightMode: Text.FixedHeight
                    text: controller.summary.weekScore
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
                Text {
                    id: camera_tracked_sessions

                    x: 20
                    y: 68

                    height: 15
                    width: 138

                    color: Tokens.FlowZen.colors.color_nav
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 12
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 15
                    lineHeightMode: Text.FixedHeight
                    text: qsTr("Camera-tracked sessions")
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
            Rectangle {
                id: lONGEST_SESSION

                x: 624

                height: 112
                width: 288

                clip: true
                color: Tokens.FlowZen.colors.color_surface
                radius: Tokens.FlowZen.numbers.space_12

                Text {
                    id: lONGEST_SESSION_1

                    x: 20
                    y: 20

                    height: 15
                    width: 106

                    color: Tokens.FlowZen.colors.color_nav
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 12
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 15
                    lineHeightMode: Text.FixedHeight
                    text: qsTr("LONGEST SESSION")
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
                Text {
                    id: min

                    x: 20
                    y: 39

                    height: 25
                    width: 248

                    color: Tokens.FlowZen.colors.color_light
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 25
                    lineHeightMode: Text.FixedHeight
                    text: controller.summary.longestDuration
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
                Text {
                    id: wednesday_23_September

                    x: 20
                    y: 68

                    height: 15
                    width: 248

                    color: Tokens.FlowZen.colors.color_nav
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 12
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 15
                    lineHeightMode: Text.FixedHeight
                    text: controller.summary.longestDate
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
        }
        Item {
            id: sessionList
            x: 40; y: 270; width: 912; height: 490
            Text {
                text: "Recent sessions"
                color: Tokens.FlowZen.colors.color_ink
                font.family: "IBM Plex Sans"; font.pixelSize: 20
            }
            Row {
                y: 40
                Repeater {
                    model: ["TASK", "DATE", "DURATION", "FOCUS"]
                    Text {
                        required property int index
                        required property string modelData
                        width: [336, 240, 160, 140][index]
                        text: modelData
                        color: Tokens.FlowZen.colors.color_muted
                        font.family: "IBM Plex Sans"; font.pixelSize: 12
                    }
                }
            }
            ListView {
                id: sessionHistory
                objectName: "sessionHistory"
                y: 70; width: parent.width; height: parent.height - y
                clip: true
                model: controller.sessions
                ScrollBar.vertical: ScrollBar {}
                delegate: Rectangle {
                    required property var modelData
                    width: sessionHistory.width; height: 56
                    color: rowMouse.containsMouse ? Tokens.FlowZen.colors.color_sage : "transparent"
                    radius: 8
                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        Repeater {
                            model: [modelData.title, modelData.date, modelData.duration, modelData.score]
                            Text {
                                required property int index
                                required property string modelData
                                width: [336, 240, 160, 140][index]
                                text: modelData
                                elide: Text.ElideRight
                                color: Tokens.FlowZen.colors.color_ink
                                font.family: "IBM Plex Sans"; font.pixelSize: 14
                            }
                        }
                    }
                    activeFocusOnTab: true
                    Accessible.role: Accessible.Button
                    Accessible.name: modelData.title + ", " + modelData.date
                    Keys.onReturnPressed: controller.openSession(modelData.id)
                    MouseArea {
                        id: rowMouse
                        anchors.fill: parent; hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: controller.openSession(parent.modelData.id)
                    }
                }
            }
            Text {
                y: 100
                visible: controller.sessions.length === 0
                text: "No saved sessions yet. Start a focus session to see it here."
                color: Tokens.FlowZen.colors.color_muted
                font.family: "IBM Plex Sans"; font.pixelSize: 14
            }
        }
    }
}