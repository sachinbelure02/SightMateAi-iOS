//
//  CameraPermissionView.swift
//  SightMate Ai
//
//  Created by Sachin Belure on 04/08/26.
//

import SwiftUI
import AVFoundation

struct CameraPermissionView: View {
    
    @State private var cameraGranted = false
    
    var body: some View {
        VStack(spacing: 25) {
            
            Image(systemName: "camera.fill")
                .font(.system(size: 70))
                .foregroundColor(.blue)
            
            Text("Camera Access Required")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("SightMate AI uses your camera to identify objects around you.")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            Button {
                requestCameraPermission()
            } label: {
                Text("Allow Camera Access")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }
            .padding(.horizontal)
            
        }
        .fullScreenCover(isPresented: $cameraGranted) {
            CameraView()
        }
    }
    
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    cameraGranted = true
                }
            }
        }
    }
}
