//
//  URLShortManager.swift
//  ShortenURL
//
//  Created by Kinney Kare on 12/4/22.
//

import Foundation

// MARK: - Welcome
struct URLShort: Codable {
    let data: URLData
    let code: Int
    let errors: [String?]
}

struct URLData: Codable {
    let domain, alias: String
    let deleted, archived: Bool
    let tags: [String]
    let analytics: [Analytic]
    let tinyURL: String?
    let url: String
}

// MARK: - Analytic
struct Analytic: Codable {
    let enabled, analyticPublic: Bool
}


@MainActor class URLShortManager: ObservableObject {
    private let API_KEY = "DtV61hYADR8Uz8OhKxjMEmgsuU9s8B07qZOveHHCLPY8YUm7rgQQIjSke8rs"
    
    @Published var resultURL = ""
    @Published var inputURL = "https://github.com/jbird84"
    
    func getData() {
        guard let url = URL(string: "https://api.tinyurl.com/create?url=\(inputURL)&api_token=\(API_KEY)") else {
   // https://api.tinyurl.com/create?api_token=DtV61hYADR8Uz8OhKxjMEmgsuU9s8B07qZOveHHCLPY8YUm7rgQQIjSke8rs
            print("INVALID URL")
            return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("Could not retrieve data...")
                
                DispatchQueue.main.async {
                    self.resultURL = "Could not retrieve data..."
                }
                return
            }
            
            do {
                let shortenedURL = try JSONDecoder().decode(URLShort.self, from: data)
                DispatchQueue.main.async {
                    print(shortenedURL)
                    self.resultURL = "https://tinyurl.com/" + shortenedURL.data.alias
                }
            } catch {
                DispatchQueue.main.async {
                    print("\(error)")
                    self.resultURL = "Please enter a valid URL..."
                }
            }
        }
        .resume()
    }
}
