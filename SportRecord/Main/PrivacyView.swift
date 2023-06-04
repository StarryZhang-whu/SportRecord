//
//  PrivacyView.swift
//  SportRecord
//
//  Created by 张凌浩 on 2023/5/27.
//

import SwiftUI

struct PrivacyView: View {
    var body: some View {
        Button{
            DBService.shared.deleteRecords()
        }label: {
            Text("删除运动记录").padding().background(RoundedRectangle(cornerRadius: 20).fill(.thinMaterial))
        }
    }
}

struct PrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyView()
    }
}
