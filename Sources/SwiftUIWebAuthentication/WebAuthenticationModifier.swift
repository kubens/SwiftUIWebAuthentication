import SwiftUI

internal struct WebAuthenticationModifier: ViewModifier {

  @Binding var isPresented: Bool

  var url: URL?
  var callbackURLScheme: String?
  var ephemeralSession: Bool
  var onDismiss: (() -> Void)?
  var onCompletion: (Result<URL, Error>) -> Void

  func body(content: Content) -> some View {
    content.background(
      WebAuthenticationRepresentable(
        isPresented: $isPresented,
        url: url,
        callbackURLScheme: callbackURLScheme,
        ephemeralSession: ephemeralSession,
        onDismiss: onDismiss,
        onCompletion: onCompletion
      )
    )
  }
}
