//
// LifepadApp.swift
// Main entry point for the program, defines necessary environment variables for preset library and portait lock
// SpriteKit binaries under "spritekit_binaries" are required as scaffold for any SKScene
//

// Sources
//
// Preventing rotation:
// https://stackoverflow.com/questions/66037782/swiftui-how-do-i-lock-a-particular-view-in-portrait-mode-whilst-allowing-others

import Foundation
import SwiftUI

@main
struct LifepadApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate // preventing rotation
    
    var presetsModel = PresetsModel(basicsFile: "basic_presets", shipsFile: "ship_presets", oscFile: "oscillator_presets", miscFile: "misc_presets")
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(presetsModel) // contains all preset information from plists
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.all // By default you want all your views to rotate freely

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
