import Foundation
import AVFoundation
import Vision
import CoreML
import Combine


class CameraManager: NSObject, ObservableObject {


    @Published var detectedObject = "Scanning..."


    private let captureSession = AVCaptureSession()

    private let videoOutput = AVCaptureVideoDataOutput()


    private var visionRequest: VNCoreMLRequest?



    private var lastSpokenObject = ""

    private var lastSpeechTime = Date.distantPast





    override init() {

        super.init()

        print("Camera Manager Started")

        setupModel()

        setupCamera()

    }






    // MARK: - YOLO MODEL


    private func setupModel(){


        do {


            let config = MLModelConfiguration()


            let coreMLModel = try yolov8n(
                configuration: config
            ).model



            let visionModel =
            try VNCoreMLModel(
                for: coreMLModel
            )



            visionRequest =
            VNCoreMLRequest(
                model: visionModel
            ){ [weak self] request,error in



                if let error {

                    print(error)

                    return
                }



                self?.handleDetection(
                    request
                )


            }




            visionRequest?
                .imageCropAndScaleOption = .scaleFill




            print("YOLO Loaded ✅")



        }
        catch {

            print(
                "YOLO Load Failed",
                error
            )

        }


    }









    // MARK: - DETECTION


    private func handleDetection(
        _ request: VNRequest
    ){


        guard let results =
                request.results as?
                [VNRecognizedObjectObservation]

        else {

            return

        }




        guard let object =
                results.first

        else {

            return

        }




        let label =
        object.labels.first?.identifier ?? "unknown"



        let confidence =
        object.labels.first?.confidence ?? 0




        if confidence > 0.5 {



            DispatchQueue.main.async {


                self.detectedObject =
                "\(label) \(Int(confidence*100))%"



                self.speak(
                    label
                )



            }


        }


    }










    // MARK: - SPEECH


    private func speak(
        _ object:String
    ){



        let now = Date()



        if object == lastSpokenObject &&
            now.timeIntervalSince(lastSpeechTime) < 3 {


            return

        }




        lastSpokenObject = object

        lastSpeechTime = now




        SpeechManager.shared.speak(
            "\(object) detected"
        )


    }











    // MARK: - CAMERA SETUP


    private func setupCamera(){



        captureSession.beginConfiguration()


        captureSession.sessionPreset = .high




        guard let camera =
                AVCaptureDevice.default(
                    .builtInWideAngleCamera,
                    for: .video,
                    position: .back
                )

        else {

            print("No camera")

            return

        }





        do {


            let input =
            try AVCaptureDeviceInput(
                device: camera
            )



            if captureSession.canAddInput(input){

                captureSession.addInput(input)

            }




            videoOutput.setSampleBufferDelegate(
                self,
                queue:
                    DispatchQueue(
                        label:"yolo.camera.queue"
                    )
            )



            videoOutput.alwaysDiscardsLateVideoFrames = true





            if captureSession.canAddOutput(videoOutput){

                captureSession.addOutput(
                    videoOutput
                )

            }





        }
        catch {

            print(
                "Camera Error",
                error
            )

        }




        captureSession.commitConfiguration()



    }









    // MARK: - START


    func startCamera(){


        DispatchQueue.global(
            qos:.userInitiated
        ).async {



            if !self.captureSession.isRunning {


                self.captureSession.startRunning()



                print(
                    "Camera Running ✅"
                )


            }


        }


    }







    func stopCamera(){


        if captureSession.isRunning {


            captureSession.stopRunning()


        }


    }







    func getSession()
    -> AVCaptureSession {


        return captureSession

    }



}









// MARK: - VIDEO DELEGATE


extension CameraManager:
AVCaptureVideoDataOutputSampleBufferDelegate {



    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ){



        guard let pixelBuffer =
                CMSampleBufferGetImageBuffer(
                    sampleBuffer
                )

        else {

            return

        }




        let handler =
        VNImageRequestHandler(
            cvPixelBuffer: pixelBuffer
        )



        do {


            if let request = visionRequest {


                try handler.perform(
                    [request]
                )


            }


        }
        catch {


            print(
                "Vision Error",
                error
            )


        }



    }



}
