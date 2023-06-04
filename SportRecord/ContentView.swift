//
//  ContentView.swift
//  SportRecord
//  Created by 张凌浩 on 2023/5/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modal : Modal
    @EnvironmentObject var userSettings : UserSettings
    var body: some View {
        TabView{
            RecordView().tabItem(){
                Image(systemName: "figure.run")
                Text("运动")
            }
            StatsView().tabItem(){
                Image(systemName: "clock.arrow.circlepath")
                Text("统计")
            }
            AccountView().tabItem(){
                Image(systemName: "person.fill")
                Text("用户")
            }
        }
        .fullScreenCover(isPresented: $userSettings.isNotLoggedIn){
            if(modal.signIn){
                LoginView()
            } else {
                RegisterView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserSettings())
            .environmentObject(Modal())
    }
}
