//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Derya Antonelli on 08/08/2022.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    @State private var errorMessage = ""
    @State private var showingErrorMessage = false
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("Your total is \(order.dataModel.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                    
                }
                .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thank you!", isPresented: $showingConfirmation) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage)
        }
        .alert("", isPresented: $showingErrorMessage) {
            Button("OK") {}
        } message: {
            Text(errorMessage)
        }
    }
    
    func placeOrder() async {
        // convert object to json
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        // send data over network call
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        // run request and process the response
        let task = URLSession.shared.uploadTask(with: request, from: encoded) { data, response, error in
            if let error = error {
                errorMessage = "There was an error. Please try again"
                showingErrorMessage = true
                return
            }
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                errorMessage = "There was a server error. Please try again"
                showingErrorMessage = true
                return
            }
            if let mimeType = response.mimeType,
               mimeType == "application/json",
               let data = data {
                do {
                    let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
                    confirmationMessage = "Your order for \(decodedOrder.dataModel.quantity)x \(Order.types[decodedOrder.dataModel.type].lowercased()) cupcakes is on its way!"
                    showingConfirmation = true
                } catch {
                    errorMessage = "There was an error. Please try again"
                    showingErrorMessage = true
                }
            }
        }
        task.resume()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
