import SwiftUI

struct FourthTabView: View {
    @ObservedObject var sharedDataModel: SharedDataModel
    @State private var searchText: String = ""
    @State private var selectedNames: Set<String> = [] // Track selected names
    @State private var enteredAmounts: [String: String] = [:] // Track entered amounts for each contact
    @State private var totalAmount: String = "" // Total amount to be split

    var body: some View {
        VStack {
            // Search Bar
            TextField("Search contacts", text: $searchText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

            VStack {
                // List of Contacts with checkmarks and amount input boxes
                List(filteredContacts, id: \.1) { name, phoneNumber in
                    HStack {
                        Button(action: {
                            if selectedNames.contains(name) {
                                // Deselect the item and reset the value to 0
                                selectedNames.remove(name)
                                enteredAmounts[name] = "0" // Reset amount to 0
                            } else {
                                // Select the item
                                selectedNames.insert(name)
                            }
                        }) {
                            HStack {
                                // Checkmark circle
                                Image(systemName: selectedNames.contains(name) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedNames.contains(name) ? .blue : .gray)

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

                        Spacer()

                        // Only show amount box when selected
                        if selectedNames.contains(name) {
                            TextField("Amount", text: Binding(
                                get: { enteredAmounts[name] ?? "" },
                                set: { enteredAmounts[name] = $0 }
                            ))
                            .keyboardType(.decimalPad)
                            .padding(10)
                            .frame(width: 100)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                        }
                    }
                    .padding(.vertical, 10) // Fixed vertical padding to ensure consistency
                    .frame(minHeight: 60) // Minimum height for each row to ensure consistency
                }
                .background(Color.white)
                .scrollContentBackground(.hidden)
                .cornerRadius(10)
                .padding(.bottom, 10) // Reduce bottom padding

                Spacer()

                // HStack for Even Split and Request button
                HStack(spacing: 20) {
                    // Enter Total Amount Box
                    TextField("Amount", text: $totalAmount)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                    // Even Split button
                    Button(action: {
                        if let total = Double(totalAmount), !selectedNames.isEmpty {
                            let splitAmount = total / Double(selectedNames.count)
                            for name in selectedNames {
                                enteredAmounts[name] = String(format: "%.2f", splitAmount)
                            }
                        }
                    }) {
                        Text("Even Split")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }

                    // Request button
                    Button(action: {
                        // Iterate over selected names
                        for name in selectedNames {
                            // Check if a valid amount is entered for each person
                            if let amountStr = enteredAmounts[name], let amount = Double(amountStr) {
                                // Find the index of the person in the peopleDebt array
                                if let index = sharedDataModel.peopleDebt.firstIndex(where: { $0.0 == name }) {
                                    // Update the debt by adding the amount entered
                                    sharedDataModel.peopleDebt[index].1 += amount
                                    print("New value for \(name): \(sharedDataModel.peopleDebt[index].1)")
                                } else {
                                    // If the person isn't already in the debt list, add them
                                    sharedDataModel.peopleDebt.append((name, amount))
                                    print("Added new entry for \(name): \(amount)")
                                }
                            } else {
                                print("Invalid or no amount entered for \(name)")
                            }
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
