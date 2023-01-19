//
//  ContentView.swift
//  RFPlayground
//
//  Created by Jesus Najera Restfully on 1/12/23.
//

import SwiftUI
import StoreKit

@MainActor
class PurchaseManager: ObservableObject {
    
    private let productIds = ["01","03"]
    private var productsLoaded = false
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs = Set<String>()
    
    var hasUnlockedPro: Bool {
        return !self.purchasedProductIDs.isEmpty
    }
    
    func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        self.products = try await Product.products(for: productIds)
        self.productsLoaded = true
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
            await self.updatePurchasedProducts()
        case .success(.unverified(_, _)):
            break
        case .userCancelled:
            break
        case .pending:
            break
        @unknown default:
            break
        }
        
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
            
        }
    }
    
}



struct ContentView: View {
    
    @EnvironmentObject private var purchaseManager:PurchaseManager

    
    var body: some View {
        VStack(spacing: 20) {
            
            
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
