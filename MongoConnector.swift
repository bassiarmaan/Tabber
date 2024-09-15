//
//  MongoConnector.swift
//  Tabber
//
//  Created by Kylan Chen on 9/15/24.
//

import Foundation

public func createUser(phone_number: String) {
    guard let url = URL(string: "http://localhost:8000/create-user") else {
        return
    }

    var request = URLRequest(url:url);

    // method and headers
    request.httpMethod = "POST";
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    // set up body
    let body: [String: Any] = ["phone_number": phone_number]
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)


    // make the request
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
            return
        }

        do {
            let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            print("SUCCESSFULLY CREATED USER!");
        }
        catch {
            print(error)
        }

    }
    task.resume();
}

private func getUserDebtsHelper(phone_number: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
    // construct url
    guard let url = URL(string: "http://localhost:8000/users/\(phone_number)/debts") else {
        print("Invalid URL")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        // return if error occurs
        if let error = error {
            completion(.failure(error))
            return
        }

        // verify data
        guard let data = data else {
            let noDataError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
            completion(.failure(noDataError))
            return
        }

        // parse response as json
        do {
            if let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                completion(.success(responseJSON)) // Return the debts data via the completion handler
            } else {
                let parsingError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse response"])
                completion(.failure(parsingError))
            }
        } catch {
            completion(.failure(error))
        }
    }

    task.resume() // execute request
}

// wrapper for user debts get request to simplify function call
public func getUserDebts (phone_number: String, completion: @escaping ([String: Any]?) -> Void) {
    getUserDebtsHelper(phone_number: phone_number) { result in
        switch result {
        case .success(let debts):
            completion(debts)
        case .failure(let error):
            print("Error fetching debts: \(error)")
            completion(nil)
        }
    }
}

public func getTotalDebt(phone_number: String, completion: @escaping (Double) -> Void) {
    getUserDebts(phone_number: phone_number) { debts in
        var total = 0.0
        
        if let debtsDict = debts, let innerDebts = debtsDict["debts"] as? [String: Any] {
            innerDebts.values.forEach { val in
                if let doubleVal = val as? Double {
                    total += doubleVal
                } else if let intVal = val as? Int {
                    total += Double(intVal)
                } else if let stringVal = val as? String, let doubleVal = Double(stringVal) {
                    total += doubleVal
                } else {
                    print("ERROR: Value is not convertible to a double!")
                }
            }
        } else {
            print("ERROR: Debts data is nil or invalid format!")
        }
        
        // return total
        completion(total)
    }
}

public func addDebt(debtor_phone_number: String, loaner_phone_number: String, amount: Double) {
    guard let url = URL(string: "http://localhost:8000/users/add-debt") else {
        print("Invalid URL")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body: [String: Any] = [
        "debtor_phone_number": debtor_phone_number,
        "loaner_phone_number": loaner_phone_number,
        "amount": amount
    ]
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
            print("Error making POST request: \(String(describing: error))")
            return
        }

        do {
            let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            print("SUCCESSFULLY ADDED/UPDATED DEBT!")
            print("Response: \(response)")
        } catch {
            print("Error parsing JSON response: \(error)")
        }
    }

    task.resume()
}

public func getAllUserPhoneNumbers(completion: @escaping ([String]) -> Void) {
    // create url
    guard let url = URL(string: "http://localhost:8000/users/phone-numbers") else {
        print("Invalid URL")
        completion([])  // if call fails, returns empty array
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    // create request
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
            print("Error making GET request: \(String(describing: error))")
            completion([])  // Return an empty array in case of error
            return
        }

        // parse responses as json
        do {
            let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            if let phoneNumbers = responseJSON?["phoneNumbers"] as? [String] {
                completion(phoneNumbers)
            } else {
                print("Failed to parse phone numbers")
                completion([])
            }
        } catch {
            print("Error parsing JSON response: \(error)")
            completion([])
        }
    }

    task.resume() // execute request
}

