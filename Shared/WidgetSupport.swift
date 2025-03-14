/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Wraps the constants that the watchOS app and widget share.
*/

struct WidgetSupport {
    static let widgetKind = "SimpleWatchWidget"
    static let appGroupContainer = "group.com.example.builtdiff"
    
    struct UserDefaultsKey {
        static let timestamp = "Timestamp"
        static let colorData = "ColorData"
    }
}
