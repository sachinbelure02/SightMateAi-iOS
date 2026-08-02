//
//  HomeView.swift
//  SightMateAi
//
//  Created by Sachin Belure on 01/08/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            Text("SightMate AI")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Your AI Vision Assistant")
                .foregroundColor(.gray)
            
            Button {
                // Camera feature later add karenge
            } label: {
                Text("Start")
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
