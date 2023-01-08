import Foundation

// Enforce minimum Swift version for all platforms and build systems.
#if swift(<5.5)
#error("OpenAI doesn't support Swift versions below 5.5.")
#endif

public let OpenAI = Session.default
