import SwiftUI

struct BottomSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var safeAreaInsets = EdgeInsets()

    var body: some View {
        VStack {
            Spacer()
            GoalsView()
                    .padding(.top, safeAreaInsets.top)
                    .padding(.bottom, safeAreaInsets.bottom)
                    .padding(.horizontal)
        }
    }
}


