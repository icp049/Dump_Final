import SwiftUI

struct ScrapbookView: View {
    @State private var newItemPresented = false
    
    var body: some View {
        VStack {
            Text("Scrapbook View")
            
            Button(action: {
                newItemPresented = true
            }) {
                Text("Upload")
            }
            .sheet(isPresented: $newItemPresented) {
                UploadView(newItemPresented: $newItemPresented)
            }
        }
    }
}

struct UploadView: View {
    @State private var selectedImage: Image?
    @State private var showImagePicker = false
    @State private var caption = ""
    
    @Binding var newItemPresented: Bool
    
    var isImageSelected: Bool {
        selectedImage != nil
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if isImageSelected {
                    selectedImage!
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("Select an image")
                }
                
                Button(action: {
                    showImagePicker = true
                }) {
                    Text("Choose Image")
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(selectedImage: $selectedImage)
                }
                
                TextField("Enter caption", text: $caption)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                NavigationLink(
                    destination: ScrapbookView(),
                    isActive: $newItemPresented,
                    label: { EmptyView() }
                )
                .isDetailLink(false)
                
                Button(action: {
                    // Perform the post action
                    if isImageSelected {
                        // Upload the image and caption
                        // ...
                    }
                    newItemPresented = false
                }) {
                    Text("Post")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationBarTitle("Upload")
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: Image?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = Image(uiImage: uiImage)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ScrapbookView()
    }
}

