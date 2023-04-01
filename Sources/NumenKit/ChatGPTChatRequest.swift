import Foundation

/// A request that your app uses to generate a response for a given message in a chat conversation using the OpenAI GPT-3 API.
public struct ChatGPTChatRequest {

  private var model: String
  private var apiKey: String
  private var messages: [ChatGPTMessage]

  /// Creates a request to generate a response for the given message in a chat conversation using the specified OpenAI GPT-3 model.
  /// - Parameters:
  ///   - model: The name of the OpenAI GPT-3 model to use for generating the response.
  ///   - message: The message to respond to, along with its role in the conversation.
  public init(model: String, message: ChatGPTMessage, apiKey: String) {
    self.model = model
    self.messages = [message]
    self.apiKey = apiKey
  }

  /// Creates a request to generate a response for the given messages in a chat conversation using the specified OpenAI GPT-3 model.
  /// - Parameters:
  ///   - model: The name of the OpenAI GPT-3 model to use for generating the response.
  ///   - messages: The messages to respond to, along with their roles in the conversation.
  public init(model: String, messages: [ChatGPTMessage], apiKey: String) {
    self.model = model
    self.messages = messages
    self.apiKey = apiKey
  }

  /// Fetches the response for the given message(s) in the chat conversation.
  public func response() async throws -> ChatGPTChatResponse {
    let url = try chatGPTConversationEndpointURL
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "POST"
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

    let requestBody = try JSONEncoder().encode(ChatGPTChatRequestBody(model: model, messages: messages))
    urlRequest.httpBody = requestBody

    let response = try await URLSession.shared.data(for: urlRequest)
    return try JSONDecoder().decode(ChatGPTChatResponse.self, from: response.0)
  }
}

extension ChatGPTChatRequest {
  internal var chatGPTConversationEndpointURL: URL {
    get throws {
      guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
        throw URLError(.badURL)
      }
      return url
    }
  }
}

public struct ChatGPTMessage: Encodable {
  public let role: String
  public let content: String

  public init(role: String, content: String) {
    self.role = role
    self.content = content
  }
}

public struct ChatGPTChatRequestBody: Encodable {
  public let model: String
  public let messages: [ChatGPTMessage]

  public init(model: String, messages: [ChatGPTMessage]) {
    self.model = model
    self.messages = messages
  }
}

public struct ChatGPTChatResponse: Decodable {
  let id, object: String
  let created: Int
  public let choices: [ChatGPTChatChoice]
  let usage: ChatGPTChatUsage
}

// MARK: - Choice
public struct ChatGPTChatChoice: Codable {
  let index: Int
  public let message: ChatGPTChatMessage
  let finishReason: String

  enum CodingKeys: String, CodingKey {
    case index, message
    case finishReason = "finish_reason"
  }
}

// MARK: - Message
public struct ChatGPTChatMessage: Codable {
  public let role: String
  public let content: String
}

// MARK: - Usage
struct ChatGPTChatUsage: Codable {
  let promptTokens, completionTokens, totalTokens: Int

  enum CodingKeys: String, CodingKey {
    case promptTokens = "prompt_tokens"
    case completionTokens = "completion_tokens"
    case totalTokens = "total_tokens"
  }
}
