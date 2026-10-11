import QtQuick
import QtQuick.Controls
import DesignTokens as Tokens

Rectangle {
    id: settings

    required property var controller
    objectName: "Settings"
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
            Control_Navigation {
                id: history

                x: 4
                y: 52

                width: 160

                label: "History"
                onClicked: controller.navigate("history")


            }
            Control_Selected {
                id: settings_1

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
        scale: settings.contentScale
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
                    id: settings_2

                    height: 40
                    width: 122

                    color: Tokens.FlowZen.colors.color_ink
                    font.family: "IBM Plex Sans"
                    font.pixelSize: 32
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 40
                    lineHeightMode: Text.FixedHeight
                    text: qsTr("Settings")
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
        }
        Rectangle {
            id: session_defaults

            x: 40
            y: 134

            height: 181
            width: 912

            clip: true
            color: Tokens.FlowZen.colors.color_surface
            radius: Tokens.FlowZen.numbers.space_12

            Text {
                id: session_defaults_1

                x: 16
                y: 16

                height: 25
                width: 152

                color: Tokens.FlowZen.colors.color_light
                font.family: "IBM Plex Sans"
                font.pixelSize: 20
                font.weight: Font.Medium
                horizontalAlignment: Text.AlignLeft
                lineHeight: 25
                lineHeightMode: Text.FixedHeight
                text: qsTr("Session defaults")
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
            }
            Rectangle {
                id: focus_duration

                x: 16
                y: 49

                height: 54
                width: 880

                clip: true
                color: "transparent"

                Rectangle {
                    id: description

                    y: 18

                    height: 18
                    width: 640

                    clip: true
                    color: "transparent"

                    Text {
                        id: focus_duration_1

                        height: 18
                        width: 97

                        color: Tokens.FlowZen.colors.color_light
                        font.family: "IBM Plex Sans"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignLeft
                        lineHeight: 17.50
                        lineHeightMode: Text.FixedHeight
                        text: qsTr("Focus duration")
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
                DurationPicker {
                    id: minutes_
                    x: 680; y: 5; width: 200
                    to: 120
                    value: controller.state.focusMinutes
                    enabled: !controller.state.active
                    onValueModified: controller.setPreference("focusMinutes", value)
                }
            }
            Rectangle {
                id: break_duration

                x: 16
                y: 111

                height: 54
                width: 880

                clip: true
                color: "transparent"

                Rectangle {
                    id: description_1

                    y: 18

                    height: 18
                    width: 640

                    clip: true
                    color: "transparent"

                    Text {
                        id: break_duration_1

                        height: 18
                        width: 97

                        color: Tokens.FlowZen.colors.color_light
                        font.family: "IBM Plex Sans"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignLeft
                        lineHeight: 17.50
                        lineHeightMode: Text.FixedHeight
                        text: qsTr("Break duration")
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
                DurationPicker {
                    id: minutes_1
                    x: 680; y: 5; width: 200
                    to: 60
                    value: controller.state.breakMinutes
                    enabled: true
                    onValueModified: controller.setPreference("breakMinutes", value)
                }
            }
        }
        Rectangle {
            id: detection

            x: 40
            y: 339

            height: 181
            width: 912

            clip: true
            color: Tokens.FlowZen.colors.color_surface
            radius: Tokens.FlowZen.numbers.space_12

            Text {
                id: detection_1

                x: 16
                y: 16

                height: 25
                width: 90

                color: Tokens.FlowZen.colors.color_light
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
                id: focus_tracking

                x: 16
                y: 49

                height: 54
                width: 880

                clip: true
                color: "transparent"

                Rectangle {
                    id: description_2

                    y: 18

                    height: 18
                    width: 640

                    clip: true
                    color: "transparent"

                    Text {
                        id: focus_tracking_1

                        height: 18
                        width: 95

                        color: Tokens.FlowZen.colors.color_light
                        font.family: "IBM Plex Sans"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignLeft
                        lineHeight: 17.50
                        lineHeightMode: Text.FixedHeight
                        text: qsTr("Focus tracking")
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
                Control_Secondary {
                    id: _on

                    enabled: !controller.state.active
                    onClicked: controller.setPreference("focusTracking", !controller.state.focusTracking)
                    x: 680
                    y: 5

                    width: 200

                    label: controller.state.focusTracking ? "On" : "Off"


                }
            }
            Rectangle {
                id: website_tracking

                x: 16
                y: 111

                height: 48
                width: 880

                clip: true
                color: "transparent"

                Rectangle {
                    id: description_3

                    y: 15

                    height: 18
                    width: 640

                    clip: true
                    color: "transparent"

                    Text {
                        id: app_title_tracking

                        height: 18
                        width: 112

                        color: Tokens.FlowZen.colors.color_light
                        font.family: "IBM Plex Sans"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignLeft
                        lineHeight: 17.50
                        lineHeightMode: Text.FixedHeight
                        text: qsTr("App title tracking")
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
                Control_Secondary {
                    id: configure

                    onClicked: controller.setPreference("appTracking", !controller.state.appTracking)
                    x: 680
                    y: 2

                    width: 200

                    label: controller.state.appTracking ? "On" : "Off"


                }
            }
        }
        Rectangle {
            id: preferences

            x: 40
            y: 544

            height: 119
            width: 912

            clip: true
            color: Tokens.FlowZen.colors.color_surface
            radius: Tokens.FlowZen.numbers.space_12

            Text {
                id: preferences_1

                x: 16
                y: 16

                height: 25
                width: 112

                color: Tokens.FlowZen.colors.color_light
                font.family: "IBM Plex Sans"
                font.pixelSize: 20
                font.weight: Font.Medium
                horizontalAlignment: Text.AlignLeft
                lineHeight: 25
                lineHeightMode: Text.FixedHeight
                text: qsTr("Preferences")
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
            }
            Rectangle {
                id: session_sound

                x: 16
                y: 49

                height: 54
                width: 880

                clip: true
                color: "transparent"

                Rectangle {
                    id: description_4

                    y: 18

                    height: 18
                    width: 640

                    clip: true
                    color: "transparent"

                    Text {
                        id: session_sound_1

                        height: 18
                        width: 94

                        color: Tokens.FlowZen.colors.color_light
                        font.family: "IBM Plex Sans"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignLeft
                        lineHeight: 17.50
                        lineHeightMode: Text.FixedHeight
                        text: qsTr("Session sound")
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
                Control_Secondary {
                    id: _on_1

                    onClicked: controller.setPreference("sessionSound", !controller.state.sessionSound)
                    x: 680
                    y: 5

                    width: 200

                    label: controller.state.sessionSound ? "On" : "Off"


                }
            }
        }
    }
}