//
//  ChatGPTCompletionRequest.swift
//  NumenKit
//
//  Created by Rudrank Riyam on 01/04/23.
//

import Foundation

/// A request to generate a response from ChatGPT.
public struct ChatGPTCompletionRequest {

  private var model: String
  private var prompt: String
  private var temperature: Double
  private var maxTokens: Int
  private var topP: Double
  private var frequencyPenalty: Double
  private var presencePenalty: Double
  private var authorization: String

  /// Creates a request to generate a response from ChatGPT.
  /// - Parameters:
  ///   - model: The name of the model to use for generating the response.
  ///   - prompt: The text prompt to use for generating the response.
  ///   - temperature: A value that controls the "creativity" of the generated response. Higher values result in more unpredictable responses.
  ///   - maxTokens: The maximum number of tokens to generate in the response.
  ///   - topP: A value that controls the diversity of the generated response.
  ///   - frequencyPenalty: A value that controls the frequency of repeated tokens in the generated response.
  ///   - presencePenalty: A value that controls the presence of tokens not present in the prompt in the generated response.
  ///   - authorization: The authorization token to use for making the request.
  public init(model: String, prompt: String, temperature: Double = 0.4, maxTokens: Int = 2063, topP: Double = 1, frequencyPenalty: Double = 0, presencePenalty: Double = 0, authorization: String) {
    self.model = model
    self.prompt = prompt
    self.temperature = temperature
    self.maxTokens = maxTokens
    self.topP = topP
    self.frequencyPenalty = frequencyPenalty
    self.presencePenalty = presencePenalty
    self.authorization = authorization
  }

  /// Generates a response from ChatGPT based on the request.
  public func response() async throws -> ChatGPTCompletionResponse {
    let url = URL(string: "https://api.openai.com/v1/chat/completions")!
    var request = URLRequest(url: url)

    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(authorization)", forHTTPHeaderField: "Authorization")
    let requestBody = ChatGPTRequestBody(model: model, prompt: prompt, temperature: temperature, maxTokens: maxTokens, topP: topP, frequencyPenalty: frequencyPenalty, presencePenalty: presencePenalty)

    request.httpBody = try JSONEncoder().encode(requestBody)
    let response = try await URLSession.shared.data(for: request)
    try print(response.0.printJSON())
    return try JSONDecoder().decode(ChatGPTCompletionResponse.self, from: response.0)
  }
}

/// The request body for a ChatGPT request.
private struct ChatGPTRequestBody: Encodable {
  let model: String
  let prompt: String
  let temperature: Double
  let maxTokens: Int
  let topP: Double
  let frequencyPenalty: Double
  let presencePenalty: Double

  enum CodingKeys: String, CodingKey {
    case model
    case prompt
    case temperature
    case maxTokens = "max_tokens"
    case topP = "top_p"
    case frequencyPenalty = "frequency_penalty"
    case presencePenalty = "presence_penalty"
  }
}

/// A response from ChatGPT.
public struct ChatGPTCompletionResponse: Decodable {
  public let id: String
  public let object: String
  public let created: Int
  public let model: String
  public let choices: [ChatGPTResponseChoice]
  public let usage: ChatGPTUsage
}

public struct ChatGPTResponseChoice: Decodable {
  public let text: String
  public let index: Int
  public let logprobs: [String: [String: Double]]?
  public let finishReason: String
}

public struct ChatGPTUsage: Decodable {
  public let promptTokens: Int
  public let completionTokens: Int
  public let totalTokens: Int

  enum CodingKeys: String, CodingKey {
    case promptTokens = "prompt_tokens"
    case completionTokens = "completion_tokens"
    case totalTokens = "total_tokens"
  }
}

extension Data {
 public func printJSON() throws -> String {
    let json = try JSONSerialization.jsonObject(with: self, options: [])
    let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)

    guard let jsonString = String(data: data, encoding: .utf8) else {
      throw URLError(.cannotDecodeRawData)
    }
    return jsonString
  }
}
