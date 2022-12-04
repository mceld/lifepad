import Foundation
import SwiftUI


@main
struct LifepadApp: App {
    // https://stackoverflow.com/questions/66037782/swiftui-how-do-i-lock-a-particular-view-in-portrait-mode-whilst-allowing-others
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate // preventing rotation
    
//    var basic_presets = Presets(filename: "basic_presets")
//    var ship_presets = Presets(filename: "ship_presets")
//    var oscillator_presets = Presets(filename: "oscillator_presets")
//    var misc_presets = Presets(filename: "misc_presets")
    
    var presetsModel = PresetsModel(basicsFile: "basic_presets", shipsFile: "ship_presets", oscFile: "oscillator_presets", miscFile: "misc_presets")
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(presetsModel)
//                .environmentObject(basic_presets)
//                .environmentObject(ship_presets)
//                .environmentObject(oscillator_presets)
//                .environmentObject(misc_presets)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
        
    static var orientationLock = UIInterfaceOrientationMask.all //By default you want all your views to rotate freely

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
