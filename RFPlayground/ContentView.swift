//
//  ContentView.swift
//  RFPlayground
//
//  Created by Jesus Najera Restfully on 1/12/23.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    
    @EnvironmentObject private var purchaseManager:PurchaseManager

    
    var body: some View {
        VStack(spacing: 20) {
            
            if purchaseManager.hasUnlockedPro {
                Text("Thank you for purchasing pro!")
            } else {
                Text("Products")
                
                ForEach(purchaseManager.products) { product in
                    Button(action: {

                        _ = Task<Void, Never> {
                            do {
                                try await purchaseManager.purchase(product)
                            } catch {
                                print(error)
                            }
                        }


                    }, label: {
                        Text("\(product.displayName) - \(product.displayPrice)")
                    })
                }
                
                Button(action: {
                    Task {
                        do {
                            try await AppStore.sync()
                        } catch {
                            print(error)
                        }
                    }
                }, label: {
                    Text("Restore Purchases")
                })
                
            }
            
            
        }.task {
            Task {
                do {
                    try await purchaseManager.loadProducts()
                } catch {
                    print(error)
                }
            }
        }
    }

    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
