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
    // 4. Active client -> in trial subscription
    // 5.A Active client -> subscribed
    // 5.B Not subscribed  -> re-subscribe button
    
    @EnvironmentObject private var purchaseManager:PurchaseManager

    
    var body: some View {
        VStack(spacing: 20) {
            
            switch purchaseManager.status {
                
                case .neverConsulted:
                    NeverConsultedView(purchaseManager: purchaseManager)
                
                case .neverBought:
                    ConsultedNeverBoughtView(purchaseManager: purchaseManager)
                        
                case .activeCore:
                    VStack {
                        Spacer()
                        Text("Active Client - Core")
                            .fontWeight(.heavy)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                        Text("An active client currently in the two-week Core program.")
                            .multilineTextAlignment(.center)
                        Spacer()
                        Button(action: {
                            purchaseManager.updateClientStatus(newStatus: .inactiveSubscriptionShort)
                        }, label: {
                            Text("Fast-Forward 2 Weeks / Complete Core")
                                .foregroundColor(Color.white)
                                .padding()
                                .background(Color(red: 0, green: 0, blue: 0.5))
                                .clipShape(Capsule())
                        })
                        Spacer()
                    }
                    
                case .activeSubscription:
                    Text("active in subscription")
                    
                case .inactiveSubscriptionShort:
                    Text("Inactive client, either just finished core or was recent subcriber < 3 months ago")
                    
                case .inactiveSubscriptionLong:
                    Text("Inactive client, more than 3 months")
                
                case .graceSubscription:
                Text("Active client currently in grace period")
                    
                default:
                    Text("test")
                
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

struct NeverConsultedView: View {
    
    @ObservedObject var purchaseManager:PurchaseManager
    
    var body: some View {
        VStack {
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
                purchaseManager.updateClientStatus(newStatus: .neverBought)
                //zpurchaseManager.didConsult = true
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
        }
    }
    
}

struct ConsultedNeverBoughtView: View {
    
    @ObservedObject var purchaseManager:PurchaseManager
    
    var body: some View {
        VStack {
            Spacer()
            Text("Never Been A Client, Has Consulted")
                .fontWeight(.heavy)
                .font(.title2)
                .multilineTextAlignment(.center)
            Text("A new download that has now done one consult either here or on the website & therefore can only buy the core Restfully Care package.")
                .multilineTextAlignment(.center)
            Spacer()
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
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
