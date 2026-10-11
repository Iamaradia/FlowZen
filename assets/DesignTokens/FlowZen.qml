pragma Singleton

import QtQuick

QtObject {
    id: flowZen

    property FlowZenTheme activeTheme: _default
    property FlowZenColors colors: activeTheme.colors
    property FlowZenNumbers numbers: activeTheme.numbers

    property FlowZenTheme _default: FlowZenTheme {
        colors: FlowZenColors {
            color_active: "#235347"
            color_amber: "#163832"
            color_canvas: "#f3faf4"
            color_forest: "#051f20"
            color_green: "#163832"
            color_ink: "#051f20"
            color_light: "#daf1de"
            color_line: "#8eb69b"
            color_muted: "#235347"
            color_nav: "#8eb69b"
            color_sage: "#daf1de"
            color_surface: "#235347"
        }
        numbers: FlowZenNumbers {
            space_0: 0
            space_12: 12
            space_16: 16
            space_20: 20
            space_24: 24
            space_32: 32
            space_4: 4
            space_40: 40
            space_48: 48
            space_8: 8
        }
    }
}