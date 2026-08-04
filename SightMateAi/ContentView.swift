import SwiftUI

struct ContentView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            HomeView()
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
            // Full Black Background
            Color.black
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Logo Image
                Image("SplashLogo")
                    .renderingMode(.original)
                    .interpolation(.high)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 150, maxHeight: 150)
                
                // App Title Text
                Text("SightMate AI")
                    // Custom font style (Avenir Next, Helvetica Neue, Futura, etc.)
                    .font(.custom("AvenirNext-Bold", size: 17))
                    .foregroundColor(.white)
                    // Text ko niche khiske ke liye gap/padding
                    .padding(.top, 35)
                
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
