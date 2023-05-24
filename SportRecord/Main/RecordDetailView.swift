//
//  RecordDetailView.swift
//  SportRecord
//
//  Created by 张凌浩 on 2023/5/25.
//

import SwiftUI

struct RecordDetailView: View {
    var record: Record
    let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    var body: some View {
        ZStack (alignment: .top){
            Image("Blob3")
                .resizable()
                .aspectRatio(contentMode: .fill)  // 这会使图片填满整个视图，可能会改变图片的比例
                .edgesIgnoringSafeArea(.all)  // 这会使图片填满整个屏幕，包括安全区域
            VStack {
                Text("打卡图片：").frame(maxWidth: .infinity, alignment: .leading).font(.subheadline).foregroundColor(Color("Text")).padding(.leading).padding(.bottom).padding(.top,70)
                Image(uiImage: record.image).resizable().aspectRatio(contentMode: .fit).frame(maxHeight: 200)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(.ultraThinMaterial))
                Text("持续时间：").frame(maxWidth: .infinity, alignment: .leading).font(.subheadline).foregroundColor(Color("Text")).padding(.leading).padding(.vertical)
                Text(" \(formatter.string(from: record.duration) ?? "00:00:00")").font(.title).bold()
                Text("运动日期：").frame(maxWidth: .infinity, alignment: .leading).font(.subheadline).foregroundColor(Color("Text")).padding(.leading).padding(.vertical)
                Text(" \(dateFormatter.string(from: record.date))").font(.title).bold()
                Text("心率：").frame(maxWidth: .infinity, alignment: .leading).font(.subheadline).foregroundColor(Color("Text")).padding(.leading).padding(.vertical)
                Text("低心率：80 高心率：150").font(.title).bold()
                Text("平均心率：133").font(.title).bold()
            }
        }
    }
}
