//
//  ClipboardList.swift
//  Clippy
//
//  Created by Duc Dang on 12/4/25.
//
import SwiftUI

struct ClipboardListView: View {
    
    @ObservedObject var clipboardService = ClipboardService()
    @State private var currentId: UUID? = nil
    @State private var showClearAllConfirmation = false
    @State private var searchText: String = ""
    
    private var filteredItems: [ClippyItemModel] {
        searchText.isEmpty
            ? clipboardService.histories
            : clipboardService.histories.filter {
                $0.text.localizedCaseInsensitiveContains(searchText)
            }
    }
        
    private var pinnedItems: [ClippyItemModel] {
        filteredItems.filter { $0.isPinned };
    }
    
    private var unpinnedItems: [ClippyItemModel] {
        filteredItems.filter { !$0.isPinned };
    }
    
    
    func handleCopyToClipboard(_ text: String, _ id: UUID) {
        clipboardService.copyToClipboard(text)
        currentId = id
    }
    
    func handlePinToggle(_ id: UUID, _ isPinned: Bool) {
        clipboardService.pin(id, isPinned)
    }
    
    var body: some View {
        VStack {
            if pinnedItems.isEmpty && unpinnedItems.isEmpty {
                EmptyStateView(searchText: searchText)
            } else {
                clipboardList
            }
        }
        .searchable(text: $searchText, prompt: "Search clipboard...")
        .onAppear {
            clipboardService.startMonitoring()
        }
        .confirmationDialog(
            "Are you sure you want to clear all histories?",
            isPresented: $showClearAllConfirmation,
            titleVisibility: .visible
        ) {
            Button("Clear All", role: .destructive) {
                clipboardService.clearClipboardHistory()
            }
            Button("Cancel", role: .cancel) { }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Button("Clear All") {
                    showClearAllConfirmation = true
                }
            }
        }
    }
    
    private var clipboardList: some View {
        List {
            if !pinnedItems.isEmpty {
                Section(header: Text("📌 Pinned")) {
                    ForEach(pinnedItems) { item in
                        ClipboardItemView(
                            item: item,
                            isCopied: item.id == currentId,
                            onCopy: handleCopyToClipboard,
                            onPin: handlePinToggle
                        )
                        .listRowSeparator(.hidden)
                    }
                }
            }

            if !unpinnedItems.isEmpty {
                Section(header: Text("🗃 History")) {
                    ForEach(unpinnedItems) { item in
                        ClipboardItemView(
                            item: item,
                            isCopied: item.id == currentId,
                            onCopy: handleCopyToClipboard,
                            onPin: handlePinToggle
                        )
                        .listRowSeparator(.hidden)
                    }
                }
            }
        }
        .listStyle(.inset)
    }
}


private struct EmptyStateView: View {
    let searchText: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.on.clipboard")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray.opacity(0.5))

            Text(searchText.isEmpty ? "No clipboard history yet" : "No results found")
                .font(.headline)
                .foregroundColor(.gray)

            if !searchText.isEmpty {
                Text("Try a different keyword or clear the search.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.top, 60)
    }
}


#Preview {
    ClipboardListView()
}
