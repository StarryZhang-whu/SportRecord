//
//  Style.swift
//  SportRecord
//
//  Created by 张凌浩 on 2023/5/22.
//

import Foundation
import SwiftUI

struct gradientStyleModifier: ViewModifier {
    func body(content: Content) -> some View{
        content.foregroundStyle(.linearGradient(colors: [.accentColor,Color("Secondary")], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

extension View{
    func gradientStyle() -> some View {
        self.modifier(gradientStyleModifier())
    }
}
