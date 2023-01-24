//
//  PurchaseManager.swift
//  RFPlayground
//
//  Created by Jesus Najera Restfully on 1/23/23.
//

import Foundation
import SwiftUI
import StoreKit



@MainActor
class PurchaseManager: ObservableObject {
    
    @AppStorage("didConsult") var didConsultStorage: Bool = false
    
    private let productIds = ["01","03"]
    private var productsLoaded = false
    private var updates: Task<Void, Never>? = nil
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs = Set<String>()
    @Published var didConsult = false
    
    init() {
        updates = observeTransactionUpdates()
        didConsult = didConsultStorage
    }
    
    deinit {
        updates?.cancel()
    }
    
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
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await verficationResult in Transaction.updates {
                // using verificationResult direclt would be better, but this works for tutorial
                await self.updatePurchasedProducts()
            }
        }
    }
    
}
