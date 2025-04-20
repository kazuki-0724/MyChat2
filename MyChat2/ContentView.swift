//
//  ContentView.swift
//  MyChat2
//
//

import SwiftUI

// UIの親View
struct ContentView: View {
    
    // 全体表示を制御するフラグ
    @State private var isFullScreen = false
    // データを保持する構造体
    @State private var viewModel = TalkViewModel()
    // API呼び出し用のクラス
    let apiClient = APIClient()
    
    var body: some View {
        VStack(spacing: 0){
            // ヘッダー部
            HStack{
                Text("My Chat2")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(5)
                Spacer()
            }
            .background(.teal)
            .foregroundColor(.white)
            
            // タブ
            TabView{
                // HomeViewの中でNavigationLinkを使うため、NavigationStackで囲っておく
                NavigationStack{
                    HomeView(isFullScreen: $isFullScreen,apiClient: apiClient).environmentObject(viewModel)
                }.tabItem{
                    Label("Home",systemImage: "house")
                }
                
                NewsView()
                    .tabItem{
                    Label("News",systemImage: "newspaper.fill")
                }
                
                SettingView()
                    .tabItem{
                        Label("Settings",systemImage: "gearshape.fill")
                    }
            }
            .contentMargins(3)
        }
    }
}

#Preview {
    ContentView()
}

