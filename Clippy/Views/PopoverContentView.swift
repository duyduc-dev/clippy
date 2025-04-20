//
//  PopoverContentView.swift
//  Clippy
//
//  Created by Duc Dang on 20/4/25.
//
import SwiftUI

struct PopoverContentView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            ClipboardListView()
            Spacer()
            Divider()
        }
        .padding()
        .frame(width: 600, height: 400)
    }
}
