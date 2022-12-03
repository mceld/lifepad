//
//  PresetsLib.swift
//  lifepad
//
//  Created by GCCISAdmin on 12/2/22.
//

import Foundation

struct Preset: Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    var description: String
    var image: String
    var coords: [[Int32]]
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
                            , description: dict["description"] as! String
                            , image: dict["image"] as! String
                            , coords: dict["coords"] as! [[Int32]]
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
