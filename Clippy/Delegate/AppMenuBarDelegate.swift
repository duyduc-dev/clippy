//
//  AppMenuBarDelegate.swift
//  Clippy
//
//  Created by Duc Dang on 20/4/25.
//
import SwiftUI
import HotKey

class AppMenuBarDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover = NSPopover()
    
    var hotKey: HotKey?
    
    override init() {
        super.init()
        
        EventDispatcher.Instanse.observeEvent(name: .ClippyItemCopied) { (item: ClippyItemModel) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.togglePopover(nil)
            }
        }
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the popover content
        let popoverView = PopoverContentView()
        popover.contentSize = NSSize(width: 600, height: 400)
        popover.behavior = .transient // Closes when clicking outside
        popover.contentViewController = NSHostingController(rootView: popoverView)

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem.button {
            button.title = "CP"
            button.font = NSFont.systemFont(ofSize: 12, weight: .bold)
            button.action = #selector(togglePopover(_:))
            button.target = self
        }
        
        // Register Hotkey: Cmd + Shift + P
        hotKey = HotKey(key: .v, modifiers: [.command, .shift])
        hotKey?.keyDownHandler = { [weak self] in
            self?.togglePopover(nil)
        }
        
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                popover.contentViewController?.view.window?.becomeKey()
            }
        }
    }
    
}

