//
//  NumenKit.swift
//  NumenKit
//
//  Created by Rudrank Riyam on 01/04/23.
//

public let Numen = NumenKit.default

public class NumenKit {
  private static var apiKey: String = ""

  public static var `default`: NumenKit {
    guard apiKey != "" else {
      fatalError("Provide the API Key.")
    }

    return NumenKit()
  }

  public static func configure(withAPIKey apiKey: String) {
    Self.apiKey = apiKey
  }
}

extension NumenKit {
  public func response(prompt: String, model: String = "text-davinci-003", temperature: Double = 0.4, maxTokens: Int = 2063, topP: Double = 1, frequencyPenalty: Double = 0, presencePenalty: Double = 0) async throws -> String {
    let request = ChatGPTCompletionRequest(model: model, prompt: prompt, temperature: temperature, maxTokens: maxTokens, topP: topP, frequencyPenalty: frequencyPenalty, presencePenalty: presencePenalty, authorization: Self.apiKey)
    let response = try await request.response()
    return response.choices[0].text
  }

  public func response(message: String) async throws -> ChatGPTChatResponse {
    let request = ChatGPTConversationRequest(model: "gpt-3.5-turbo", message: .init(role: "user", content: message), apiKey: Self.apiKey)
    let response = try await request.response()

    return response
  }
}
