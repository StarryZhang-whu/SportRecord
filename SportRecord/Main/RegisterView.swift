//
//  LoginView.swift
//  SportRecord
//
//  Created by 张凌浩 on 2023/5/22.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var modal : Modal
    
    @State var name = ""
    @State var email = ""
    @State var password = ""
    
    @State var error = ""
    var body: some View {
        ZStack {
            Image("Blob1")
                .resizable()
                .aspectRatio(contentMode: .fill)  // 这会使图片填满整个视图，可能会改变图片的比例
                .edgesIgnoringSafeArea(.all)  // 这会使图片填满整个屏幕，包括安全区域
                                

                
            VStack(alignment: .leading, spacing: 20){
                Text("注册")
                    .font(.largeTitle).bold().foregroundStyle(.linearGradient(colors: [.accentColor,Color("Secondary")], startPoint: .topLeading, endPoint: .bottomTrailing))
                Text("注册一个 SportRecord 账户，开启自律校园生活。")
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
            TextField("邮箱",text:$email).textField(icon: "envelope")
            TextField("用户名",text:$name).textField(icon: "person")
            SecureField("密码",text:$password).textField(icon: "key")
            Button{
                addUser()
            } label: {
                Text("注册")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(RoundedRectangle(cornerRadius: 20).stroke(.linearGradient(colors: [.white.opacity(0.8), .black.opacity(0.2)], startPoint: .top, endPoint: .bottom)))
            }
            Divider()
            HStack {
                Text("已有账号？**点击登录**").font(.footnote)
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
    
    func addUser() {
            guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
                // Show an error message to the user
                error = "输入格式不正确"
                return
            }

            if let _ = DBService.shared.addUser(name: name, email: email, password: password) {
                error = "注册成功！"
            } else {
                error = "注册失败！"
            }
        }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environmentObject(Modal())
    }
}
