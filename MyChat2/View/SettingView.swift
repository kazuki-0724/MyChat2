//
//  HomeView.swift
//  MyChat2
//
//

import SwiftUI

struct SettingView: View {
    
    let menu_items: [(id: String, value: String)] = [(id: "menu1", value: "メニュー1"),(id: "menu2", value: "メニュー2"),(id: "menu3", value: "メニュー3")]
    
    var body: some View {
        List{
            // SectionはListの中で使ってあげるパーツ
            Section("Sample1"){
                // ForEachで回すコレクションは元がidentifialeか明示的に指定するかが必要
                ForEach(menu_items,id: \.id){menu_item in
                    Label(menu_item.value,systemImage: "person")
                }
            }
            Section("Sample2"){
                ForEach(menu_items,id: \.id){menu_item in
                    Label(menu_item.value,systemImage: "person")
                }
            }
        }
    }
}


#Preview {
    ContentView()
}


