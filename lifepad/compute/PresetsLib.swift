//
// PresetsLib.swift
// Responsible for loading all preset plist files from the filesystem
// Arranges Preset structs in a model that can broadcast its state to the rest of the app
//

// Presets held in the following plist files
// basic_presets.plist
// ship_presets.plist
// oscillator_presets.plist
// misc_presets.plist

import Foundation

// Represents one preset in the Library list
struct Preset: Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    var description: String
    var image: String
    var coords: [[Int32]]
}

// Stores all plist preset information in one model
class PresetsModel: ObservableObject {
    @Published var basics: Presets
    @Published var ships: Presets
    @Published var oscillators: Presets
    @Published var misc: Presets
    
    init(basicsFile: String, shipsFile: String, oscFile: String, miscFile: String) {
        self.basics = Presets(filename: basicsFile)
        self.ships = Presets(filename: shipsFile)
        self.oscillators = Presets(filename: oscFile)
        self.misc = Presets(filename: miscFile)
    }
}

// Constructs a Presets object (wrapper for a list of Presets) that can be used as fields in the model
class Presets {
    
    @Published var data: [Preset] = []
    
    init(filename: String) {
        if let path = Bundle.main.path(forResource: filename, ofType: "plist") {
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
