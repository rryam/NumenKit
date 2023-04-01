# NumenKit

Yet another ChatGPT Swift package that uses async/await syntax. Created using ChatGPT, with coding style influenced by [MusadoraKit](https://github.com/rryam/MusaodraKit) and [UmeroKit](https://github.com/rryam/UmeroKit).

<p align="center">
  <img src= "https://github.com/rryam/UmeroKit/blob/main/NumenKit.png" alt="NumenKit Logo" width="256"/>
</p>

## Text completion

```swift 
NumenKit.configure(withAPIKey: "YOUR_CHAT_GPT_API_KEY_HERE")

let response = try await Numen.response(for: "Suggest songs to add to my 'Chill Vibes' playlist.")
print(response)
```
