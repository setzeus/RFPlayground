//
//  ContentView.swift
//  RFPlayground
//
//  Created by Jesus Najera Restfully on 1/12/23.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    
    let productIds = ["01","03"]

    @State private var products: [Product] = []

    //let products = try await Product.products(for: productIds)

    
    var body: some View {
        VStack(spacing: 20) {
            Text("Products")
            ForEach(self.products) { product in
                Button(action: {
                    // do nothing for now
                }, label: {
                    Text("\(product.displayName) - \(product.displayPrice)")
                })
            }
        }.task {
            do {
                try await self.loadProducts()
            } catch {
                print(error)
            }
        }
    }
    
    private func loadProducts() async throws {
        self.products = try await Product.products(for: productIds)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
