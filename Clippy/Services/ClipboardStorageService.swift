//
//  ClipboardStorageService.swift
//  Clippy
//
//  Created by Duc Dang on 12/4/25.
//

import Foundation

class ClipboardStorageService {
    private let storageKey = "clipboard_history_clippy"
    
    func save(_ items: [ClippyItemModel]) {
        do {
            let data = try JSONEncoder().encode(items)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("❌ Failed to save clipboard history: \(error)")
        }
    }
    
    func load() -> [ClippyItemModel] {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return [] }
        do {
            return try JSONDecoder().decode([ClippyItemModel].self, from: data)
        } catch {
            print("❌ Failed to load clipboard history: \(error)")
            return []
        }
    }
    
    func clear() {
        UserDefaults.standard.removeObject(forKey: storageKey)
    }

}
