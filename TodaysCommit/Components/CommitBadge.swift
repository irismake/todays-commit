import SwiftUI

struct CommitBadge: View {
  let content: String
    
  var body: some View {
    ZStack {
      Circle()
        .fill(Color.green.opacity(0.1))
        .frame(width: 46, height: 46)
               
      VStack(spacing: 2) {
        Image("icon_commit")
          .resizable()
          .scaledToFit()
          .frame(height: 20)
                          
        Text(content)
          .font(.system(size: 10, weight: .semibold))
          .foregroundColor(.primary)
      }
    }
  }
  
  struct CommitBadge_Previews: PreviewProvider {
    static var previews: some View {
      CommitBadge(content: "2회")
    }
  }
}
