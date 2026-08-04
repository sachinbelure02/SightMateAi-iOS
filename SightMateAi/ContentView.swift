import SwiftUI

struct ContentView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            CameraPermissionView()
        } else {
            SplashView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            self.isActive = true
                        }
                    }
                }
        }
    }
}


struct SplashView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Image("SplashLogo")
                    .renderingMode(.original)
                    .interpolation(.high)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 150, maxHeight: 150)
                
                Text("SightMate AI")
                    .font(.custom("AvenirNext-Bold", size: 17))
                    .foregroundColor(.white)
                    .padding(.top, 35)
                
                Spacer()
            }
        }
    }
}


#Preview {
    ContentView()
}
