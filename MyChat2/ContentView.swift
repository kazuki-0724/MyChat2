//
//  ContentView.swift
//  MyChat2
//
//

import SwiftUI

// UIの親View
struct ContentView: View {
    
    @StateObject private var viewModel = TalkViewModel()
    
    var body: some View {
        VStack(spacing: 0){
            // ヘッダー部
            HStack{
                Text("My Chat2")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.vertical, 5)
                    .padding(.leading, 10)
                Spacer()
            }
            .background(.teal)
            .foregroundColor(.white)
            
            // タブ
            TabView{
                // HomeViewの中でNavigationLinkを使うため、NavigationStackで囲っておく
                NavigationStack{
                    HomeView().environmentObject(viewModel)
                    
                }.tabItem{
                    Label("Home",systemImage: "house")
                }
                
                WebBridgeView()
                    .tabItem{
                        Label("WebView",systemImage: "safari.fill")
                    }
                
//                SettingView()
//                    .tabItem{
//                        Label("Settings",systemImage: "gearshape.fill")
//                    }
            }
            .contentMargins(3)
        }
    }
}

#Preview {
    ContentView()
}

