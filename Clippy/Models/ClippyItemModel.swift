//
//  ClippyItemModel.swift
//  Clippy
//
//  Created by Duc Dang on 12/4/25.
//
import Foundation

class ClippyItemModel: Identifiable, Hashable, Equatable, Codable {
    let id: UUID
    let text: String
    let timestamp: Date
    
    var isPinned: Bool = false

    init(id: UUID = UUID(), text: String, timestamp: Date) {
        self.id = id
        self.text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        self.timestamp = timestamp
    }

    static func == (lhs: ClippyItemModel, rhs: ClippyItemModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
