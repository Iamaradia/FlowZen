import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window

    width: 1280
    height: 780
    minimumWidth: 1000
    minimumHeight: 650

    visible: true
    title: "Focus Detector"
    color: backgroundColor

    property color backgroundColor: "#0B1120"
    property color sidebarColor: "#101827"
    property color cardColor: "#151F32"
    property color cardHoverColor: "#1A263B"
    property color borderColor: "#253249"

    property color primaryColor: "#6366F1"
    property color primaryHoverColor: "#7477F5"
    property color successColor: "#22C55E"
    property color warningColor: "#F59E0B"
    property color dangerColor: "#EF4444"

    property color mainTextColor: "#F8FAFC"
    property color secondaryTextColor: "#94A3B8"
    property color mutedTextColor: "#64748B"

    component NavigationButton: Rectangle {
        id: navigationButton

        property string buttonText: ""
        property string buttonIcon: ""
        property bool selected: false

        signal clicked()

        Layout.fillWidth: true
        Layout.preferredHeight: 48

        radius: 12
        color: selected ? "#252A57" : navigationMouseArea.containsMouse ? "#172238" : "transparent"

        Behavior on color {
            ColorAnimation {
                duration: 160
            }
        }

        Rectangle {
            width: 4
            height: 24

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            radius: 2
            color: primaryColor
            visible: navigationButton.selected
        }

        Row {
            anchors.left: parent.left
            anchors.leftMargin: 18
            anchors.verticalCenter: parent.verticalCenter

            spacing: 14

            Text {
                width: 22

                text: navigationButton.buttonIcon
                color: navigationButton.selected ? "#A5B4FC" : secondaryTextColor
                font.pixelSize: 17
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: navigationButton.buttonText
                color: navigationButton.selected ? mainTextColor : secondaryTextColor
                font.pixelSize: 15
                font.weight: navigationButton.selected ? Font.DemiBold : Font.Medium
            }
        }

        MouseArea {
            id: navigationMouseArea

            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: navigationButton.clicked()
        }
    }

    component ActionButton: Rectangle {
        id: actionButton

        property string buttonText: ""
        property string buttonIcon: ""
        property color buttonColor: primaryColor
        property color hoverColor: primaryHoverColor
        property color textColor: "white"
        property bool outlined: false

        signal clicked()

        implicitWidth: 130
        implicitHeight: 48

        radius: 12

        color: {
            if (outlined) {
                return actionMouseArea.containsMouse ? "#1C2940" : "transparent"
            }

            return actionMouseArea.containsMouse ? hoverColor : buttonColor
        }

        border.width: outlined ? 1 : 0
        border.color: outlined ? borderColor : "transparent"

        scale: actionMouseArea.pressed ? 0.97 : 1.0

        Behavior on color {
            ColorAnimation {
                duration: 140
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: 100
            }
        }

        Row {
            anchors.centerIn: parent
            spacing: 9

            Text {
                text: actionButton.buttonIcon
                color: actionButton.textColor
                font.pixelSize: 15
            }

            Text {
                text: actionButton.buttonText
                color: actionButton.textColor
                font.pixelSize: 14
                font.weight: Font.DemiBold
            }
        }

        MouseArea {
            id: actionMouseArea

            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: actionButton.clicked()
        }
    }

    component StatCard: Rectangle {
        id: statCard

        property string titleText: ""
        property string valueText: ""
        property string iconText: ""
        property color accentColor: primaryColor

        Layout.fillWidth: true
        Layout.preferredHeight: 118

        radius: 16
        color: statMouseArea.containsMouse ? cardHoverColor : cardColor

        border.width: 1
        border.color: borderColor

        Behavior on color {
            ColorAnimation {
                duration: 170
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 20

            spacing: 16

            Rectangle {
                Layout.preferredWidth: 46
                Layout.preferredHeight: 46

                radius: 13
                color: Qt.rgba(
                    statCard.accentColor.r,
                    statCard.accentColor.g,
                    statCard.accentColor.b,
                    0.14
                )

                Text {
                    anchors.centerIn: parent

                    text: statCard.iconText
                    color: statCard.accentColor
                    font.pixelSize: 20
                }
            }

            ColumnLayout {
                Layout.fillWidth: true

                spacing: 5

                Text {
                    text: statCard.titleText
                    color: secondaryTextColor
                    font.pixelSize: 13
                    font.weight: Font.Medium
                }

                Text {
                    text: statCard.valueText
                    color: mainTextColor
                    font.pixelSize: 24
                    font.weight: Font.Bold
                }
            }
        }

        MouseArea {
            id: statMouseArea

            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.preferredWidth: 230
            Layout.fillHeight: true

            color: sidebarColor

            border.width: 0

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 18

                spacing: 8

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 70
                    Layout.bottomMargin: 22

                    spacing: 12

                    Rectangle {
                        Layout.preferredWidth: 42
                        Layout.preferredHeight: 42

                        radius: 13
                        color: primaryColor

                        Text {
                            anchors.centerIn: parent

                            text: "F"
                            color: "white"
                            font.pixelSize: 20
                            font.weight: Font.Bold
                        }
                    }

                    ColumnLayout {
                        spacing: 1

                        Text {
                            text: "FocusFlow"
                            color: mainTextColor
                            font.pixelSize: 18
                            font.weight: Font.Bold
                        }

                        Text {
                            text: "Stay in control"
                            color: mutedTextColor
                            font.pixelSize: 11
                        }
                    }
                }

                Text {
                    text: "WORKSPACE"
                    color: mutedTextColor
                    font.pixelSize: 10
                    font.weight: Font.DemiBold
                    font.letterSpacing: 1.3

                    Layout.leftMargin: 12
                    Layout.bottomMargin: 4
                }

                NavigationButton {
                    buttonText: "Focus"
                    buttonIcon: "◉"
                    selected: true
                }

                NavigationButton {
                    buttonText: "History"
                    buttonIcon: "◷"
                }

                NavigationButton {
                    buttonText: "Insights"
                    buttonIcon: "⌁"
                }

                Item {
                    Layout.fillHeight: true
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    Layout.bottomMargin: 8

                    color: borderColor
                }

                NavigationButton {
                    buttonText: "Settings"
                    buttonIcon: "⚙"
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 66
                    Layout.topMargin: 6

                    radius: 14
                    color: "#141E30"

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 12

                        spacing: 11

                        Rectangle {
                            Layout.preferredWidth: 38
                            Layout.preferredHeight: 38

                            radius: 19
                            color: "#263451"

                            Text {
                                anchors.centerIn: parent

                                text: "AS"
                                color: mainTextColor
                                font.pixelSize: 12
                                font.weight: Font.Bold
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 1

                            Text {
                                text: "Student"
                                color: mainTextColor
                                font.pixelSize: 13
                                font.weight: Font.DemiBold
                            }

                            Text {
                                text: "Local profile"
                                color: mutedTextColor
                                font.pixelSize: 10
                            }
                        }

                        Text {
                            text: "›"
                            color: mutedTextColor
                            font.pixelSize: 20
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true

            color: backgroundColor

            Flickable {
                anchors.fill: parent

                contentWidth: width
                contentHeight: dashboardColumn.implicitHeight + 64
                clip: true

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }

                ColumnLayout {
                    id: dashboardColumn

                    width: parent.width
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right

                    anchors.topMargin: 32
                    anchors.leftMargin: 36
                    anchors.rightMargin: 36
                    anchors.bottomMargin: 32

                    spacing: 22

                    RowLayout {
                        Layout.fillWidth: true

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 5

                            Text {
                                text: "Good evening"
                                color: mainTextColor
                                font.pixelSize: 28
                                font.weight: Font.Bold
                            }

                            Text {
                                text: "Ready to make this session count?"
                                color: secondaryTextColor
                                font.pixelSize: 14
                            }
                        }

                        Rectangle {
                            Layout.preferredWidth: 140
                            Layout.preferredHeight: 38

                            radius: 19
                            color: "#102D24"

                            border.width: 1
                            border.color: "#1D5A43"

                            Row {
                                anchors.centerIn: parent
                                spacing: 8

                                Rectangle {
                                    width: 8
                                    height: 8

                                    radius: 4
                                    color: successColor
                                }

                                Text {
                                    text: "Camera ready"
                                    color: "#86EFAC"
                                    font.pixelSize: 12
                                    font.weight: Font.DemiBold
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 300

                        radius: 20
                        color: cardColor

                        border.width: 1
                        border.color: borderColor

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top

                            height: 4
                            radius: 2
                            color: primaryColor
                        }

                        ColumnLayout {
                            anchors.centerIn: parent
                            width: parent.width - 80

                            spacing: 14

                            Text {
                                text: "CURRENT SESSION"
                                color: mutedTextColor
                                font.pixelSize: 11
                                font.weight: Font.DemiBold
                                font.letterSpacing: 1.6

                                Layout.alignment: Qt.AlignHCenter
                            }

                            Text {
                                text: "00:00:00"
                                color: mainTextColor
                                font.pixelSize: 72
                                font.weight: Font.Bold
                                font.family: "Consolas"

                                Layout.alignment: Qt.AlignHCenter
                            }

                            Rectangle {
                                Layout.preferredWidth: 108
                                Layout.preferredHeight: 32
                                Layout.alignment: Qt.AlignHCenter

                                radius: 16
                                color: "#1A273D"

                                Row {
                                    anchors.centerIn: parent
                                    spacing: 7

                                    Rectangle {
                                        width: 7
                                        height: 7

                                        radius: 4
                                        color: secondaryTextColor
                                    }

                                    Text {
                                        text: "Ready"
                                        color: secondaryTextColor
                                        font.pixelSize: 12
                                        font.weight: Font.DemiBold
                                    }
                                }
                            }

                            RowLayout {
                                Layout.alignment: Qt.AlignHCenter
                                Layout.topMargin: 8

                                spacing: 12

                                ActionButton {
                                    buttonText: "Start"
                                    buttonIcon: "▶"
                                    buttonColor: primaryColor
                                    hoverColor: primaryHoverColor
                                }

                                ActionButton {
                                    buttonText: "Pause"
                                    buttonIcon: "Ⅱ"
                                    outlined: true
                                    textColor: mainTextColor
                                }

                                ActionButton {
                                    buttonText: "Finish"
                                    buttonIcon: "■"
                                    outlined: true
                                    textColor: "#FCA5A5"
                                }
                            }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 16

                        StatCard {
                            titleText: "Focus time"
                            valueText: "00:00:00"
                            iconText: "✓"
                            accentColor: successColor
                        }

                        StatCard {
                            titleText: "Session time"
                            valueText: "00:00:00"
                            iconText: "◷"
                            accentColor: primaryColor
                        }

                        StatCard {
                            titleText: "Distraction time"
                            valueText: "00:00:00"
                            iconText: "!"
                            accentColor: warningColor
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 245

                        spacing: 16

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.preferredWidth: 2

                            radius: 18
                            color: cardColor

                            border.width: 1
                            border.color: borderColor

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 20

                                spacing: 14

                                RowLayout {
                                    Layout.fillWidth: true

                                    Text {
                                        text: "Camera preview"
                                        color: mainTextColor
                                        font.pixelSize: 16
                                        font.weight: Font.DemiBold
                                    }

                                    Item {
                                        Layout.fillWidth: true
                                    }

                                    Text {
                                        text: "LIVE"
                                        color: successColor
                                        font.pixelSize: 10
                                        font.weight: Font.Bold
                                        font.letterSpacing: 1
                                    }
                                }

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    radius: 13
                                    color: "#080D18"

                                    border.width: 1
                                    border.color: "#202C40"

                                    Column {
                                        anchors.centerIn: parent
                                        spacing: 9

                                        Text {
                                            anchors.horizontalCenter: parent.horizontalCenter

                                            text: "◉"
                                            color: mutedTextColor
                                            font.pixelSize: 32
                                        }

                                        Text {
                                            anchors.horizontalCenter: parent.horizontalCenter

                                            text: "Camera preview will appear here"
                                            color: mutedTextColor
                                            font.pixelSize: 12
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.preferredWidth: 1

                            radius: 18
                            color: cardColor

                            border.width: 1
                            border.color: borderColor

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 22

                                spacing: 14

                                Text {
                                    text: "Current activity"
                                    color: mainTextColor
                                    font.pixelSize: 16
                                    font.weight: Font.DemiBold
                                }

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 70

                                    radius: 13
                                    color: "#101A2A"

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 14

                                        spacing: 12

                                        Rectangle {
                                            Layout.preferredWidth: 40
                                            Layout.preferredHeight: 40

                                            radius: 11
                                            color: "#242956"

                                            Text {
                                                anchors.centerIn: parent

                                                text: "A"
                                                color: "#A5B4FC"
                                                font.pixelSize: 16
                                                font.weight: Font.Bold
                                            }
                                        }

                                        ColumnLayout {
                                            Layout.fillWidth: true
                                            spacing: 2

                                            Text {
                                                text: "No activity detected"
                                                color: mainTextColor
                                                font.pixelSize: 13
                                                font.weight: Font.DemiBold
                                            }

                                            Text {
                                                text: "Start a session to begin tracking"
                                                color: mutedTextColor
                                                font.pixelSize: 11
                                            }
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true

                                    Text {
                                        text: "Focus status"
                                        color: secondaryTextColor
                                        font.pixelSize: 12
                                    }

                                    Item {
                                        Layout.fillWidth: true
                                    }

                                    Text {
                                        text: "Waiting"
                                        color: warningColor
                                        font.pixelSize: 12
                                        font.weight: Font.DemiBold
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true

                                    Text {
                                        text: "Face detected"
                                        color: secondaryTextColor
                                        font.pixelSize: 12
                                    }

                                    Item {
                                        Layout.fillWidth: true
                                    }

                                    Text {
                                        text: "No"
                                        color: mutedTextColor
                                        font.pixelSize: 12
                                        font.weight: Font.DemiBold
                                    }
                                }

                                Item {
                                    Layout.fillHeight: true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

