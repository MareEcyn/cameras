import SwiftUI

struct CamerasListView: View {
    @StateObject var model: CamerasViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                switch model.status {
                case .initial:
                    EmptyView()
                case .loading:
                    HintView("Загрузка...")
                        .frame(width: geometry.size.width, height: geometry.size.height)
                case .complete:
                    ForEach(model.items, id: \.id) { camera in
                        NavigationLink(destination: CameraStreamView(request: model.getPreviewRequest(forCamera: camera.id))) {
                            CameraCardView(title: camera.title, image: camera.preview)
                        }
                        .foregroundColor(.black)
                    }
                case .error:
                    HintView("Что-то пошло не так")
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            .navigationTitle("Камеры")
            .onAppear {
                model.fetch(itemsCount: 10)
            }
        }
    }
}

// MARK: - Embedded views

struct CameraCardView: View {
    let title: String
    let image: UIImage
    
    var body: some View {
        VStack(alignment: .leading) {
            CameraTitleView(title)
            CameraPreviewView(image: image)
            Divider()
        }
        .frame(minWidth: 0,
               maxWidth: .infinity,
               minHeight: 0,
               maxHeight: .infinity)
        .padding(16)
    }
}

struct CameraTitleView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.semibold)
    }
    
    init(_ title: String) {
        self.title = title
    }
}

struct CameraPreviewView: View {
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
    }
}
