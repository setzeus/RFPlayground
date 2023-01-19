//
//  RFPlaygroundApp.swift
//  RFPlayground
//
//  Created by Jesus Najera Restfully on 1/12/23.
//

import SwiftUI

@main
struct RFPlaygroundApp: App {
    
    @StateObject private var purchaseManager = PurchaseManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(purchaseManager).task {
                await purchaseManager.updatePurchasedProducts()
            }
        }
    }
}
