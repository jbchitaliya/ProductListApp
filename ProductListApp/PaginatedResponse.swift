//
//  PaginatedResponse.swift
//  ProductListApp
//
//  Created by Jignesh Chitaliya on 12/10/26.
//


import Foundation

// Replace properties to match your actual API JSON schema
struct PaginatedResponse: Codable {
    let products: [Product]
    let total: Int
    let skip: Int
    let limit: Int
}

struct Product: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let thumbnail: String // URL string for the product image
}
