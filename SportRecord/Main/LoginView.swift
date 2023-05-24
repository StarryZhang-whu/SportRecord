//
//  LoginView.swift
//  SportRecord
//
//  Created by 张凌浩 on 2023/5/22.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var modal : Modal
    @EnvironmentObject var userSettings : UserSettings
    @State var userNameOrEmail = ""
    @State var password = ""
    @State var error = ""
    var body: some View {
        ZStack {
            Image("Blob")
                .resizable()
                .aspectRatio(contentMode: .fill)  // 这会使图片填满整个视图，可能会改变图片的比例
                .edgesIgnoringSafeArea(.all)  // 这会使图片填满整个屏幕，包括安全区域
                                

                
            VStack(alignment: .leading, spacing: 20){
                Text("登录")
                    .font(.largeTitle).bold().foregroundStyle(.linearGradient(colors: [.accentColor,Color("Secondary")], startPoint: .topLeading, endPoint: .bottomTrailing))
                Text("开始使用 SportRecord，做时间的主人。")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                form
                
            }.padding(20)
                .padding(.vertical,20)
                .background(RoundedRectangle(cornerRadius: 30).stroke(.linearGradient(colors: [.accentColor.opacity(0.4), Color("Secondary").opacity(0.4)], startPoint: .top, endPoint: .bottom)).shadow(radius: 10))
                .background(RoundedRectangle(cornerRadius: 30).fill(.thinMaterial).shadow(radius: 10))
            .padding()
        }
    }
    
    var form: some View{
        Group{
            TextField("邮箱/用户名",text:$userNameOrEmail).textField(icon: "envelope")
            SecureField("密码",text:$password).textField(icon: "key")
            Button{
                loginUser()
            } label: {
                Text("登录")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(RoundedRectangle(cornerRadius: 20).stroke(.linearGradient(colors: [.white.opacity(0.8), .black.opacity(0.2)], startPoint: .top, endPoint: .bottom)))
            }
            Divider()
            HStack {
                Text("没有账号？**点击注册**").font(.footnote)
                    .foregroundColor(.primary.opacity(0.7))
                    .accentColor(.primary.opacity(0.7))
                    .onTapGesture {
                        withAnimation(){
                            modal.signIn.toggle()
                        }
                    }
                Spacer()
                Text(error).font(.footnote)
                    .foregroundColor(.red)
            }
            
        }
    }
    
    func loginUser() {
        guard !userNameOrEmail.isEmpty, !password.isEmpty else {
            error = "输入格式不正确"
            return
        }
        
        if(DBService.shared.validateUser(email: userNameOrEmail, password: password)){
            userSettings.user = DBService.shared.getUser(email: userNameOrEmail)
            userSettings.isNotLoggedIn.toggle()
        } else {
            error = "用户名或密码错误"
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserSettings())
            .environmentObject(Modal())
    }
}
