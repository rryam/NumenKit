import Foundation

/// A request to generate a response from ChatGPT.
public struct ChatGPTRequest {

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
  public func response() async throws -> ChatGPTResponse {
    let url = URL(string: "https://api.openai.com/v1/completions")!
    var request = URLRequest(url: url)

    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(authorization)", forHTTPHeaderField: "Authorization")
    let requestBody = ChatGPTRequestBody(model: model, prompt: prompt, temperature: temperature, maxTokens: maxTokens, topP: topP, frequencyPenalty: frequencyPenalty, presencePenalty: presencePenalty)

    request.httpBody = try JSONEncoder().encode(requestBody)
    let response = try await URLSession.shared.data(for: request)
    return try JSONDecoder().decode(ChatGPTResponse.self, from: response.0)
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
public struct ChatGPTResponse: Decodable {
  public let choices: [ChatGPTResponseChoice]
}

/// A choice in a response from ChatGPT.
public struct ChatGPTResponseChoice: Decodable {
  public let text: String
  public let index: Int
  public let logprobs: ChatGPTResponseChoiceLogprobs
}

/// Log probabilities in a response choice from ChatGPT.
public struct ChatGPTResponseChoiceLogprobs: Decodable {
  public let tokens: [String]
  public let tokenLogprobs: [Double]
  public let topLogprobs: [[String: Double]]
}
