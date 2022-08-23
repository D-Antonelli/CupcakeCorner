//
//  Order.swift
//  CupcakeCorner
//
//  Created by Derya Antonelli on 08/08/2022.
//

import Foundation
import SwiftUI

class Order: ObservableObject, Codable {
    
    enum CodingKeys: CodingKey {
        case dataModel
    }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    struct DataModel: Codable {
        var type = 0
        var quantity = 3
        var extraFrosting = false
        var addSprinkles = false
        
        var specialRequestEnabled = false {
            didSet {
                if specialRequestEnabled == false {
                    extraFrosting = false
                    addSprinkles = false
                }
            }
            
        }
        
        var name = ""
        var streetAddress = ""
        var city = ""
        var zip = ""
        
        var hasValidAddress: Bool {
            if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return false
            }
            
            return true
        }
        
        var cost: Double {
            // $2 per cake
            var cost = Double(quantity) * 2
            
            // complicated cakes cost more
            cost += (Double(type) / 2)
            
            // $1/cake for extra frosting
            if extraFrosting {
                cost += Double(quantity)
            }
            
            // $0.50/cake for sprinkles
            if addSprinkles {
                cost += Double(quantity) / 2
            }
            
            return cost
        }
        
    }
    
    @Published var dataModel = DataModel()
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(dataModel, forKey: .dataModel)
    }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        dataModel = try container.decode(DataModel.self, forKey: .dataModel)
    }
    

    
    init() { }
}
