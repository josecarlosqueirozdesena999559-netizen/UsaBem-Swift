# UsaBem — App Nativo iOS (Swift + SwiftUI)

## Estrutura dos arquivos

UsaBem/
├── UsaBemApp.swift         → Ponto de entrada (@main)
├── ContentView.swift       → TabView raiz com 5 abas
├── Models.swift            → Product, Category, AppState (ObservableObject)
├── LocationManager.swift   → CLLocationManager (GPS real + geocodificacao)
├── HomeView.swift          → Tela inicial (saudacao, busca, pills, banner, grid)
├── PublishView.swift       → Anunciar (camera real, galeria, formulario, GPS)
├── OtherViews.swift        → Categorias, Favoritos, Perfil, Detalhe do produto
└── Info.plist              → Permissoes (localizacao, camera, galeria)

## Como abrir no Xcode

1. Abra o Xcode (Mac necessario)
2. File → New → Project → App (iOS)
   - Product Name: UsaBem
   - Interface: SwiftUI
   - Language: Swift
3. Apague os arquivos padrao gerados
4. Arraste todos os .swift desta pasta para o projeto
5. Copie o Info.plist (substitua o existente com as chaves de permissao)
6. Em Assets.xcassets, crie as cores:
   - BrandGreen:     #2D6A4F
   - BrandGreenDark: #1B4332
   - BrandGreenLight:#D8F3DC
   - AccentMint:     #52B788
7. Run no simulador iPhone 15 (iOS 17+)

## Permissoes nativas declaradas

| Permissao        | Chave plist                          | Uso                          |
|------------------|--------------------------------------|------------------------------|
| Localizacao      | NSLocationWhenInUseUsageDescription  | Mostrar anuncios proximos    |
| Camera           | NSCameraUsageDescription             | Tirar foto do produto        |
| Galeria (leitura)| NSPhotoLibraryUsageDescription       | Escolher foto da galeria     |
| Galeria (escrita)| NSPhotoLibraryAddUsageDescription    | Salvar imagem                |

## APIs nativas usadas

- CoreLocation     → GPS real, CLLocationManager, CLGeocoder (bairro/cidade)
- PhotosUI         → PhotosPicker (galeria nativa iOS 16+)
- UIImagePickerController → Camera nativa
- SwiftUI TabView  → Navegacao nativa por abas
- SwiftUI NavigationStack → Navegacao de detalhe com swipe-back nativo
