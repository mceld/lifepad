import Foundation

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
