import QtQuick
import QtQuick.Controls
import DesignTokens as Tokens

Rectangle {
    id: history_Session_details

    required property var controller
    objectName: "History_Session_details"
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
        scale: history_Session_details.contentScale
        transformOrigin: Item.TopLeft

        clip: true
        color: Tokens.FlowZen.colors.color_canvas

        Rectangle {
            id: page_header

            x: 40
            y: 40

            height: 70
            width: 912

            clip: true
            color: "transparent"

            Rectangle {
                id: heading

                height: 70
                width: 680

                clip: true
                color: "transparent"

                Text {
                    id: title

                    y: 4

                    height: 38
                    width: 681

                    color: Tokens.FlowZen.colors.color_ink
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 32
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 40
                    lineHeightMode: Text.FixedHeight
                    text: qsTr("Session details")
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                    wrapMode: Text.Wrap
                }
                Text {
                    id: subtitle

                    y: 46

                    height: 20
                    width: 681

                    color: Tokens.FlowZen.colors.color_muted
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 12
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 15
                    lineHeightMode: Text.FixedHeight
                    text: (controller.selectedSession.title || "Session") + " ? " + (controller.selectedSession.date || "")
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                    wrapMode: Text.Wrap
                }
            }
            Control_Secondary {
                id: back_to_history

                onClicked: controller.navigate("history")
                x: 712
                y: 13

                width: 200

                label: "Back to history"


            }
        }
        Rectangle {
            id: session_summary

            x: 40
            y: 134

            height: 92
            width: 912

            clip: true
            color: "transparent"

            Rectangle {
                id: metric_Duration

                height: 92
                width: 216

                clip: true
                color: Tokens.FlowZen.colors.color_surface
                radius: 16

                Text {
                    id: label

                    x: 16
                    y: 16

                    height: 20
                    width: 185

                    color: Tokens.FlowZen.colors.color_nav
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 12
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 15
                    lineHeightMode: Text.FixedHeight
                    text: qsTr("DURATION")
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                    wrapMode: Text.Wrap
                }
                Text {
                    id: value

                    x: 16
                    y: 40

                    height: 30
                    width: 185

                    color: Tokens.FlowZen.colors.color_light
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 25
                    lineHeightMode: Text.FixedHeight
                    text: controller.selectedSession.duration || "0m"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                    wrapMode: Text.Wrap
                }
            }
            Rectangle {
                id: metric_Focus_score

                x: 232

                height: 92
                width: 216

                clip: true
                color: Tokens.FlowZen.colors.color_surface
                radius: 16

                Text {
                    id: label_1

                    x: 16
                    y: 16

                    height: 20
                    width: 185

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
                    wrapMode: Text.Wrap
                }
                Text {
                    id: value_1

                    x: 16
                    y: 40

                    height: 30
                    width: 185

                    color: Tokens.FlowZen.colors.color_light
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 25
                    lineHeightMode: Text.FixedHeight
                    text: controller.selectedSession.score || "0%"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
            Rectangle {
                id: metric_Distractions

                x: 464

                height: 92
                width: 216

                clip: true
                color: Tokens.FlowZen.colors.color_surface
                radius: 16

                Text {
                    id: label_2

                    x: 16
                    y: 16

                    height: 20
                    width: 185

                    color: Tokens.FlowZen.colors.color_nav
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 12
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 15
                    lineHeightMode: Text.FixedHeight
                    text: qsTr("DISTRACTIONS")
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                    wrapMode: Text.Wrap
                }
                Text {
                    id: value_2

                    x: 16
                    y: 40

                    height: 30
                    width: 185

                    color: Tokens.FlowZen.colors.color_light
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 25
                    lineHeightMode: Text.FixedHeight
                    text: controller.selectedSession.distractions || "0"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
            Rectangle {
                id: metric_Away

                x: 696

                height: 92
                width: 216

                clip: true
                color: Tokens.FlowZen.colors.color_surface
                radius: 16

                Text {
                    id: label_3

                    x: 16
                    y: 16

                    height: 20
                    width: 185

                    color: Tokens.FlowZen.colors.color_nav
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 12
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 15
                    lineHeightMode: Text.FixedHeight
                    text: qsTr("AWAY")
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
                Text {
                    id: value_3

                    x: 16
                    y: 40

                    height: 30
                    width: 185

                    color: Tokens.FlowZen.colors.color_light
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 25
                    lineHeightMode: Text.FixedHeight
                    text: controller.selectedSession.away || "0m"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                    wrapMode: Text.Wrap
                }
            }
        }
        Rectangle {
            id: sessionLists

            x: 40
            y: 250

            height: 450
            width: 912

            clip: true
            color: "transparent"

            Rectangle {
                id: eventList
                x: 0; width: 544; height: 450
                color: Tokens.FlowZen.colors.color_surface
                radius: 18
                Text {
                    x: 24; y: 24; text: "Tracking events"
                    color: Tokens.FlowZen.colors.color_light
                    font.family: "IBM Plex Sans"; font.pixelSize: 20
                }
                ListView {
                    id: eventListItems
                    x: 24; y: 65; width: parent.width - 48; height: parent.height - 89
                    clip: true
                    model: controller.selectedSession.events || []
                    ScrollBar.vertical: ScrollBar {}
                    delegate: Item {
                        required property var modelData
                        width: eventListItems.width; height: 64
                        Text {
                            width: parent.width - 75
                            text: modelData.time + " ? " + modelData.kind
                            elide: Text.ElideRight
                            color: Tokens.FlowZen.colors.color_light
                            font.family: "IBM Plex Sans"; font.pixelSize: 14
                        }
                        Text {
                            anchors.right: parent.right
                            text: modelData.duration
                            color: Tokens.FlowZen.colors.color_light
                            font.family: "IBM Plex Sans"; font.pixelSize: 12
                        }
                    }
                }
                Text {
                    x: 24; y: 80; width: parent.width - 48
                    visible: eventListItems.count === 0
                    text: "No records for this session."
                    wrapMode: Text.Wrap
                    color: Tokens.FlowZen.colors.color_light
                    font.family: "IBM Plex Sans"; font.pixelSize: 14
                }
            }
            Rectangle {
                id: detectedAppList
                x: 560; width: 352; height: 450
                color: Tokens.FlowZen.colors.color_sage
                radius: 18
                Text {
                    x: 24; y: 24; text: "Detected app titles"
                    color: Tokens.FlowZen.colors.color_ink
                    font.family: "IBM Plex Sans"; font.pixelSize: 20
                }
                ListView {
                    id: detectedAppListItems
                    x: 24; y: 65; width: parent.width - 48; height: parent.height - 89
                    clip: true
                    model: controller.selectedSession.apps || []
                    ScrollBar.vertical: ScrollBar {}
                    delegate: Item {
                        required property var modelData
                        width: detectedAppListItems.width; height: 64
                        Text {
                            width: parent.width - 75
                            text: modelData.title
                            elide: Text.ElideRight
                            color: Tokens.FlowZen.colors.color_ink
                            font.family: "IBM Plex Sans"; font.pixelSize: 14
                        }
                        Text {
                            anchors.right: parent.right
                            text: modelData.duration
                            color: Tokens.FlowZen.colors.color_ink
                            font.family: "IBM Plex Sans"; font.pixelSize: 12
                        }
                    }
                }
                Text {
                    x: 24; y: 80; width: parent.width - 48
                    visible: detectedAppListItems.count === 0
                    text: "No records for this session."
                    wrapMode: Text.Wrap
                    color: Tokens.FlowZen.colors.color_ink
                    font.family: "IBM Plex Sans"; font.pixelSize: 14
                }
            }
        }
    }
}