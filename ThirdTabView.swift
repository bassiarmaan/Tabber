import SwiftUI

struct ThirdTabView: View {
    @ObservedObject var sharedDataModel: SharedDataModel
    @State private var searchText: String = ""
    @State private var selectedName: String? = nil // Track only one selected name
    @State private var enteredAmount: String = "" // Track entered amount
    let circleSize: CGFloat = 90 // Circle size for buttons

    var body: some View {
        VStack {
            // Search Bar
            TextField("Search contacts", text: $searchText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

            VStack {
                // List of Contacts with checkmarks
                List(filteredContacts, id: \.1) { name, phoneNumber in
                    Button(action: {
                        // Select only one person
                        if selectedName == name {
                            selectedName = nil // Deselect if tapped again
                            enteredAmount = ""
                        } else {
                            selectedName = name // Select new person
                            enteredAmount = "" // Reset amount when switching to a new person
                        }
                    }) {
                        HStack {
                            // Checkmark circle
                            Image(systemName: selectedName == name ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selectedName == name ? .blue : .gray)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(name)
                                    .font(.headline)
                                    .padding(.bottom, 2)
                                    .foregroundColor(.primary)
                                
                                Text(phoneNumber)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 1)
                    }
                    
                    .padding(.vertical, 10) // Fixed vertical padding to ensure consistency
                    .frame(minHeight: 60) // Minimum height for each row to ensure consistency
                }
                .background(Color.white)
                .scrollContentBackground(.hidden)
                .cornerRadius(10)
                .padding(.bottom, 10) // Reduce bottom padding
                
                Spacer()

                // Static bottom UI with amount input and request button
                HStack {
                    // Input box for amount
                    TextField("Enter Amount", text: $enteredAmount)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .frame(width: 200) // Adjust width for proper alignment

                    Spacer()

                    // Request button
                    Button(action: {
                        // Action for the Request button
                        if let selectedName = selectedName, !enteredAmount.isEmpty {
                            print("Request \(enteredAmount) from \(selectedName)")
                        }
                    }) {
                        Text("Request")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.purple)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20) // Bring the buttons closer to the bottom of the list
            }
        }
    }
    
    // Filter contacts based on search text
    var filteredContacts: [(String, String)] {
        if searchText.isEmpty {
            return sharedDataModel.fetchPeopleContactInfo()
        } else {
            return sharedDataModel.fetchPeopleContactInfo().filter {
                $0.0.lowercased().contains(searchText.lowercased()) || $0.1.contains(searchText)
            }
        }
    }
}

#Preview {
    ThirdTabView(sharedDataModel: SharedDataModel())
}
