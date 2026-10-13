//
//  ProductViewModel.swift
//  ProductListApp
//
//  Created by Jignesh Chitaliya on 12/10/26.
//


import Foundation
import Observation

@Observable
class ProductViewModel {
    var allProducts: [Product] = []
    var savedProducts: [Product] = [] 
    var isLoading = false
    var errorMessage: String? = nil

    // Pagination state
    private var currentPage = 0
    private let limit = 10
    private var totalProducts = 0
    private var hasMorePages = true
    
    // Replace with your provided API URL
    private let apiBaseURL = "https://dummyjson.com/products"
    
    init() {
        Task {
            await fetchProducts()
        }
    }
    
    func fetchProducts() async {
        // Prevent overlapping requests or fetching if all data is loaded
        guard !isLoading && hasMorePages else { return }
        
        isLoading = true
        errorMessage = nil
        
        let skip = currentPage * limit
        let urlString = "\(apiBaseURL)?limit=\(limit)&skip=\(skip)"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(PaginatedResponse.self, from: data)
            
            allProducts.append(contentsOf: response.products)
            totalProducts = response.total
            currentPage += 1
            
            if allProducts.count >= totalProducts {
                hasMorePages = false
            }
        } catch {
            errorMessage = "Failed to load products: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // Triggers network call when scrolling nears the bottom of the list
    func loadMore(currentItem item: Product) {
        let thresholdIndex = allProducts.index(allProducts.endIndex, offsetBy: -3)
        if allProducts.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            Task {
                await fetchProducts()
            }
        }
    }
    
    // MARK: - Saved/Bookmark Logic
    func toggleSave(product: Product) {
        if isSaved(product: product) {
            savedProducts.removeAll { $0.id == product.id }
        } else {
            savedProducts.append(product)
        }
    }
    
    func isSaved(product: Product) -> Bool {
        savedProducts.contains { $0.id == product.id }
    }
}

