import SwiftUI

public extension View {
  /// Presents a system interface for ASWebAuthentication to authenticate a user
  /// in Web Service.
  ///
  /// In order for the interface to appear, both `isPresented` must be `true`
  /// and `url` must not be `nil`. When the operation is finished,
  /// `isPresented` will be set to `false` before `onCompletion` is called. If
  /// the user cancels the operation, `isPresented` will be set to `false` and
  /// `onDismiss` will called instead of `onCompletion`.
  ///
  ///     struct ContentView: View {
  ///       @State private var showWebAuthentication = false
  ///
  ///       var body: some View {
  ///         VStack {
  ///           Button("Show WebAuthentication") {
  ///             showWebAuthentication = true
  ///           }
  ///         }
  ///         .webAuthentication(
  ///           isPresented: $showWebAuthentication,
  ///           url: URL(string: "https://github.com/login/oauth/authorize?client_id=\(clientId)"),
  ///           callbackURLScheme: "github"
  ///         ) { result in
  ///           if case .success(let url) = result {
  ///             // handle URL from callback
  ///           }
  ///         }
  ///       }
  ///     }
  ///
  /// - Parameters:
  ///   - isPresented: A binding to whether the interface should be shown.
  ///   - url: The initial URL pointing to the authentication webpage.
  ///     Only supports URLs with http:// or https:// schemes.
  ///   - callbackURLScheme: The custom URL scheme that the app expects in the
  ///     callback URL.
  ///   - ephemeralSession: A Boolean value that indicates whether the session
  ///     should ask the browser for a private authentication session.
  ///   - onDismiss: The closure to execute when dismissing the ASWebAuthentication.
  ///   - onCompletion: A callback that will be invoked when the operation has
  ///     has succeeded or failed.
  func webAuthentication(
    isPresented: Binding<Bool>,
    url: URL?,
    callbackURLScheme: String? = nil,
    ephemeralSession: Bool = false,
    onDismiss: (() -> Void)? = nil,
    onCompletion: @escaping (Result<URL, Error>) -> Void
  ) -> some View {
    self.modifier(
      WebAuthenticationModifier(
        isPresented: isPresented,
        url: url,
        callbackURLScheme: callbackURLScheme,
        ephemeralSession: ephemeralSession,
        onDismiss: onDismiss,
        onCompletion: onCompletion
      )
    )
  }
}
