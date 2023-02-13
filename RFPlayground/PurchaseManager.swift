//
//  PurchaseManager.swift
//  RFPlayground
//
//  Created by Jesus Najera Restfully on 1/23/23.
//

import Foundation
import SwiftUI
import StoreKit

enum ClientStatus: String, Codable {
    case neverConsulted,
         neverBought,
         activeCore,
         activeSubscription,
         inactiveSubscriptionShort,
         inactiveSubscriptionLong,
         graceSubscription
}

@MainActor
class PurchaseManager: ObservableObject {
    
    @AppStorage("statusStorage") var statusStorage:ClientStatus = .neverConsulted
    @AppStorage("didConsult") var didConsultStorage: Bool = false
    @AppStorage("didPurchase") var didPurchaseStorage: Bool = false
    @AppStorage("purchaseDate") var datePurchased:String = Date().ISO8601Format()
    @AppStorage("purchaseSubscription") var dateSubscribed:String = Date().ISO8601Format()
    @AppStorage("didSubscribe") var didSubscribeStorage: Bool = false
    
    private let productIds = ["01","03"]
    private var productsLoaded = false
    private var updates: Task<Void, Never>? = nil
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs = Set<String>()
    @Published var didConsult = false
    @Published var status:ClientStatus = .neverConsulted
    
    init() {
        
        status = statusStorage
        
        updates = observeTransactionUpdates()
        if !didConsultStorage && !didPurchaseStorage {
            status = .neverConsulted
        } else if didConsultStorage && !didPurchaseStorage {
            status = .neverBought
        }
        
        //let promoOffers = await storeProduct.getEligiblePromotionalOffers()
        
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
            if product.id == "03" {
                didPurchaseStorage = true
                datePurchased = Date().ISO8601Format()
                updateClientStatus(newStatus: .activeCore)
            } else if product.id == "01" {
                didSubscribeStorage = true
                dateSubscribed = Date().ISO8601Format()
                updateClientStatus(newStatus: .activeSubscription)
            }
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
            
            print(transaction.productID)
            
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
            
        }
    }
    
    func updateClientStatus(newStatus:ClientStatus) {
        status = newStatus
        statusStorage = status
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await verficationResult in Transaction.updates {
                // using verificationResult direclt would be better, but this works for tutorial
                await self.updatePurchasedProducts()
            }
        }
    }
    
    
    
    // Date Functions
    
    // Initialize last 30 days, 15 minute intervals tuple
    func initializeLastThirtyDaysFifteenMinTuple() -> [(sectionTime: Date, sectionStatus: Bool)] {
        // Current Calendar initialize
        let calendar = Calendar.current
        // Grab Now()'s minutes
        let minutes = calendar.component(.minute, from: Date())
        // Round minutes to the most recent 5 minute mark
        let roundedMinutes = minutes - (minutes % 5)
        // Set rounded date
        let roundedDate = calendar.date(bySetting: .minute, value: roundedMinutes, of: Date())!
        // Create date 30 days ago
        let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: roundedDate)!
        let thirtyDaysAgoTimes = (0...2879).map { calendar.date(byAdding: .minute, value: $0*15, to: thirtyDaysAgo)! }
        let setTuple = thirtyDaysAgoTimes.map { (sectionTime: $0, sectionStatus: false) }
        print(setTuple)
        return setTuple
    }
    
    // Formatting
    func check20Secs(purchaseDate:String) -> Bool {
        let dateFormatter = ISO8601DateFormatter()
        let purchaseDateFormatted = dateFormatter.date(from: purchaseDate)
        let calendar = Calendar.current
        let currentDateFormatted = dateFormatter.date(from: Date().ISO8601Format())
        let seconds = calendar.dateComponents([.second], from: purchaseDateFormatted!, to: currentDateFormatted!).second
        
        // More than 20 secs have passed, throw ask to subscribe
        if seconds! >= 20 {
            return true
        } else {
            return false
        }
    }
    
    func hoursLater(startDate: Date, hoursLater: Int) -> String {
        let newFormat = DateFormatter()
        newFormat.dateFormat = "h a"
        let newDate = Calendar.current.date(byAdding: .hour, value: hoursLater, to: startDate)!
        
        return newFormat.string(from: newDate)
    }
    
    
    
    
}
