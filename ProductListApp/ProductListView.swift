//
//  ProductListView.swift
//  ProductListApp
//
//  Created by Jignesh Chitaliya on 12/10/26.
//


import SwiftUI

struct ProductListView: View {
    @State var viewModel = ProductViewModel()
    @State private var selectedTab = 0 // 0 = All, 1 = Saved

    var body: some View {
        NavigationStack {
            VStack {
                Picker("List Type", selection: $selectedTab) {
                    Text("All Products").tag(0)
                    Text("Saved").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()

                List {
                    let displayList = selectedTab == 0 ? viewModel.allProducts : viewModel.savedProducts
                    
                    ForEach(displayList) { product in
                        NavigationLink(destination: ProductDetailView(viewModel: viewModel, product: product)) {
                            ProductRowView(product: product)
                                .onAppear {
                                    // Only trigger pagination on the "All" tab
                                    if selectedTab == 0 {
                                        viewModel.loadMore(currentItem: product)
                                    }
                                }
                        }
                    }
                    
                    // Loading Indicator at the bottom of the list
                    if viewModel.isLoading && selectedTab == 0 {
                        HStack {
                            Spacer()
                            ProgressView("Loading more...")
                                .padding()
                            Spacer()
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Products")
        }
    }
}

// Reusable UI component for the List rows
struct ProductRowView: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: product.thumbnail)) { image in
                image.resizable()
                     .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 70, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.headline)
                    .lineLimit(1)
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

