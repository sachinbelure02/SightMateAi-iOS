//
//  CameraView.swift
//  SightMate Ai
//
//  Created by Sachin Belure on 04/08/26.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    
    var body: some View {
        ZStack {
            
            CameraPreview()
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                Button {
                    // Scan action later
                } label: {
                    Image(systemName: "camera.circle.fill")
                        .font(.system(size: 70))
                        .foregroundColor(.white)
                }
                .padding(.bottom, 40)
            }
        }
    }
}


struct CameraPreview: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView()
        
        let session = AVCaptureSession()
        session.sessionPreset = .high
        
        guard let camera = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .back
        ) else {
            return view
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
        } catch {
            print(error)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = UIScreen.main.bounds
        
        view.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
