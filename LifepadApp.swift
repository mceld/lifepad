import Foundation
import SwiftUI


@main
struct LifepadApp: App {
    // https://stackoverflow.com/questions/66037782/swiftui-how-do-i-lock-a-particular-view-in-portrait-mode-whilst-allowing-others
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate // preventing rotation
    
    
    var presets = Presets()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(presets)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
        
    static var orientationLock = UIInterfaceOrientationMask.all //By default you want all your views to rotate freely

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
