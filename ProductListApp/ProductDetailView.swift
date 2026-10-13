//
//  ProductDetailView.swift
//  ProductListApp
//
//  Created by Jignesh Chitaliya on 12/10/26.
//

import SwiftUI
import Observation

struct ProductDetailView: View {
    @Bindable var viewModel: ProductViewModel
    let product: Product

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Hero Image
                AsyncImage(url: URL(string: product.thumbnail)) { image in
                    image.resizable()
                         .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(maxWidth: .infinity, maxHeight: 300)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top) {
                        Text(product.title)
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        Text("$\(product.price, specifier: "%.2f")")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }

                    Divider()

                    Text("Description")
                        .font(.headline)
                    
                    Text(product.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.toggleSave(product: product)
                } label: {
                    Image(systemName: viewModel.isSaved(product: product) ? "bookmark.fill" : "bookmark")
                        .foregroundColor(viewModel.isSaved(product: product) ? .blue : .primary)
                }
            }
        }
    }
}

