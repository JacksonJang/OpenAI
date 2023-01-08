import Foundation

/// Type representing HTTP methods. Raw `String` value is stored and compared case-sensitively, so
/// `HTTPMethod.get != HTTPMethod(rawValue: "get")`.
///
/// See https://tools.ietf.org/html/rfc7231#section-4.3
public struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    /// `GET` method.
    public static let get = HTTPMethod(rawValue: "GET")
    /// `POST` method.
    public static let post = HTTPMethod(rawValue: "POST")
    /// `PUT` method.
    public static let put = HTTPMethod(rawValue: "PUT")
    /// `DELETE` method.
    public static let delete = HTTPMethod(rawValue: "DELETE")

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

