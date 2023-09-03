// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Information {
    internal enum Text {
      /// Hey!, how about knowing a little more about who I am?
      internal static let message = L10n.tr("Localizable", "information.text.message", fallback: "Hey!, how about knowing a little more about who I am?")
      /// Hi!, I'm 
      internal static let user = L10n.tr("Localizable", "information.text.user", fallback: "Hi!, I'm ")
    }
  }
  internal enum Searchbar {
    internal enum Text {
      /// Localizable.strings
      ///   Project-Carrefour
      /// 
      ///   Created by Thiago dos Santos Martins on 01/09/23.
      internal static let placeholder = L10n.tr("Localizable", "searchbar.text.placeholder", fallback: "Search what you wish")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
