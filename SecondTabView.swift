import SwiftUI

struct SecondTabView: View {
    @State private var selectedTipPercentage = 18
    @State private var tipAmount: Double = 13.50
    @State private var selectedItems: Set<Int> = [] // Track selected menu items by their index

    let items = [
        ("1 Karami Ramen", "$18.00"),
        ("Flavored Egg", "$3.00"),
        ("1 Karami Ramen", "$18.00"),
        ("Spice Meat Bomb", "$3.00"),
        ("1 Unami Ramen", "$16.00"),
        ("1 Spicy Norisuke", "$17.00")
    ]
    
    let subtotal: Double = 75.00
    let tax: Double = 5.25
    
    var selectedItemsTotal: Double {
        // Calculate total of selected items
        return items
            .enumerated()
            .filter { selectedItems.contains($0.offset) } // Filter by selected indices
            .compactMap { Double($0.element.1.dropFirst()) } // Drop '$' and convert to Double
            .reduce(0, +)
    }
    
    var selectedItemsTaxAndTip: (tax: Double, tip: Double) {
        // Calculate percentage of selected items total from the overall subtotal
        let percentage = selectedItemsTotal / subtotal
        
        // Calculate proportional tax and tip
        let proportionalTax = tax * percentage
        let proportionalTip = tipAmount * percentage
        
        return (proportionalTax, proportionalTip)
    }
    
    var body: some View {
        VStack {
            // Add the scan receipt button at the top
            Button(action: {
                // No action for now
            }) {
                HStack {
                    Text("Scan Receipt")
                    Image(systemName: "camera.fill")
                }
                .font(.headline)
            }
            .padding()

            // Display receipt items with individually selectable capability
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    Button(action: {
                        // Toggle selection of the item by its index
                        if selectedItems.contains(index) {
                            selectedItems.remove(index)
                        } else {
                            selectedItems.insert(index)
                        }
                    }) {
                        HStack {
                            // Checkmark circle
                            Image(systemName: selectedItems.contains(index) ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selectedItems.contains(index) ? .blue : .gray)
                            
                            Text(item.0)
                            Spacer()
                            Text(item.1)
                        }
                    }
                }
                
                Divider()
                
                HStack {
                    Text("Subtotal:")
                    Spacer()
                    Text("$\(subtotal, specifier: "%.2f")")
                }
                
                HStack {
                    Text("Tax:")
                    Spacer()
                    Text("$\(tax, specifier: "%.2f")")
                }
                
                HStack {
                    Text("Tip:")
                    Spacer()
                    
                    // Dropdown menu for selecting tip percentage
                    Picker("Tip Percentage", selection: $selectedTipPercentage) {
                        Text("0%").tag(0)
                        Text("10%").tag(10)
                        Text("15%").tag(15)
                        Text("18%").tag(18)
                        Text("20%").tag(20)
                        Text("25%").tag(25)
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedTipPercentage) { newValue in
                        // Calculate the tip amount based on the selected percentage
                        tipAmount = (subtotal + tax) * Double(newValue) / 100
                    }
                    
                    Text("$\(tipAmount, specifier: "%.2f")")
                }
                
                Divider()
                
                HStack {
                    Text("Total:")
                        .fontWeight(.bold)
                    Spacer()
                    Text("$\(subtotal + tax + tipAmount, specifier: "%.2f")")
                        .fontWeight(.bold)
                }
            }
            .padding()

            // Display the selected items total and calculated tax and tip
            if !selectedItems.isEmpty {
                VStack {
                    Divider()
                    
                    Text("Total for Selected Items: $\(selectedItemsTotal + selectedItemsTaxAndTip.tax + selectedItemsTaxAndTip.tip, specifier: "%.2f")")
                        .fontWeight(.bold)
                        .padding(.top)
                }
                .padding(.horizontal)
            }

            Spacer()
        }
    }
}

#Preview {
    SecondTabView()
}
