//
//  ContentView.swift
//  ll-mux-test
//
//  Created by Dylan Jhaveri on 1/25/23.
//

import SwiftUI
import AVKit
import MuxUploadSDK

struct ContentView: View {
    @State private var isShowLibrary = false
    @State private var isUploading = false
    @State private var uploadScreenState: UploadScreenState = .initial
    @State private var upload: MuxUpload?
    
    enum UploadScreenState {
        case initial
        case uploading(state: MuxUpload.Status)
        case done(success: MuxUpload.Success)
        case failure(error: Error)
    }
    
    var body: some View {
        VStack {
            Button {
                self.isShowLibrary = true
            } label: {
                if self.isUploading {
                    Text("Uploading...")
                } else {
                    Text("Select video")
                }
            }
        }
        .padding()
        .sheet(isPresented: $isShowLibrary) {
            VideoPicker(onDismiss: {
                self.isShowLibrary = false
            }, onReceiveURL: { url in
                let upload = MuxUpload(
                    uploadURL: URL(string: "https://storage.googleapis.com/video-storage-gcp-us-east4-vop1-uploads/8cVt7e4Y13Q8Uysz36JJFE?Expires=1686962163&GoogleAccessId=uploads-gcp-us-east1-vop1%40mux-video-production.iam.gserviceaccount.com&Signature=c5XnE4R9c9%2F9F%2BFl8LpQUrf6YQ2ILg4FVN%2BKSfTSnz6s%2Bv3oSm4M0w65VUnOAk0ZfHd5YEzI5iIBxWd%2FPrTpXRR46Fyl%2F%2BkibQDmCPpvj3QFomCxoxAN9BARyICOBV2omSqacYwXvOgtSEo%2BOaan9DjN7gZD4f0B5ckMzf4z06Ryh%2FK3PQHoUThfNGfQqSIu2%2B4Qqk1ZKHS6emnw0Ex5HNVUL6nU1Ac0XXrMZbiMyOUjniA6qZcBgoqmVi3GyUO73qZaLgDPpEKhWZtX8PQn0ljfiGl0s99fjStl7tH9xBOAsCRXnjw%2BeAwiB8W7BrIW7xEDcBmPSntwndydtB%2Bc1w%3D%3D&upload_id=ADPycdtQT3oMllTJrXA8mJvynMtKDTmtuKeaaoGfX_vxsxCkCL2Wm8Ukpo6kK5q28H9k3X4tPok2g-tRNo4or2yaXNQQvg")!,
                    videoFileURL: url
                )

                upload.progressHandler = { state in
                    self.uploadScreenState = .uploading(state: state)
                }

                upload.resultHandler = { result in
                    switch result {
                    case .success(let success):
                        self.uploadScreenState = .done(success: success)
                        self.upload = nil
                        NSLog("Upload Success!")
                    case .failure(let error):
                        self.uploadScreenState = .failure(error: error)
                        NSLog("!! Upload error: \(error.localizedDescription)")
                    }
                }

                self.upload = upload
                upload.start()
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
