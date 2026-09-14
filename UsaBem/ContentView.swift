import SwiftUI

struct ContentView: View {
    @StateObject private var appState       = AppState()
    @StateObject private var locationMgr    = LocationManager()
    @State private var selectedTab: Tab     = .home
    @State private var showLocPermission    = false

    enum Tab { case home, categories, publish, favorites, profile }

    var body: some View {
        TabView(selection: $selectedTab) {

            HomeView(showLocPermission: $showLocPermission)
                .tabItem { Label("Início",      systemImage: "house.fill") }
                .tag(Tab.home)

            CategoriesView()
                .tabItem { Label("Categorias",  systemImage: "square.grid.2x2.fill") }
                .tag(Tab.categories)

            PublishView()
                .tabItem { Label("Anunciar",    systemImage: "plus.circle.fill") }
                .tag(Tab.publish)

            FavoritesView()
                .tabItem { Label("Favoritos",   systemImage: "heart.fill") }
                .tag(Tab.favorites)

            ProfileView()
                .tabItem { Label("Perfil",      systemImage: "person.fill") }
                .tag(Tab.profile)
        }
        .tint(Color("BrandGreen"))
        .environmentObject(appState)
        .environmentObject(locationMgr)
        .sheet(isPresented: $showLocPermission) {
            LocationPermissionSheet(isPresented: $showLocPermission)
                .environmentObject(locationMgr)
                .presentationDetents([.height(340)])
                .presentationCornerRadius(28)
        }
        .onAppear {
            // Ask for location on first launch
            if locationMgr.status == .notDetermined {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    showLocPermission = true
                }
            }
        }
    }
}
