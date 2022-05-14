//
//  CameraController.swift
//  Study Time
//
//  Created by Caleb Arendse on 9/23/17.
//  Copyright © 2017 Caleb Arendse. All rights reserved.
//

import AVFoundation
import UIKit

class CameraController{
    var captureSession: AVCaptureSession?
    
    var frontCamera: AVCaptureDevice?
    var rearCamera: AVCaptureDevice?
    
    var currentCameraPosition: CameraPosition?
    
    var frontCameraInput: AVCaptureDeviceInput?
    var rearCameraInput: AVCaptureDeviceInput?
    
    var photoOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?

}

extension CameraController {

    func prepare(completionHandler: @escaping (Error?) -> Void){
        func createCaptureSession()throws{
            self.captureSession = AVCaptureSession()
        }
        
        func configureCaptureDevices()throws{
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
            let cameras =  (session.devices.flatMap{ $0 })

            for camera in cameras {
                if camera.position == .front{
                    self.frontCamera = camera
                }
                if camera.position == .back{
                    self.rearCamera = camera
                    
                    try camera.lockForConfiguration()
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
            }
        }
        
        func configureDeviceInputs()throws{
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing}
            
            if let rearCamera = self.rearCamera{
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                if captureSession.canAddInput(self.rearCameraInput!){captureSession.addInput(self.rearCameraInput!)}
                self.currentCameraPosition = .rear
            }
            else if let frontCamera = self.frontCamera{
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                if captureSession.canAddInput(self.frontCameraInput!){
                    captureSession.addInput(self.frontCameraInput!)}
                else{
                    throw CameraControllerError.inputAreInvalid}
                self.currentCameraPosition = .front
                
                }
            else{throw CameraControllerError.noCameraAvailable}
            
            }
        
        func configurePhotoOutputs()throws {
            guard let captureSession = self.captureSession else{
                throw CameraControllerError.captureSessionIsMissing
            }
            self.photoOutput = AVCapturePhotoOutput()
            self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecJPEG])], completionHandler: nil)
            if captureSession.canAddOutput(self.photoOutput!){captureSession.addOutput(self.photoOutput!)}
            
            captureSession.startRunning()
        }
    
        DispatchQueue(label: "prepare").async{
            do{
                try createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutputs()
                
            }
            catch{
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
}

extension CameraController{
    enum CameraControllerError: Swift.Error{
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputAreInvalid
        case invalidOperation
        case noCameraAvailable
        case unknown
    }


public enum CameraPosition {
    case front
    case rear
}
    func displayPreview(on view: UIView) throws {
        guard let captureSession = self.captureSession, captureSession.isRunning else{ throw CameraControllerError.captureSessionIsMissing}
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.frame
    }
    
    func switchCameras() throws{
        
        guard let currentCameraPosition = currentCameraPosition, let captureSession = self.captureSession, captureSession.isRunning else{throw CameraControllerError.captureSessionIsMissing}
        
        captureSession.beginConfiguration()
        
        func switchToFrontCamera() throws{
            guard let inputs = captureSession.inputs as? [AVCaptureInput], let rearCameraInput = self.rearCameraInput, inputs.contains(rearCameraInput),
                let frontCamera = self.frontCamera else{ throw CameraControllerError.invalidOperation}
            self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            captureSession.removeInput(rearCameraInput)
            
            if (captureSession.canAddInput(self.frontCameraInput!)){
                captureSession.addInput(self.frontCameraInput!)
                self.currentCameraPosition = .front
            }
            else {throw CameraControllerError.invalidOperation}
            
        }
        func switchToRearCamera() throws{
            guard let inputs = captureSession.inputs as? [AVCaptureInput], let frontCameraInput = self.frontCameraInput, inputs.contains(frontCameraInput),
                let rearCamera = self.rearCamera else {throw CameraControllerError.invalidOperation}
            self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
            captureSession.removeInput(frontCameraInput)
            if (captureSession.canAddInput(self.rearCameraInput!)){
                captureSession.addInput(self.rearCameraInput!)
                self.currentCameraPosition = .rear
            }
            else {throw CameraControllerError.invalidOperation}
        }
        switch currentCameraPosition{
        case .front:
            try switchToRearCamera()
        case .rear:
            try switchToFrontCamera()
        }
        
        captureSession.commitConfiguration()
    }
   
}

