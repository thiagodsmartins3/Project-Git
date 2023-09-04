// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Error {
    internal enum Empty {
      /// No users to view
      internal static let message = L10n.tr("Localizable", "error.empty.message", fallback: "No users to view")
    }
    internal enum Notfound {
      /// User "%@" not found
      internal static func message(_ p1: Any) -> String {
        return L10n.tr("Localizable", "error.notfound.message", String(describing: p1), fallback: "User \"%@\" not found")
      }
    }
    internal enum Request {
      /// Ops, there was a problem with the service ;(
      internal static let message = L10n.tr("Localizable", "error.request.message", fallback: "Ops, there was a problem with the service ;(")
    }
  }
  internal enum Information {
    internal enum Text {
      /// Hey!, how about knowing a little more about who I am?
      internal static let message = L10n.tr("Localizable", "information.text.message", fallback: "Hey!, how about knowing a little more about who I am?")
      /// Hi!, I'm 
      internal static let user = L10n.tr("Localizable", "information.text.user", fallback: "Hi!, I'm ")
    }
  }
  internal enum Navigation {
    internal enum Back {
      /// Back/Swipe Right
      internal static let message = L10n.tr("Localizable", "navigation.back.message", fallback: "Back/Swipe Right")
    }
  }
  internal enum Refresh {
    internal enum Error {
      /// Unable to reload data
      internal static let message = L10n.tr("Localizable", "refresh.error.message", fallback: "Unable to reload data")
    }
    internal enum Text {
      /// Refreshing
      internal static let message = L10n.tr("Localizable", "refresh.text.message", fallback: "Refreshing")
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
