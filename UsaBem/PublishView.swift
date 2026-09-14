import SwiftUI
import PhotosUI
import CoreLocation

struct PublishView: View {
    @EnvironmentObject var locationMgr: LocationManager
    @State private var title       = ""
    @State private var description = ""
    @State private var price       = ""
    @State private var condition   = "Semi-novo"
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var photoImages:   [UIImage]           = []
    @State private var showCamera    = false
    @State private var cameraImage:   UIImage?
    @State private var locationText  = "Usar minha localização"
    @State private var locationSet   = false
    @State private var showSuccess   = false

    let conditions = ["Novo", "Semi-novo", "Usado"]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    // ── Photo Area ──────────────────────────────────────────
                    photoArea
                        .padding()

                    Divider().padding(.horizontal)

                    // ── Form ────────────────────────────────────────────────
                    VStack(alignment: .leading, spacing: 20) {

                        fieldSection("TÍTULO") {
                            TextField("Ex: Sofá 3 lugares cinza...", text: $title)
                                .textFieldStyle(.plain)
                                .font(.system(size: 15))
                                .padding(12)
                                .background(Color(.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.separator), lineWidth: 0.5))
                        }

                        fieldSection("ESTADO") {
                            HStack(spacing: 8) {
                                ForEach(conditions, id: \.self) { c in
                                    Button { condition = c } label: {
                                        Text(c)
                                            .font(.system(size: 13, weight: .semibold))
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                            .background(condition == c ? Color("BrandGreenLight") : Color(.systemBackground))
                                            .foregroundStyle(condition == c ? Color("BrandGreenDark") : .secondary)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(condition == c ? Color("BrandGreen") : Color(.separator), lineWidth: 1.5)
                                            )
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                    .buttonStyle(.plain)
                                    .animation(.spring(duration: 0.2), value: condition)
                                }
                            }
                        }

                        fieldSection("PREÇO") {
                            HStack(spacing: 0) {
                                Text("R$")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundStyle(.secondary)
                                    .frame(width: 44, height: 46)
                                    .background(Color(.secondarySystemBackground))
                                Divider().frame(height: 46)
                                TextField("0,00", text: $price)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(.plain)
                                    .font(.system(size: 15))
                                    .padding(.horizontal, 12)
                            }
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.separator), lineWidth: 0.5))
                        }

                        fieldSection("DESCRIÇÃO") {
                            ZStack(alignment: .topLeading) {
                                if description.isEmpty {
                                    Text("Descreva o item: medidas, cor, estado...")
                                        .foregroundStyle(.tertiary)
                                        .font(.system(size: 15))
                                        .padding(14)
                                }
                                TextEditor(text: $description)
                                    .font(.system(size: 15))
                                    .frame(minHeight: 90)
                                    .padding(8)
                                    .scrollContentBackground(.hidden)
                            }
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.separator), lineWidth: 0.5))
                        }

                        fieldSection("LOCALIZAÇÃO") {
                            Button { requestLocation() } label: {
                                HStack(spacing: 10) {
                                    Image(systemName: "location.fill")
                                        .foregroundStyle(Color("BrandGreen"))
                                    Text(locationText)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundStyle(locationSet ? Color("BrandGreenDark") : .primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.tertiary)
                                }
                                .padding(14)
                                .background(Color(.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(locationSet ? Color("BrandGreen") : Color(.separator), lineWidth: locationSet ? 1.5 : 0.5)
                                )
                            }
                            .buttonStyle(.plain)
                        }

                        // Publish button
                        Button {
                            showSuccess = true
                        } label: {
                            Label("Publicar anúncio grátis", systemImage: "checkmark")
                                .font(.system(size: 15, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding(15)
                                .background(Color("BrandGreenDark"))
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .shadow(color: Color("BrandGreenDark").opacity(0.35), radius: 10, y: 4)
                        }
                        .padding(.top, 6)
                        .padding(.bottom, 24)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Anunciar")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showCamera) { CameraView(image: $cameraImage) }
            .alert("Anúncio publicado! 🎉", isPresented: $showSuccess) {
                Button("OK") { }
            } message: {
                Text("Seu anúncio já está visível para compradores perto de você.")
            }
        }
    }

    // ── Photo Grid ───────────────────────────────────────────────────────────
    var photoArea: some View {
        VStack(alignment: .leading, spacing: 12) {
            if photoImages.isEmpty {
                // Big dashed add area
                PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 10, matching: .images) {
                    VStack(spacing: 8) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(Color("BrandGreen").opacity(0.7))
                        Text("Adicionar fotos")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.secondary)
                        Text("0 / 10")
                            .font(.system(size: 11))
                            .foregroundStyle(.tertiary)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 110)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
                            .foregroundStyle(Color(.separator))
                    )
                }
                .onChange(of: selectedPhotos) { loadPhotos() }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(photoImages.indices, id: \.self) { i in
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: photoImages[i])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))

                                Button { photoImages.remove(at: i) } label: {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundStyle(.white)
                                        .frame(width: 20, height: 20)
                                        .background(.red)
                                        .clipShape(Circle())
                                        .shadow(radius: 2)
                                }
                                .offset(x: 6, y: -6)
                            }
                        }
                        if photoImages.count < 10 {
                            PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 10 - photoImages.count, matching: .images) {
                                VStack(spacing: 4) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundStyle(Color("BrandGreen"))
                                    Text("\(photoImages.count)/10")
                                        .font(.system(size: 9))
                                        .foregroundStyle(.tertiary)
                                }
                                .frame(width: 80, height: 80)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .onChange(of: selectedPhotos) { loadPhotos() }
                        }
                    }
                }
                // Camera button
                Button { showCamera = true } label: {
                    Label("Tirar outra foto", systemImage: "camera")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color("BrandGreen"))
                }
            }
        }
    }

    func loadPhotos() {
        for item in selectedPhotos {
            item.loadTransferable(type: Data.self) { result in
                if case .success(let data?) = result, let img = UIImage(data: data) {
                    DispatchQueue.main.async { photoImages.append(img) }
                }
            }
        }
        selectedPhotos = []
    }

    func requestLocation() {
        guard CLLocationManager.locationServicesEnabled() else { return }
        locationText = "Obtendo localização…"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            locationText = locationMgr.city
            locationSet  = !locationMgr.city.isEmpty && locationMgr.city != "Localização…"
        }
    }

    func fieldSection<Content: View>(_ label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.tertiary)
                .kerning(0.5)
            content()
        }
    }
}

// MARK: - Camera (UIImagePickerController wrapper)
struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) var dismiss

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate   = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView
        init(_ parent: CameraView) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let img = info[.originalImage] as? UIImage {
                parent.image = img
            }
            parent.dismiss()
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
