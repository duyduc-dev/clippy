//
//  ClipboardService.swift
//  Clippy
//
//  Created by Duc Dang on 12/4/25.
//
import Foundation
import AppKit

class ClipboardService: ObservableObject {
    static let Instance = ClipboardService()
    
    private let storageService = ClipboardStorageService()

    private var timer: Timer?
    private var lastChangeCount: Int = NSPasteboard.general.changeCount
    
    @Published var histories: [ClippyItemModel] = [] {
        didSet {
            storageService.save(histories)
        }
    }
    
    init() {
        histories = storageService.load()
    }
    
    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let pasteboard = NSPasteboard.general
            if pasteboard.changeCount != self.lastChangeCount {
                self.lastChangeCount = pasteboard.changeCount
                if let copied = pasteboard.string(forType: .string), !copied.isEmpty {
                    let item = ClippyItemModel(text: copied, timestamp: Date())
                    DispatchQueue.main.async {
                        if !self.histories.contains(where: { $0.text == item.text }) {
                            self.histories.insert(item, at: 0)
                        }
                    }
                }
            }
        }
    }
    
    func stopMonitoring() {
       timer?.invalidate()
       timer = nil
   }
    
    func clearClipboardHistory() {
        histories.removeAll(where: {item in !item.isPinned})
    }
    
    func copyToClipboard(_ text: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
    }
    
    func getCurrentClipboardText() -> String? {
        return NSPasteboard.general.string(forType: .string)
    }
    
    func pin(_ id: UUID, _ isPin: Bool) {
        if let index = histories.firstIndex(where: { $0.id == id }) {
            let item = histories[index]
            item.isPinned = isPin
            histories[index] = item
        }
    }
}
