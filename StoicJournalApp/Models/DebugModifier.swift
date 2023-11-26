import SwiftUI // Import SwiftUI instead of Foundation

struct DebugModifier: ViewModifier {
    let debugMessage: String

    func body(content: Content) -> some View {
        content.onAppear {
            print(debugMessage)
        }
    }
}

extension View {
    func debugPrint(_ message: String) -> some View {
        self.modifier(DebugModifier(debugMessage: message))
    }
}

