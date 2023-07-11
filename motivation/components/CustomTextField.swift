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
    }
}