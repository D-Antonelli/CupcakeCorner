//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Derya Antonelli on 08/08/2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var order = Order()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.dataModel.type) {
                        ForEach(Order.types.indices) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    Stepper("Number of cakes: \(order.dataModel.quantity)", value: $order.dataModel.quantity, in: 3...20)
                }
                
                Section {
                    Toggle("Any special requests?", isOn: $order.dataModel.specialRequestEnabled.animation())
                    
                    if order.dataModel.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $order.dataModel.extraFrosting)

                        Toggle("Add extra sprinkles", isOn: $order.dataModel.addSprinkles)
                    }
                }
                
                Section {
                    NavigationLink {
                        AddressView(order: order)
                    } label: {
                        Text("Delivery details")
                    }
                }
            }
            
            .navigationTitle("Cupcake Corner")
        }
        
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
