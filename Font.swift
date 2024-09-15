import SwiftUI

extension Font {
    static func nexa(size: CGFloat) -> Font {
        return .custom("Nexa", size: size)
    }

    static var largeTitleNexa: Font {
        return nexa(size: 36)
    }

    static var titleNexa: Font {
        return nexa(size: 24)
    }

    static var bodyNexa: Font {
        return nexa(size: 18)
    }

    static var smallNexa: Font {
        return nexa(size: 14)
    }
}
