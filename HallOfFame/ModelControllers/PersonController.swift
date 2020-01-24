//
//  PersonController.swift
//  HallOfFame
//
//  Created by Uzo on 1/23/20.
//  Copyright © 2020 Uzo. All rights reserved.
//

import Foundation

class PersonController {
    
    //Constants
    static private let baseURL = URL(string: "https://ios-api.devmountain.com/api")
    static private let personEndpoint = "person" // expects an ID
    static private let peopleEndpoint = "people"
    
    private static let contentTypeKey = "Content-Type"
    private static let contentTypeValue = "application/json"
    
    //CRUD
    /// the reason we do @escaping is because it runs after you return (after the function finishes running)
    static func getPeople(completion: @escaping(Result<[Person], NetworkError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}
        
        let peopleURL = baseURL.appendingPathComponent(peopleEndpoint)
        print(peopleURL)
        
        URLSession.shared.dataTask(with: peopleURL) { (data, _, error) in
            if let error = error {
                print(error)
                ///Sends the Error to the ViewController
                completion(.failure(.thrownError(error)))
                /// Ends the function on PersonController
                return
            }
            
            guard let data = data else {
                return completion(.failure(.noData))
            }
            
            do {
                let decoder = JSONDecoder()
                let people = try decoder.decode([Person].self, from: data)
                print(people)
                return completion(.success(people))
            } catch {
                print(error)
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func postPerson(firstName: String, lastName: String, cohort: String, completion: @escaping(Result<Person, NetworkError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let personURL = baseURL.appendingPathComponent(personEndpoint)
        
        var postRequest = URLRequest(url: personURL)
        postRequest.httpMethod = "POST"
        //header
        postRequest.addValue(contentTypeValue, forHTTPHeaderField: contentTypeKey)
        //body
        //let person = Person(personID: nil, firstName: firstName, lastName: lastName)
        let person = Person(personID: nil, firstName: firstName, lastName: lastName, cohort: cohort)
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(person)
            postRequest.httpBody = data
        } catch {
            print(error, error.localizedDescription)
            return completion(.failure(.thrownError(error)))
        }
        
        URLSession.shared.dataTask(with: postRequest) { (data, _, error) in
            if let error = error {
                print(error)
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData))}
            print(String(data: data, encoding: .utf8) as Any)
            
            do {
                let decoder = JSONDecoder()
                
                let person = try decoder.decode([Person].self, from: data)
                
                return completion(.success(person[0]))
            } catch {
                print(error)
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
}
