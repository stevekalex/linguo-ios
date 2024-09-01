import SwiftUI

public struct Fonts {
    let main: (CGFloat) -> Font = { size in
        return Font.custom("Avenir Next", size: size)
    }
    
    let header: (CGFloat) -> Font = { size in
        return Font.custom("Avenir Next Bold", size: size)
    }
}
