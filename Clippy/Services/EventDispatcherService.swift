//
//  EventDispatcherService.swift
//  Clippy
//
//  Created by Duc Dang on 20/4/25.
//

import Foundation

protocol EventData {
    // The protocol doesn't need to require any specific properties or methods
    // You can extend it in the future for more specialized event data
}

class EventDispatcher {
    
    static let Instanse = EventDispatcher()  // Singleton instance
    
    private init() {}
    
    // Dispatch an event with structured data
    func dispatchEvent<T: EventData>(name: Notification.Name, data: T) {
        NotificationCenter.default.post(name: name, object: data)
    }
    
    // Observe an event with structured data
    func observeEvent<T: EventData>(name: Notification.Name, handler: @escaping (T) -> Void) {
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: .main) { notification in
            if let data = notification.object as? T {
                handler(data)
            }
        }
    }
    
    // Remove observer for a specific event
    func removeObserver(name: Notification.Name) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }
    
    // Remove all observers
    func removeAllObservers() {
        NotificationCenter.default.removeObserver(self)
    }
}
