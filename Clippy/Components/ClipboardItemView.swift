//
//  ClipboardItem.swift
//  Clippy
//
//  Created by Duc Dang on 12/4/25.
//
import SwiftUI

struct ClipboardItemView: View {
    let item: ClippyItemModel
    var isCopied: Bool = false

    var onCopy: ((_ text: String, _ id: UUID) -> Void)?
    var onPin: ((_ id: UUID, _ pin: Bool) -> Void)?
    
    private var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: item.timestamp)
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(item.text)
                        .lineLimit(3)
                        .truncationMode(.tail)
                        .font(.body)
                        .foregroundColor(.primary)

                    Spacer()

                    if isCopied {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .transition(.scale)
                    }
                }

                // Timestamp Display
                Text(formattedTimestamp)
                    .font(.footnote)
                    .foregroundColor(.gray)

                HStack {
                    Button(action: {
                        onCopy?(item.text, item.id)
                    }) {
                        Label("Copy", systemImage: "doc.on.doc")
                    }

                    Button(action: {
                        onPin?(item.id, !item.isPinned)
                    }) {
                        Label(item.isPinned ? "Unpin" : "Pin",
                              systemImage: item.isPinned ? "pin.slash" : "pin")
                    }
                }
                .buttonStyle(.borderless)
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.secondary.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isCopied ? Color.green.opacity(0.5) : Color.clear, lineWidth: 1)
            )
            .animation(.default, value: isCopied)
        }
        
}

#Preview {
    ClipboardItemView(
        item: .init(
            text: "Hello World Hello World Hello World Hello World Hello World Hello World Hello World",
            timestamp: Date()
        ),
        isCopied: true
    )
}
