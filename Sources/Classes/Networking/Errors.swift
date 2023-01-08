import Foundation

public enum Errors: Error {
    case general(error: Error)
    case decode(error: Error)
}

