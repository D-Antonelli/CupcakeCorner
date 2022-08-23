//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Derya Antonelli on 08/08/2022.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: Order
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.dataModel.name)
                TextField("Street Address", text: $order.dataModel.streetAddress)
                TextField("City", text: $order.dataModel.city)
                TextField("Zip", text: $order.dataModel.zip)
            }

            Section {
                NavigationLink {
                    CheckoutView(order: order)
                } label: {
                    Text("Check out")
                }
            }
            .disabled(order.dataModel.hasValidAddress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
