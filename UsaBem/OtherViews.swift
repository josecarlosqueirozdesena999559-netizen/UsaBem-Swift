import SwiftUI

// MARK: - Location Permission Sheet
struct LocationPermissionSheet: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var locationMgr: LocationManager

    var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .fill(Color(.separator))
                .frame(width: 36, height: 4)
                .padding(.top, 8)

            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("BrandGreenLight"))
                    .frame(width: 72, height: 72)
                Image(systemName: "location.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(Color("BrandGreen"))
            }
            .padding(.top, 4)

            Text("Sua localização")
                .font(.system(size: 20, weight: .black, design: .rounded))

            Text("O UsaBem usa sua localização para mostrar anúncios perto de você e calcular distâncias.")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)

            Button {
                isPresented = false
                locationMgr.requestPermission()
            } label: {
                Text("Permitir localização")
                    .font(.system(size: 15, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding(14)
                    .background(Color("BrandGreenDark"))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.top, 4)

            Button { isPresented = false } label: {
                Text("Não agora")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 8)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 8)
    }
}

// MARK: - Categories View
struct CategoriesView: View {
    let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(allCategories) { cat in
                        Button { } label: {
                            VStack(spacing: 10) {
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(cat.color.opacity(0.15))
                                    .frame(width: 64, height: 64)
                                    .overlay {
                                        Image(systemName: cat.icon)
                                            .font(.system(size: 26))
                                            .foregroundStyle(cat.color)
                                    }
                                Text(cat.name)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(.primary)
                                Text("\(cat.count) anúncios")
                                    .font(.system(size: 11))
                                    .foregroundStyle(.tertiary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .black.opacity(0.05), radius: 4, y: 1)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Categorias")
        }
    }
}

// MARK: - Favorites View
struct FavoritesView: View {
    @EnvironmentObject var appState: AppState

    var favProducts: [Product] { Product.all.filter { appState.favorites.contains($0.id) } }

    var body: some View {
        NavigationStack {
            Group {
                if favProducts.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 48))
                            .foregroundStyle(Color(.quaternaryLabel))
                        Text("Nenhum favorito ainda")
                            .font(.system(size: 18, weight: .bold))
                        Text("Salve itens que você curtiu para ver depois")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(40)
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 8) {
                            ForEach(favProducts) { product in
                                NavigationLink(destination: ProductDetailView(product: product)) {
                                    ProductRowCard(product: product)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(16)
                    }
                    .background(Color(.systemGroupedBackground))
                }
            }
            .navigationTitle("Favoritos")
        }
    }
}

// MARK: - Profile View
struct ProfileView: View {
    var body: some View {
        NavigationStack {
            List {
                // Header
                Section {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [Color("BrandGreen"), Color("BrandGreenDark")], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 64, height: 64)
                            Text("MK")
                                .font(.system(size: 22, weight: .black))
                                .foregroundStyle(.white)
                        }
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Maria Keila")
                                .font(.system(size: 18, weight: .bold))
                            Text("Membro desde Jan 2024")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                            HStack(spacing: 2) {
                                ForEach(0..<5) { _ in
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 11))
                                        .foregroundStyle(.yellow)
                                }
                                Text("4.8  (23 avaliações)")
                                    .font(.system(size: 11))
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 6)

