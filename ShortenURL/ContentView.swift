//
//  ContentView.swift
//  ShortenURL
//
//  Created by Kinney Kare on 12/4/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var shortURL = URLShortManager()
    
    var body: some View {
        Form {
            Section("Link") {
                TextEditor(text: $shortURL.inputURL)
                    .frame(height: 100)
                
                HStack {
                    Spacer()
                    Button("Submit") {
                        if shortURL.inputURL.isEmpty {
                            shortURL.resultURL = "Please Add a URL first..."
                        } else {
                            shortURL.resultURL = "Loading..."
                            shortURL.getData()
                        }
                    }
                    Spacer()
                }
            }
            Section("Results") {
                TextField("Your shortened URL will appear here.", text: $shortURL.resultURL)
                    .textSelection(.enabled)
                    .foregroundColor(.green)
                
                HStack {
                    Spacer()
                    Button("Reset") {
                        shortURL.inputURL = ""
                        shortURL.resultURL = ""
                        
                    }
                    .tint(.red)
                    Spacer()
                }
            }
        }
        .environmentObject(shortURL)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
