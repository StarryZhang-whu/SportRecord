//
//  EditView.swift
//  SportRecord
//
//  Created by 张凌浩 on 2023/5/27.
//

import SwiftUI

struct EditView: View {
    @EnvironmentObject var userSettings : UserSettings
    
    var body: some View {
        VStack(alignment: .leading){
            Text("个人信息").font(.title).bold()
            Divider()
            Image("Avatar").resizable().frame(width: 100,height: 100)
                .cornerRadius(20)
                .overlay(Rectangle().fill(Color(.gray).opacity(0.3)).cornerRadius(20))
                .overlay(Text("更改\n头像").foregroundColor(.white).font(.headline).shadow(radius: 5))
                    .frame(maxWidth: .infinity)
                    .padding(20)
            HStack{
                VStack(alignment: .leading){
                    HStack {
                        Text("**用户名：**")
                        Text(userSettings.user?.name ?? "张凌浩")
                    }.foregroundColor(Color("Text")).padding(.bottom).font(.title2)
                    HStack {
                        Text("**注册邮箱：**")
                        Text(userSettings.user?.email ?? "test@c.c")
                    }.foregroundColor(Color("Text")).padding(.bottom).font(.title2)
                    HStack {
                        Text("**个性签名：** 运动使人快乐").foregroundColor(Color("Text")).font(.title2)
                    }
                }
                Spacer()
            }
        }.padding(20).frame(maxHeight: .infinity,alignment: .top)
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView().environmentObject(UserSettings())
    }
}