                    HStack {
                        statCell("8",  "Vendas")
                        Divider()
                        statCell("2",  "Ativos")
                        Divider()
                        statCell("12", "Favoritos")
                        Divider()
                        statCell("4.8","Avaliação")
                    }
                    .frame(height: 60)
                }

                Section("Minha conta") {
                    menuRow("person",       "Meus dados",       .blue)
                    menuRow("map.pin",      "Localização",      .green)
                    menuRow("creditcard",   "Pagamentos",       .orange)
                }

                Section("Atividade") {
                    menuRow("heart",        "Favoritos",        .pink)
                    menuRow("bag",          "Compras",          .teal)
                    menuRow("message",      "Mensagens",        .purple)
                }

                Section {
                    menuRow("questionmark.circle","Ajuda",      .gray)
                    menuRow("info.circle",  "Sobre",            .gray)
                }

                Section {
                    Button(role: .destructive) { } label: {
                        Label("Sair da conta", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle("Perfil")
        }
    }

    func statCell(_ num: String, _ label: String) -> some View {
        VStack(spacing: 2) {
            Text(num).font(.system(size: 20, weight: .black)).foregroundStyle(Color("BrandGreenDark"))
            Text(label).font(.system(size: 11)).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    func menuRow(_ icon: String, _ label: String, _ color: Color) -> some View {
        Label(label, systemImage: icon)
    }
}

// MARK: - Product Detail View
struct ProductDetailView: View {
    let product: Product
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss

    var isFav: Bool { appState.favorites.contains(product.id) }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {

                // Hero image placeholder
                ZStack {
                    Rectangle()
                        .fill(LinearGradient(colors: [Color(.tertiarySystemBackground), Color(.secondarySystemBackground)], startPoint: .top, endPoint: .bottom))
                        .frame(height: 280)
                    Image(systemName: "photo")
                        .font(.system(size: 48))
                        .foregroundStyle(.quaternary)
                }
                .ignoresSafeArea(edges: .top)

                // Content card
                VStack(alignment: .leading, spacing: 20) {

                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.name)
                                .font(.system(size: 20, weight: .black, design: .rounded))
                            Text(product.price)
                                .font(.system(size: 24, weight: .black))
                                .foregroundStyle(Color("BrandGreenDark"))
                        }
                        Spacer()
                        Button { appState.toggle(productId: product.id) } label: {
                            Image(systemName: isFav ? "heart.fill" : "heart")
                                .font(.system(size: 22))
                                .foregroundStyle(isFav ? .red : .secondary)
                                .frame(width: 44, height: 44)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                    }

                    // Tags
                    HStack(spacing: 8) {
                        tagChip("checkmark.circle.fill", "Verificado", .green)
                        tagChip("star.fill",             "Ótimo estado", .yellow)
                        tagChip("arrow.triangle.2.circlepath", "Aceita troca", .teal)
                    }

                    Divider()

                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Descrição")
                            .font(.system(size: 15, weight: .bold))
                        Text(product.description)
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                            .lineSpacing(4)
                    }

                    Divider()

                    // Location
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Localização")
                            .font(.system(size: 15, weight: .bold))
                        HStack(spacing: 8) {
                            Image(systemName: "location.fill")
                                .foregroundStyle(Color("BrandGreen"))
                            Text(product.location)
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                        }
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                            .frame(height: 80)
                            .overlay {
                                Image(systemName: "map.fill")
                                    .font(.system(size: 28))
                                    .foregroundStyle(.quaternary)
                            }
                    }

                    Divider()

                    // Seller
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Vendedor")
                            .font(.system(size: 15, weight: .bold))
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color("BrandGreen"))
                                .frame(width: 44, height: 44)
                                .overlay { Text("MK").font(.system(size: 14, weight: .black)).foregroundStyle(.white) }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Maria Keila").font(.system(size: 14, weight: .bold))
                                HStack(spacing: 2) {
                                    Image(systemName: "star.fill").font(.system(size: 10)).foregroundStyle(.yellow)
                                    Text("4.8 · 23 avaliações").font(.system(size: 11)).foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                            Text("Ver perfil")
                                .font(.system(size: 12, weight: .semibold))
                                .padding(.horizontal, 12).padding(.vertical, 6)
                                .background(Color("BrandGreenLight"))
                                .foregroundStyle(Color("BrandGreen"))
                                .clipShape(Capsule())
                        }
                    }

                    // Action buttons
                    HStack(spacing: 10) {
                        Button { } label: {
                            Label("Mensagem", systemImage: "message")
                                .font(.system(size: 15, weight: .semibold))
                                .frame(maxWidth: .infinity).padding(14)
                                .background(Color(.secondarySystemBackground))
                                .foregroundStyle(.primary)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        Button { } label: {
                            Label("Proposta", systemImage: "handshake")
                                .font(.system(size: 15, weight: .bold))
                                .frame(maxWidth: .infinity).padding(14)
                                .background(Color("BrandGreenDark"))
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .shadow(color: Color("BrandGreenDark").opacity(0.3), radius: 8, y: 3)
                        }
                    }
                    .padding(.bottom, 12)
                }
                .padding(20)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .offset(y: -22)
                .padding(.bottom, -22)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }

    func tagChip(_ icon: String, _ label: String, _ color: Color) -> some View {
        Label(label, systemImage: icon)
            .font(.system(size: 11, weight: .semibold))
            .padding(.horizontal, 10).padding(.vertical, 5)
            .background(color.opacity(0.12))
            .foregroundStyle(color.mix(with: .black, by: 0.2))
            .clipShape(Capsule())
    }
}
