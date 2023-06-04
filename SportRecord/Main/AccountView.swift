//
//  AccountView.swift
//  SportRecord
//
//  Created by 张凌浩 on 2023/5/25.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var modal:Modal
    @EnvironmentObject var userSettings:UserSettings
    @State var showEdit = false
    var body: some View {
        ZStack {
            NavigationStack{
                List{
                    Button{ showEdit.toggle() }label: {
                        person.padding(.vertical)
                    }.sheet(isPresented: $showEdit){
                        EditView()
                    }
                    
                    Section{
                        NavigationLink {} label: {
                            Label("设置", systemImage: "gear")
                        }
                        NavigationLink { PrivacyView() } label: {
                            Label("隐私", systemImage: "lock.doc")
                        }
                        NavigationLink {} label: {
                            Label("帮助", systemImage: "questionmark.circle")
                        }
                    }
                    ZStack(alignment: .trailing) {
                        Text("Alpha 0.0.1").font(.footnote).foregroundColor(.secondary).offset(x:-15)
                        NavigationLink { about } label: {
                            Label("关于", systemImage: "info.circle")
                        }
                    }
                        Section {
                            Button{
                                userSettings.user = nil
                                userSettings.isNotLoggedIn.toggle()
                            }label: {
                                Text("退出账号").frame(maxWidth: .infinity)
                            }.tint(.red)
                        }
                }
                    .navigationTitle("账户")
            }
            
        }
    }
    var person: some View{
        HStack{
            Image("Avatar").resizable().frame(width: 50,height: 50)
                .cornerRadius(20)
            VStack(alignment: .leading){
                Text(userSettings.user?.name ?? "").font(.title2).bold().padding(.vertical,2)
                Text("运动使人快乐").font(.footnote).foregroundColor(.secondary)
            }
            Spacer()
            Image("武汉大学")
                .resizable()
                .frame(width: 35, height: 35)
                .cornerRadius(20)
                .padding(8)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
        }
        .background(HexagonView().offset(x: -130, y: -100))
        .background(AnimatedBlobView().frame(width: 400, height: 414).offset(x: 200, y: 0).scaleEffect(0.5))
    }
    var about: some View{
        Text("张凌浩 2021302111053")
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(Modal())
            .environmentObject(UserSettings())
    }
}
struct HexagonView: View {
    var body: some View {
        Canvas { context, size in
            let image = context.resolve(Image(systemName: "hexagon.fill"))
            let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            context.draw(image, in: frame)
        }
        .frame(width: 200, height: 220)
        .foregroundStyle(.linearGradient(colors: [.accentColor,Color("Secondary").opacity(0.7)], startPoint: .topLeading, endPoint: .bottom))
    }
}
struct AnimatedBlobView: View {
    @State var appear = false
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let now = timeline.date.timeIntervalSinceReferenceDate
                let angle1 = cos(Angle.degrees(now.remainder(dividingBy: 3) * 60).radians)
                let angle2 = cos(Angle.degrees(now.remainder(dividingBy: 6) * 10).radians)
                
                var path = Path()
                let width = 390.0
                let height = 414.0
                path.move(to: CGPoint(x: 0.9923*width, y: 0.42593*height))
                path.addCurve(to: CGPoint(x: 0.6355*width*angle2, y: height), control1: CGPoint(x: 0.92554*width*angle2, y: 0.77749*height*angle2), control2: CGPoint(x: 0.91864*width*angle2, y: height))
                path.addCurve(to: CGPoint(x: 0.08995*width, y: 0.60171*height), control1: CGPoint(x: 0.35237*width*angle1, y: height), control2: CGPoint(x: 0.2695*width, y: 0.77304*height))
                path.addCurve(to: CGPoint(x: 0.34086*width, y: 0.06324*height*angle1), control1: CGPoint(x: -0.0896*width, y: 0.43038*height), control2: CGPoint(x: 0.00248*width, y: 0.23012*height*angle1))
                path.addCurve(to: CGPoint(x: 0.9923*width, y: 0.42593*height), control1: CGPoint(x: 0.67924*width, y: -0.10364*height*angle1), control2: CGPoint(x: 1.05906*width, y: 0.07436*height*angle2))
                path.closeSubpath()
                
                context.fill(path, with: .linearGradient(Gradient(colors: [.accentColor.opacity(0.7), Color("Secondary").opacity(0.5)]), startPoint: .init(x: 0, y: 0), endPoint: .init(x: 400, y: 400)))
            }
        }
        .rotationEffect(.degrees(appear ? 360 : 0))
        .onAppear {
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                appear = true
            }
        }
    }
}
