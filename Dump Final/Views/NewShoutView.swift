import SwiftUI

struct NewShoutView: View {
    @StateObject var viewModel = NewShoutViewViewModel()
    @Binding var newItemPresented: Bool
    
    
    
    var body : some View {
        VStack{
            Text("What's on your mind?")
                .font(.system(size:32))
                .bold()
                .padding(.top, 100)
            
            Form {
                //shout
                TextField("Just type it!", text: $viewModel.shout)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .frame(height: 80)
                    .autocorrectionDisabled()
                
                
                
                RUButton(title: "Shout", background: .green)
                {
                    viewModel.saveShout()
                    newItemPresented = false
                }
                
                RUButton(title: "Rant", background: .red)
                {
                    viewModel.saveRant()
                    newItemPresented = false
                }
            }
        }
    }
}


struct NewShoutView_Previews: PreviewProvider{
    static var previews: some View{
        NewShoutView(newItemPresented: Binding(get: {
            return true
        }, set: { _ in
        }))
    }
    
}
