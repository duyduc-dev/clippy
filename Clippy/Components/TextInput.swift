import SwiftUI

struct TextInput: View {
    @Binding var value: String
    
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    TextInput(value: .constant(""))
}
