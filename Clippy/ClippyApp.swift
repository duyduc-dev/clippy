//
//  ClippyApp.swift
//  Clippy
//
//  Created by Duc Dang on 12/4/25.
//

import SwiftUI

@main
struct ClippyApp: App {
    @NSApplicationDelegateAdaptor(AppMenuBarDelegate.self) var appMenuBarDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                
        }
        
    }
}

