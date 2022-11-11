import SwiftUI

@main
struct LifepadApp: App {
    
    @StateObject var customizationManager = CustomizationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(customizationManager)
        }
    }
}
