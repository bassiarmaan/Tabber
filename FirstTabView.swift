import SwiftUI

import SwiftUI

class SharedDataModel: ObservableObject {
    @Published var peopleDebt: [(String, Double)] = [
        ("Kevin", 81.12),
        ("Andy", 15.65),
        ("Nikhil", -279.08),
        ("Scott", 73.45),
        ("Patrick", -64.51),
        ("Will", 39.93)
    ]
    
    @Published var peopleContactInfo: [(String, String)] = [
        ("Kevin", "123-456-7890"),
        ("Andy", "987-654-3210"),
        ("Nikhil", "555-123-4567"),
        ("Scott", "555-987-6543"),
        ("Patrick", "444-555-6666"),
        ("Will", "011-222-3333"),
        ("Armaan", "111-222-3333"),
        ("Logan", "211-222-3333"),
        ("Veda", "311-222-3333"),
        ("Victor", "411-222-3333")
    ]
    
    @Published var personImages: [String: (String, String)] = [
         "Andy": ("andy", "Hungry"),
         "Scott": ("raghav", "Stingiest"),
         "Will": ("winsto", "Richest")
     ]

    var debtAmount: Double {
        // Calculate total debt amount
        peopleDebt.map { $0.1 }.reduce(0, +)
    }

    // Fetch event items
    func fetchEventItems() -> [(String, String)] {
        return [
            ("Pizza @ Dominos", "$81.12"),
            ("HackMIT RedBull", "$15.65"),
            ("Train Ticket", "$279.08"),
            ("Dinner @ Shake Shack", "$73.45"),
            ("Uber", "$64.51"),
            ("Lyft", "$39.93"),
            ("Burgers", "$23.40")
        ]
    }

    // Fetch people and their debts
    func fetchPeopleDebt() -> [(String, String)] {
        return peopleDebt.map { ($0.0, String(format: "%.2f", $0.1)) }
    }
    
    // Fetch contact information
    func fetchPeopleContactInfo() -> [(String, String)] {
        return peopleContactInfo
    }
    
    // Reduce debt for selected people
    func reduceDebt(for selectedNames: Set<String>) {
        for i in 0..<peopleDebt.count {
            if selectedNames.contains(peopleDebt[i].0) {
                peopleDebt[i].1 = 0 // Reset the debt to 0 for the selected people
            }
        }
    }
}



struct FirstTabView: View {
    // Use @StateObject to create an instance of the shared data model
    @ObservedObject var sharedDataModel: SharedDataModel

    var body: some View {
        NavigationView {
            VStack {
                // Use NavigationLink to navigate to the second view
                NavigationLink(destination: SecondView(sharedDataModel: sharedDataModel)) {
                    Text("DEBT: $\(abs(sharedDataModel.debtAmount), specifier: "%.2f")")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(sharedDataModel.debtAmount >= 0 ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                Spacer()
                
                Text("EVENT HISTORY")
                    .font(.largeTitle)

                VStack {
                    List(sharedDataModel.fetchEventItems(), id: \.0) { item, detail in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(item)
                                .font(.headline)
                                .padding(.bottom, 2)
                            
                            Text(detail)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 2)
                    }
                    .frame(height: 500)
                    .background(Color.white)
                    .scrollContentBackground(.hidden)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)

                    Spacer()
                }
                .background(Color.white)
            }
            .background(Color.white)
        }
    }
}

#Preview {
    FirstTabView(sharedDataModel: SharedDataModel())
}

struct SecondView: View {
    @ObservedObject var sharedDataModel: SharedDataModel
    @State private var selectedNames: Set<String> = [] // State variable to track selected names
    let circleSize: CGFloat = 90 // Set the circle size directly
    let medalRecipients: Set<String> = ["Andy", "Scott", "Will"] // Names with medals

    var body: some View {
        VStack {
            // Display the debt amount
            Text("DEBT: $\(abs(sharedDataModel.debtAmount), specifier: "%.2f")")
                .padding()
                .frame(maxWidth: .infinity)
                .background(sharedDataModel.debtAmount >= 0 ? Color.green : Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
            
            Spacer()
            
            VStack {
                List(sharedDataModel.fetchPeopleDebt(), id: \.0) { item, detail in
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                // Checkmark circle
                                Image(systemName: selectedNames.contains(item) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedNames.contains(item) ? .blue : .gray)
                                
                                Text(item)
                                    .font(.headline)
                                    .padding(.bottom, 2)
                                    .foregroundColor(.primary)

                                // Medal image for Andy, Scott, and Will on the right
                                if medalRecipients.contains(item) {
                                    Spacer()
                                    Image(systemName: "medal.fill")
                                        .foregroundColor(.orange)
                                }
                            }
                            Text(detail)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        // Show circular image and associated text only if the person has a medal
                        if let (imageName, associatedText) = sharedDataModel.personImages[item] {
                            VStack {
                                Image(imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                Text(associatedText) // Display the associated text
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.vertical, 1)
                    .onTapGesture {
                        // Toggle selection
                        if selectedNames.contains(item) {
                            selectedNames.remove(item) // Deselect the item
                        } else {
                            selectedNames.insert(item) // Select the item
                        }
                    }
                }
                .frame(height: 400)
                .background(Color.white)
                .scrollContentBackground(.hidden)
                .cornerRadius(10)
                .padding(.bottom, 50)
                
                Spacer()

                // HStack for buttons at the bottom corners
                HStack {
                    // Select All Button on the left
                    Button(action: {
                        // Select all names when this button is pressed
                        if selectedNames.count == sharedDataModel.fetchPeopleDebt().count {
                            selectedNames.removeAll()
                        } else {
                            selectedNames = Set(sharedDataModel.fetchPeopleDebt().map { $0.0 })
                        }
                    }) {
                        Text("Select All")
                            .frame(width: circleSize, height: circleSize)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .padding(.leading, 50)
                    .padding(.bottom, 50)
                    
                    Spacer()
                    
                    // Pay Button on the right
                    Button(action: {
                        // Reduce the debt for selected people
                        sharedDataModel.reduceDebt(for: selectedNames)
                        selectedNames.removeAll() // Clear the selection after payment
                    }) {
                        Text("PAY")
                            .frame(width: circleSize, height: circleSize)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 50)
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
