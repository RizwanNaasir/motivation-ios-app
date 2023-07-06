import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    @State private var isEditing: Bool = false
    @State private var isHighlighted: Bool = false

    var placeholder: String
    var keyboardType: UIKeyboardType
    var textContentType: UITextContentType

    var body: some View {
        TextField(placeholder, text: $text)
                .textContentType(textContentType)
                .keyboardType(keyboardType)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding()
                .overlay(
                        RoundedRectangle(cornerRadius: 8)
                                .stroke(isHighlighted ? Color.blue : Color.gray, lineWidth: 2)
                )
                .padding(.horizontal)
                .onTapGesture {
                    isHighlighted = true
                }
                .onDisappear {
                    isHighlighted = false
                }
                .onChange(of: text) { newText in
                    if newText.count > 0 {
                        isEditing = true
                    } else {
                        isEditing = false
                    }
                }
    }
}