//
//  NumenPostRequest.swift
//  NumenKit
//
//  Created by Rudrank Riyam on 01/04/23.
//

import Foundation

public struct NumenPostRequest<Model: Codable>: Sendable {
  /// The URL for the data request.
  var key: String
  var url: URL?
  var data: Data?

  init(key: String, url: URL?, data: Data? = nil) {
    self.key = key
    self.url = url
    self.data = data
  }

  /// Write data to the OpenAI endpoint that the URL request defines.
  public func response() async throws -> Model {
    guard let url else {
      throw URLError(.badURL)
    }

    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "POST"
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
    urlRequest.httpMethod = "POST"
    urlRequest.httpBody = data

    let (urlRequestData, _) = try await URLSession.shared.data(for: urlRequest)

    let decoder = JSONDecoder()
    let model = try decoder.decode(Model.self, from: urlRequestData)
    return model
  }
}
