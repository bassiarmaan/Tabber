import SwiftUI
import SwiftData

struct LandingPageView: View {
    @State private var navigateToMainView = false
    @State private var phoneNumber = ""

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(gradient: Gradient(colors: [.green, .blue]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack {
                    Spacer()

                    // Title with bold font and improved padding
                    Text("Welcome to Tabber!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.bottom, 10)

                    // Subtitle with a lighter color for contrast
                    Text("Manage your receipts, debts, and more")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.85))
                        .padding(.bottom, 20)

                    Text("Enter Your Phone Number to Log In:")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.85))
                        .padding(.bottom, 20)

                    // Phone Number Input with padding and border styling
                    TextField("no hyphens", text: $phoneNumber)
                        .keyboardType(.phonePad)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                        .shadow(radius: 3)
                        .onSubmit {
                            if isValidPhoneNumber(phoneNumber) {
                                navigateToMainView = true
                            }
                        }

                    // Navigation Link
                    NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true).modelContainer(for: Item.self, inMemory: true), isActive: $navigateToMainView) {
                        EmptyView()
                    }

                    // Continue button with modern design
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
                            .background(LinearGradient(gradient: Gradient(colors: [.green, .blue]),
                                                       startPoint: .leading,
                                                       endPoint: .trailing))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.horizontal, 30)
                    }
                    .padding(.top, 20)

                    Spacer()
                }
            }
            .navigationBarHidden(true)
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
