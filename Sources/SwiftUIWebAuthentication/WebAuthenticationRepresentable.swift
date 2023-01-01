import SwiftUI
import AuthenticationServices

#if canImport(UIKit)
typealias XView = UIView
#elseif canImport(AppKit)
typealias XView = NSView
#endif

internal struct WebAuthenticationRepresentable {

  @Binding var isPresented: Bool

  var url: URL?
  var callbackURLScheme: String?
  var ephemeralSession: Bool = false
  var onDismiss: (() -> Void)?
  var onCompletion: (Result<URL, Error>) -> Void

  func makeCoordinator() -> Coordinator {
    return Coordinator(parent: self)
  }

  func makeView(context: Context) -> XView {
    context.coordinator.view
  }

  func updateView(_ view: XView, context: Context) {
    context.coordinator.parent = self
  }
}

internal extension WebAuthenticationRepresentable {
  class Coordinator: NSObject, ASWebAuthenticationPresentationContextProviding {
    let view = XView()
    var parent: WebAuthenticationRepresentable {
      didSet {
        if parent.isPresented && !oldValue.isPresented {
          startWebAuthentication()
        } else if !parent.isPresented && oldValue.isPresented {
          cancelWebAuthentication()
        }
      }
    }

    private weak var session: ASWebAuthenticationSession?

    init(parent: WebAuthenticationRepresentable) {
      self.parent = parent
    }

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
      return view.window ?? .init()
    }

    private func startWebAuthentication() {
      guard let url = parent.url else {
        Task { @MainActor in self.parent.isPresented = false }
        assertionFailure("Trying to present ASWebAuthentication withour URL")
        return
      }

      let session = ASWebAuthenticationSession(
        url: url,
        callbackURLScheme: parent.callbackURLScheme) { callbackURL, error in
          self.parent.isPresented = false

          if let callbackURL = callbackURL {
            self.parent.onCompletion(.success(callbackURL))
          } else if let error = error as? ASWebAuthenticationSessionError, error.code == .canceledLogin {
            self.parent.onDismiss?()
          } else if let error = error {
            self.parent.onCompletion(.failure(error))
          } else {
            assertionFailure("callbackURL & error are nil.")
          }
        }

      session.presentationContextProvider = self
      session.prefersEphemeralWebBrowserSession = parent.ephemeralSession
      session.start()

      self.session = session
    }

    private func cancelWebAuthentication() {
      session?.cancel()
    }
  }
}

// MARK: - UIViewRepresentable
#if canImport(UIKit)
extension WebAuthenticationRepresentable: UIViewRepresentable {
  func makeUIView(context: Context) -> UIView {
    makeView(context: context)
  }

  func updateUIView(_ uiView: XView, context: Context) {
    updateView(uiView, context: context)
  }
}
#endif

// MARK: - NSViewRepresentable
#if canImport(AppKit)
extension WebAuthenticationRepresentable: NSViewRepresentable {
  func makeNSView(context: Context) -> NSView {
    makeView(context: context)
  }

  func updateNSView(_ nsView: NSView, context: Context) {
    updateView(nsView, context: context)
  }
}
#endif
