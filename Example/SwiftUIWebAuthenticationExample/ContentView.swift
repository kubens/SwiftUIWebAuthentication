import SwiftUI
import SwiftUIWebAuthentication

struct ContentView: View {

  @State private var showOptions = false
  @State private var showWebAuthentication = false
  @State private var ephemeralSession = false

  private let callbackURLScheme = "github"

  private var authorizationURL: URL {
    return URL(string: "https://github.com/login/oauth/authorize?client_id=2cfa9b7a1b57de32dd0d")!
  }

  var body: some View {
    VStack(spacing: 8) {
      Button("Start WebAuthentication") { showWebAuthentication = true }
        .buttonStyle(.borderedProminent)

      Button("Options") { showOptions = true }
    }
    .webAuthentication(
      isPresented: $showWebAuthentication,
      url: authorizationURL,
      callbackURLScheme: callbackURLScheme,
      ephemeralSession: ephemeralSession,
      onDismiss: {
        print("dismiss")
      },
      onCompletion: handleWebAuthCompletion(result:)
    )
    .padding()
    .sheet(isPresented: $showOptions) {
      OptionsView(ephemeralSession: $ephemeralSession)
    }
  }

  private func handleWebAuthCompletion(result: Result<URL, Error>) {
    print(result)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
