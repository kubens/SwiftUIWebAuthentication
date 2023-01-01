//
//  OptionsView.swift
//  SwiftUIWebAuthenticationExample
//
//  Created by Jakub Łaptaś on 18/01/2023.
//

import SwiftUI

struct OptionsView: View {
  @Environment(\.dismiss) private var dismiss
  @Binding var ephemeralSession: Bool

  var body: some View {
    NavigationStack {
      Form {
        Toggle("ephemeral session", isOn: $ephemeralSession)
      }
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Close", action: dismiss.callAsFunction
          )
        }
      }
    }
  }
}
