import SwiftUI
import SwiftData

struct LandingPageView: View {
    @State private var navigateToMainView = false
    @State private var phoneNumber = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("TABBER")
                    .font(.largeTitle)
                    .padding()
                
                Text("Manage your receipts, debts, and more!")
                    .font(.subheadline)
                    .padding()
                
                Text("Enter Your Phone Number to Log In")
                    .font(.subheadline)
                    .padding()
                
                // Phone Number Input
                TextField("no hyphens", text: $phoneNumber)
                    .keyboardType(.phonePad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onSubmit {
                        if isValidPhoneNumber(phoneNumber) {
                            navigateToMainView = true
                        }
                    }
                
                // Navigation Link
                NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true).modelContainer(for: Item.self, inMemory: true), isActive: $navigateToMainView) {
                    EmptyView() // The NavigationLink will automatically trigger when navigateToMainView is true
                }
                .isDetailLink(false)
                
                // You could add an optional button if needed
                Button(action: {
                    if isValidPhoneNumber(phoneNumber) {
                        navigateToMainView = true
                    }
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .padding()
        }
    }
    
    // A simple phone number validation function
    func isValidPhoneNumber(_ number: String) -> Bool {
        // Basic validation for example (10 digits for US phone number)
        let phoneRegex = "^[0-9]{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: number)
    }
}

#Preview {
    LandingPageView()
}
