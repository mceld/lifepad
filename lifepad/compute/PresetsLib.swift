//
//  PresetsLib.swift
//  lifepad
//
//  Created by GCCISAdmin on 12/2/22.
//

import Foundation

struct Preset {
    var name: String
    var coords: [[Int]]
}

class Presets: ObservableObject {
    
    @Published var data: [Preset] = []
    
    init() {
        if let path = Bundle.main.path(forResource: "presets", ofType: "plist") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let tempDict = try PropertyListSerialization.propertyList(from: data, format: nil) as! [String:Any]
                let tempArray = tempDict["presets"] as! Array<[String:Any]>
                var tempPresets: [Preset] = []
                
                for dict in tempArray {
                    tempPresets.append(
                        Preset(
                            name: dict["name"] as! String
                            , coords: dict["coords"] as! [[Int]]
                        )
                    )
                }
                
                self.data = tempPresets
            } catch {
                print(error)
            }
        }
    }
}
