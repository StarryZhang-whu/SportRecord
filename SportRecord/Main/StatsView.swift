//
//  StatsView.swift
//  SportRecord
//
//  Created by 张凌浩 on 2023/5/24.
//

import SwiftUI

struct StatsView: View {
    @State private var records: [Record] = []

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
        NavigationView {
            ZStack {
                Image("Blob2")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    
                ScrollView {
                    VStack(alignment: .leading){
                        ForEach(records) { record in
                            NavigationLink(destination: RecordDetailView(record: record)){
                                Image(uiImage: record.image)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                VStack(alignment: .leading) {
                                    Text("\(dateFormatter.string(from: record.date))").font(.subheadline).foregroundColor(.gray)
                                    Text("持续时间: \(formatter.string(from: record.duration) ?? "00:00:00")")
                                }
                                Spacer()
                            }.padding().background(RoundedRectangle(cornerRadius: 20).fill(.ultraThinMaterial)).frame(maxWidth: .infinity).padding(.horizontal,20)
                            
                        }
                    }.padding(.top,120)
                }
                .onAppear {
                    DispatchQueue.global(qos: .background).async {
                            let fetchedRecords = DBService.shared.fetchRecords()
                            DispatchQueue.main.async {
                                self.records = fetchedRecords ?? []
                            }
                        }
                }
                .navigationBarTitle("运动记录")
            }
        }
    }
}
struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}

struct Record: Identifiable {
    let id: Int64
    let duration: TimeInterval
    let image: UIImage
    let date : Date
}
