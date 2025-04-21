pragma Singleton
import QtQuick 2.15

QtObject {
    id: theme
    
    // Base colors
    readonly property color black: "#000000"
    readonly property color white: "#FFFFFF"
    readonly property color primary: "#3498db"
    readonly property color secondary: "#2ecc71"
    readonly property color accent: "#e74c3c"
    
    // UI properties
    readonly property bool mapAreaVisible: true
    
    // Helper function for transparent colors
    function alphaColor(baseColor, alpha) {
        return Qt.rgba(
            baseColor.r,
            baseColor.g,
            baseColor.b,
            alpha
        );
    }
}
