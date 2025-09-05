import SwiftUI

struct SettingView: View {
    
    let menu_items: [(id: String, value: String)] = [(id: "menu1", value: "メニュー1"), (id: "menu2", value: "メニュー2"), (id: "menu3", value: "メニュー3")]
    
    var body: some View {
        // NavigationStackでListを囲むことが必須
        NavigationStack {
            List {
                Section("ナビゲーションリンク") {
                    ForEach(menu_items, id: \.id) { menu_item in
                        // 各行をNavigationLinkでラップする
                        NavigationLink(destination: DetailView(menuItem: menu_item)) {
                            Label(menu_item.value, systemImage: "person")
                        }
                    }
                }
            }
            .navigationTitle("設定")
        }
    }
}

// 遷移先のビューを定義
struct DetailView: View {
    let menuItem: (id: String, value: String)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("詳細情報")
                .font(.headline)
            Text("ID: \(menuItem.id)")
            Text("値: \(menuItem.value)")
        }
        .padding()
        .navigationTitle(menuItem.value) // 遷移先の画面のタイトル
    }
}


#Preview {
    // プレビュー用にContentView()ではなく、SettingView()を呼び出す
    SettingView()
}
