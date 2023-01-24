//
//  ContentView.swift
//  RFPlayground
//
//  Created by Jesus Najera Restfully on 1/12/23.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    
    // 1. Never been a client -> can consult or purchase care package
    // 2. Never been a client -> can purchase care package
    // 3. Active client -> in care package
    
    @EnvironmentObject private var purchaseManager:PurchaseManager

    
    var body: some View {
        VStack(spacing: 20) {
            
            if !purchaseManager.didConsult {
                Spacer()
                Text("Never Been A Client Nor Consulted")
                    .fontWeight(.heavy)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                Text("A new download that did not consult on the website & therefore has access to scheduling a single consult. \n \n Or of course they immediately buy the core Restfully Care package.")
                    .multilineTextAlignment(.center)
                Spacer()
                Button(action: {
                    purchaseManager.didConsultStorage = true
                    purchaseManager.didConsult = true
                }, label: {
                    Text("Sign Up For Consult")
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color(red: 0, green: 0, blue: 0.5))
                        .clipShape(Capsule())
                })
                ForEach(purchaseManager.products) { product in
                    
                    if product.id == "03" {
                        Button(action: {

                            _ = Task<Void, Never> {
                                do {
                                    try await purchaseManager.purchase(product)
                                } catch {
                                    print(error)
                                }
                            }


                        }, label: {
                            
                            Text("Restfully Care - \(product.displayPrice)")
                                .foregroundColor(Color.white)
                                .padding()
                                .background(Color(red: 0, green: 0.5, blue: 0))
                                .clipShape(Capsule())
                        })
                    }
                    
                }
                Spacer()
            } else {
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
