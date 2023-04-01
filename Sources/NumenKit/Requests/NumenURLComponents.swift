//
//  NumenURLComponents.swift
//  NumenKit
//
//  Created by Rudrank Riyam on 01/04/23.
//

import Foundation

/// A protocol for URL components that can be used to construct URLs for API requests.
protocol NURLComponents {

  /// The query items to include in the URL.
  var queryItems: [URLQueryItem]? { get set }

  /// The path for the URL, excluding the base path.
  var path: String { get set }

  /// The constructed URL, if valid.
  var url: URL? { get }
}

/// A structure that implements the NURLComponents protocol, specifically for OpenAI API requests.
struct NumenURLComponents: NURLComponents {

  /// The underlying URLComponents instance.
  private var components: URLComponents

  /// Initializes a new NumenURLComponents instance with default values for the scheme and host.
  init() {
    self.components = URLComponents()
    components.scheme = "https"
    components.host = "api.openai.com"
  }

  /// The query items to include in the URL.
  var queryItems: [URLQueryItem]? {
    get {
      components.queryItems
    } set {
      components.queryItems = newValue
    }
  }

  /// The path for the URL, excluding the base path.
  var path: String {
    get {
      return components.path
    } set {
      components.path = "/v1/" + newValue
    }
  }

  /// The constructed URL, if valid.
  var url: URL? {
    components.url
  }
}
