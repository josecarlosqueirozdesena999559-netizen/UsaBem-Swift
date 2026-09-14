import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var locationMgr: LocationManager
    @Binding var showLocPermission: Bool
    @State private var selectedCategory = "Todos"

    let pillCategories = ["Todos","Sofas","Camas","Mesas","Armarios","Decoracao"]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    headerView
                    searchBarView
                    pillsView
                    bannerView
                    featuredGrid
                    nearbyList
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
        }
    }

    // MARK: Header
    var headerView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 3) {
                Button { showLocPermission = true } label: {
                    HStack(spacing: 4) {
                        Image(systemName: locationMgr.status == .authorizedWhenInUse ? "location.fill" : "location")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(locationMgr.status == .authorizedWhenInUse ? Color("BrandGreen") : Color(.secondaryLabel))
                        Text(locationMgr.isLoading ? "Obtendo localizacao..." : locationMgr.city)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(locationMgr.status == .authorizedWhenInUse ? Color(.label) : Color(.secondaryLabel))
                        Image(systemName: "chevron.down")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundStyle(Color(.tertiaryLabel))
                    }
                }
                .buttonStyle(.plain)

                Text("Ola, Maria \u{1F44B}")
                    .font(.system(size: 22, weight: .black, design: .rounded))
            }
            Spacer()
            ZStack(alignment: .topTrailing) {
                Image(systemName: "bell")
                    .font(.system(size: 18, weight: .medium))
                    .frame(width: 40, height: 40)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(Circle())
                Circle().fill(.red).frame(width: 8).offset(x: 1, y: 1)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 10)
        .background(Color(.systemBackground))
    }

    // MARK: Search
    var searchBarView: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass").foregroundStyle(.secondary).font(.system(size: 14))
            Text("Buscar moveis, decoracao...")
                .foregroundStyle(.tertiary).font(.system(size: 14))
            Spacer()
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("BrandGreen"))
                .frame(width: 34, height: 34)
                .overlay { Image(systemName: "slider.horizontal.3").foregroundStyle(.white).font(.system(size: 13)) }
        }
        .padding(.horizontal, 14)
        .frame(height: 46)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 20).padding(.bottom, 10)
        .background(Color(.systemBackground))
    }

    // MARK: Pills
    var pillsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(pillCategories, id: \.self) { cat in
                    Button { selectedCategory = cat } label: {
                        Text(cat)
                            .font(.system(size: 13, weight: .semibold))
                            .padding(.horizontal, 14).padding(.vertical, 7)
                            .background(selectedCategory == cat ? Color("BrandGreenDark") : Color(.secondarySystemBackground))
                            .foregroundStyle(selectedCategory == cat ? .white : .secondary)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .animation(.spring(duration: 0.2), value: selectedCategory)
                }
            }
            .padding(.horizontal, 20).padding(.bottom, 14)
        }
        .background(Color(.systemBackground))
    }

    // MARK: Banner
    var bannerView: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(colors: [Color("BrandGreenDark"), Color("BrandGreen")], startPoint: .topLeading, endPoint: .bottomTrailing)
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("\u{2736}  12.400 anuncios")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color("AccentMint"))
                    Text("Moveis unicos\nperto de voce")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                }
                Spacer()
                Label("Explorar", systemImage: "arrow.right")
                    .font(.system(size: 12, weight: .bold)).foregroundStyle(.white)
                    .padding(.horizontal, 14).padding(.vertical, 8)
                    .background(.ultraThinMaterial, in: Capsule())
                    .environment(\.colorScheme, .dark)
            }
            .padding(18)
        }
        .frame(height: 148)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 16).padding(.top, 14)
    }

    // MARK: Featured grid
    var featuredGrid: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader("Em destaque")
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 11), GridItem(.flexible())], spacing: 11) {
                ForEach(Product.all.prefix(4)) { p in
                    NavigationLink(destination: ProductDetailView(product: p)) {
                        ProductCard(product: p)
                    }.buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 16).padding(.top, 22)
    }

    // MARK: Nearby list
    var nearbyList: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader("Perto de voce")
            VStack(spacing: 8) {
                ForEach(Product.all.suffix(2)) { p in
                    NavigationLink(destination: ProductDetailView(product: p)) {
                        ProductRowCard(product: p)
                    }.buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 16).padding(.top, 22).padding(.bottom, 20)
    }

    func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title).font(.system(size: 17, weight: .black, design: .rounded))
            Spacer()
            Text("Ver todos").font(.system(size: 13, weight: .semibold)).foregroundStyle(Color("BrandGreen"))
        }
    }
}

struct ProductCard: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
                    .frame(height: 140)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 32))
                            .foregroundStyle(.tertiary)
                    )
                
                Text(product.tag)
                    .font(.system(size: 10, weight: .bold))
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(.thinMaterial, in: Capsule())
                    .padding(8)
            }
            
            Text(product.name)
                .font(.system(size: 13, weight: .semibold))
                .lineLimit(1)
                .foregroundStyle(.primary)

            Text(product.price)
                .font(.system(size: 15, weight: .black, design: .rounded))
                .foregroundStyle(Color("BrandGreen"))

            HStack(spacing: 3) {
                Image(systemName: "location.fill").font(.system(size: 9))
                Text("\(product.location) • \(product.distance)").font(.system(size: 11))
            }
            .foregroundStyle(.secondary)
        }
    }
}

struct ProductRowCard: View {
    let product: Product

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 24))
                        .foregroundStyle(.tertiary)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.primary)

                Text(product.price)
                    .font(.system(size: 15, weight: .black, design: .rounded))
                    .foregroundStyle(Color("BrandGreen"))

                HStack(spacing: 3) {
                    Image(systemName: "location.fill").font(.system(size: 9))
                    Text("\(product.location) • \(product.distance)").font(.system(size: 11))
                }
                .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(10)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
