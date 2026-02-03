import Flutter
import UIKit
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let videoChannel = FlutterMethodChannel(name: "com.example.youpaint/video_export",
                                              binaryMessenger: controller.binaryMessenger)
    
    videoChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "createVideoFromImages" {
        guard let args = call.arguments as? [String: Any],
              let imagePaths = args["imagePaths"] as? [String],
              let outputPath = args["outputPath"] as? String,
              let fps = args["fps"] as? Int,
              let width = args["width"] as? Int,
              let height = args["height"] as? Int else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing arguments", details: nil))
            return
        }
        
        self.createVideo(from: imagePaths, output: outputPath, fps: fps, width: width, height: height, result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
  private func createVideo(from imagePaths: [String], output: String, fps: Int, width: Int, height: Int, result: @escaping FlutterResult) {
      let fileURL = URL(fileURLWithPath: output)
      
      // Remove existing file
      try? FileManager.default.removeItem(at: fileURL)
      
      guard let assetWriter = try? AVAssetWriter(outputURL: fileURL, fileType: .mp4) else {
          result(FlutterError(code: "WRITER_ERROR", message: "Could not create AVAssetWriter", details: nil))
          return
      }
      
      let videoSettings: [String: Any] = [
          AVVideoCodecKey: AVVideoCodecType.h264,
          AVVideoWidthKey: width,
          AVVideoHeightKey: height
      ]
      
      let videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
      videoInput.expectsMediaDataInRealTime = false
      
      let sourceBufferAttributes: [String: Any] = [
          kCVPixelBufferPixelFormatTypeKey as String: Int32(kCVPixelFormatType_32ARGB),
          kCVPixelBufferWidthKey as String: width,
          kCVPixelBufferHeightKey as String: height
      ]
      
      let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoInput, sourcePixelBufferAttributes: sourceBufferAttributes)
      
      if assetWriter.canAdd(videoInput) {
          assetWriter.add(videoInput)
      } else {
          result(FlutterError(code: "ADD_INPUT_ERROR", message: "Could not add input to write", details: nil))
          return
      }
      
      if assetWriter.startWriting() {
          assetWriter.startSession(atSourceTime: .zero)
          
          let mediaQueue = DispatchQueue(label: "mediaInputQueue")
          var frameIndex = 0
          let frameDuration = CMTimeMake(value: 1, timescale: Int32(fps))
          
          videoInput.requestMediaDataWhenReady(on: mediaQueue) {
              while videoInput.isReadyForMoreMediaData {
                  if frameIndex >= imagePaths.count {
                      videoInput.markAsFinished()
                      assetWriter.finishWriting {
                          DispatchQueue.main.async {
                              result(nil) // Success
                          }
                      }
                      return
                  }
                  
                  let imagePath = imagePaths[frameIndex]
                  if let image = UIImage(contentsOfFile: imagePath),
                     let pixelBuffer = self.pixelBuffer(from: image, size: CGSize(width: width, height: height)) {
                      let presentationTime = CMTimeMultiply(frameDuration, multiplier: Int32(frameIndex))
                      pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: presentationTime)
                  }
                  
                  frameIndex += 1
              }
          }
      } else {
          result(FlutterError(code: "START_ERROR", message: "Could not start writing", details: nil))
      }
  }
    
  private func pixelBuffer(from image: UIImage, size: CGSize) -> CVPixelBuffer? {
      let options: [String: Any] = [
          kCVPixelBufferCGImageCompatibilityKey as String: true,
          kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
      ]
      
      var pxbuffer: CVPixelBuffer?
      let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                       Int(size.width),
                                       Int(size.height),
                                       kCVPixelFormatType_32ARGB,
                                       options as CFDictionary,
                                       &pxbuffer)
      
      guard status == kCVReturnSuccess, let buffer = pxbuffer else { return nil }
      
      CVPixelBufferLockBaseAddress(buffer, [])
      let pxdata = CVPixelBufferGetBaseAddress(buffer)
      
      let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
      guard let context = CGContext(data: pxdata,
                                    width: Int(size.width),
                                    height: Int(size.height),
                                    bitsPerComponent: 8,
                                    bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                                    space: rgbColorSpace,
                                    bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else { return nil }
      
      context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
      
      CVPixelBufferUnlockBaseAddress(buffer, [])
      
      return buffer
  }
}
