import SwiftUI

struct PhotoView: View {
    var image: UIImage

    var body: some View {
        ZStack {
            Color.black // Background color (you can customize this)
            
            // Display the selected image with the ability to pinch-zoom and drag
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .gesture(
                    MagnificationGesture()
                        .onChanged { scale in
                            // Handle pinch-zoom here (optional)
                        }
                )
                .offset(x: 0, y: 0) // Handle drag gesture here (optional)
                .animation(.easeInOut(duration: 0.3)) // Optional animation
            
            // Add a close button to dismiss the PhotoView
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        // Dismiss the PhotoView when the close button is tapped
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                    }
                    .padding()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }

    // Function to dismiss the PhotoView
    private func dismiss() {
        // Implement the necessary logic to dismiss the PhotoView
        // You can use a @Binding or @State variable to control the presentation of this view
        // For example, in the parent view, you can have a @State variable named `isShowingPhotoView`
        // When this variable is set to false, the PhotoView will be dismissed.
        // In the parent view, you can do: `isShowingPhotoView = false`
        // This will trigger the dismissal of the PhotoView due to the use of `fullScreenCover` modifier.
    }
}

