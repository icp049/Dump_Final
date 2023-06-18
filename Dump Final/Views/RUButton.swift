import SwiftUI

struct RUButton: View {
    
    let title: String
    let background: Color
    let action: () -> Void
    
    
    
    var body: some View {
        
        
        Button{
            action()
            
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(background)
                
                Text(title)
                    .foregroundColor(Color.white)
                    .bold()
            }
        }
    }
        
    }


struct RUButton_Previews: PreviewProvider {
    static var previews: some View {
        RUButton(title: "Login", background:.black){
        }
    }
}
