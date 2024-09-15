//RECEIPT


//GROUP

import SwiftUI

struct SecondTabView: View {
    var body: some View {
        VStack {
            Text("Home Screen")
                .font(.largeTitle)
                .padding()
            Image(systemName: "house.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
        }
    }
}

#Preview {
    SecondTabView()
}

