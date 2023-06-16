//
//  VideoPicker.swift
//  ll-mux-test
//
//  Created by Dylan Jhaveri on 6/16/23.
//
import SwiftUI
import PhotosUI

struct VideoPicker: UIViewControllerRepresentable {
    var onDismiss: () -> Void
    var onReceiveURL: (URL) -> Void
    
    typealias UIViewControllerType = PHPickerViewController
        
        func makeUIViewController(context: Context) -> PHPickerViewController {
            var config = PHPickerConfiguration()
            config.filter = .any(of: [.livePhotos, .videos])
            config.selectionLimit = 1
            config.preferredAssetRepresentationMode = .current
            
            let controller = PHPickerViewController(configuration: config)
            controller.delegate = context.coordinator
            return controller
        }
        
        func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
            
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(with: self)
        }
        
        
        class Coordinator: PHPickerViewControllerDelegate {
            var videoPicker: VideoPicker
            
            init(with videoPicker: VideoPicker) {
                self.videoPicker = videoPicker
            }
            
            func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
                guard let result = results.first else {
                    videoPicker.onDismiss()
                    return
                }

                result.itemProvider.loadItem(forTypeIdentifier: UTType.movie.identifier, options: nil) { (item, error) in
                    DispatchQueue.main.async { [self] in
                        if let error = error {
                            print("Error loading video: \(error)")
                        } else if let url = item as? URL {
                            self.videoPicker.onReceiveURL(url)
                        }
                        self.videoPicker.onDismiss()
                    }
                }
            }
            
        }
}
