import SwiftUI
import CoreLocation

// MARK: - Product
struct Product: Identifiable {
    let id: Int
    let name: String
    let price: String
    let priceValue: Double
    let imageName: String
    let description: String
    let location: String
    let distance: String
    let tag: String
    let isNew: Bool

    static let all: [Product] = [
        Product(id: 0, name: "Sofá 3 lugares Retrátil",    price: "R$ 1.200", priceValue: 1200, imageName: "sofa",      description: "Sofá 3 lugares com chaise, retrátil e reclinável. Tecido suede cinza claro. Pouquíssimo uso. Medidas: 2,80m x 1,60m.", location: "Vila Mariana, SP", distance: "2km",   tag: "Ótimo estado",    isNew: false),
        Product(id: 1, name: "Poltrona Verde Veludo",       price: "R$ 680",   priceValue: 680,  imageName: "armchair",  description: "Poltrona decorativa em veludo verde escuro. Estrutura em madeira maciça. Estado de nova, comprada há 6 meses.",         location: "Pinheiros, SP",    distance: "3,5km", tag: "Como nova",       isNew: true),
        Product(id: 2, name: "Guarda-roupa 6 Portas",       price: "R$ 2.100", priceValue: 2100, imageName: "wardrobe",  description: "Guarda-roupa 6 portas com espelho. Branco com detalhes em madeira. Amplo espaço interno.",                              location: "Moema, SP",        distance: "5km",   tag: "Bom estado",      isNew: false),
        Product(id: 3, name: "Mesa de Jantar 6 lugares",    price: "R$ 1.850", priceValue: 1850, imageName: "dining",    description: "Mesa de jantar em madeira maciça para 6 pessoas. Acompanha 6 cadeiras estofadas. Medidas: 1,80m x 90cm.",              location: "Santana, SP",      distance: "8km",   tag: "Madeira maciça",  isNew: false),
        Product(id: 4, name: "Estante Industrial",           price: "R$ 790",   priceValue: 790,  imageName: "bookshelf", description: "Estante industrial em metal preto e madeira. 5 prateleiras. Medidas: 1,80m x 80cm x 25cm.",                             location: "Lapa, SP",         distance: "4km",   tag: "Metal e madeira", isNew: false),
        Product(id: 5, name: "Cama Box Queen Size",          price: "R$ 3.200", priceValue: 3200, imageName: "bed",       description: "Cama box queen completa (base + colchão Ortobom). Cabeceira estofada cinza. Medida: 1,58m x 1,98m.",                  location: "Itaim Bibi, SP",   distance: "6km",   tag: "Com colchão",     isNew: false),
    ]
}

// MARK: - Category
struct Category: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let count: Int
}

let allCategories: [Category] = [
    Category(name: "Sofás",     icon: "sofa",            color: .green,  count: 243),
    Category(name: "Camas",     icon: "bed.double",      color: .blue,   count: 187),
    Category(name: "Mesas",     icon: "chair",           color: .orange, count: 312),
    Category(name: "Armários",  icon: "cabinet",         color: .purple, count: 198),
    Category(name: "Decoração", icon: "leaf",            color: .pink,   count: 521),
    Category(name: "Eletro",    icon: "bolt",            color: .teal,   count:  89),
    Category(name: "Escritório",icon: "briefcase",       color: .indigo, count: 134),
    Category(name: "Infantil",  icon: "star",            color: .yellow, count:  76),
]

// MARK: - App State (ObservableObject shared store)
class AppState: ObservableObject {
    @Published var favorites: Set<Int> = []
    @Published var userCity: String = "Localização…"
    @Published var locationReady = false

    func toggle(productId: Int) {
        if favorites.contains(productId) {
            favorites.remove(productId)
        } else {
            favorites.insert(productId)
        }
    }
}
