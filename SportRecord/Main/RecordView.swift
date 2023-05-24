//
//  RecordView.swift
//  SportRecord
//
//  Created by 张凌浩 on 2023/5/22.
//

import SwiftUI

struct RecordView: View {
    @State var showAlert = false
    @State var alertMessage = ""
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    @State private var timer: Timer? = nil
    @State private var startTime: Date? = nil
    @State private var timeElapsed: TimeInterval = 0.0
    
    let formatter: DateComponentsFormatter = {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
            return formatter
        }()
    
    var body: some View {
        ZStack {
            Image("Blob2")
                .edgesIgnoringSafeArea(.all)
            VStack (){
                Text("运动记录图：").frame(maxWidth: .infinity, alignment: .leading).font(.subheadline).foregroundColor(Color("Text")).padding(.leading,50).padding(.vertical)
                Image(uiImage: inputImage ?? UIImage()).resizable().aspectRatio(contentMode: .fit).frame(maxHeight: 200)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(.ultraThinMaterial))
                Button{
                    showingImagePicker.toggle()
                } label: {
                    Text("选择打卡图片")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background(RoundedRectangle(cornerRadius: 20).stroke(.linearGradient(colors: [.white.opacity(0.8), .black.opacity(0.2)], startPoint: .top, endPoint: .bottom)))
                }.padding(.horizontal, 100)
                Text("当前运动时间：").frame(maxWidth: .infinity, alignment: .leading).font(.subheadline).foregroundColor(Color("Text")).padding(.leading,50).padding(.vertical)
                Text(formatter.string(from: timeElapsed) ?? "00:00:00")
                                .font(.largeTitle)
                                .padding().foregroundColor(Color("Text"))
                                .background(RoundedRectangle(cornerRadius: 20).fill(.thinMaterial)).padding(.bottom,50)
                
                HStack {
                    Button(action: {
                        if let timer = self.timer {
                            timer.invalidate()
                            self.timer = nil
                            self.timeElapsed += Date().timeIntervalSince(self.startTime!)
                            self.startTime = nil
                        } else {
                            self.startTime = Date()
                            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                                self.timeElapsed += Date().timeIntervalSince(self.startTime!)
                                self.startTime = Date()
                            }
                        }
                    }) {
                        Text(timer == nil ? "开始" : "暂停")
                            .font(.title).bold()
                            .padding(25)
                            .background(Color("Secondary"))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    Button{
                        if let timer = self.timer {
                                timer.invalidate()
                                self.timer = nil
                                self.timeElapsed += Date().timeIntervalSince(self.startTime!)
                                self.startTime = nil
                            }
                            if let image = self.inputImage {
                                DBService.shared.addRecord(duration: self.timeElapsed, image: image)
                                self.timeElapsed = 0.0
                                self.inputImage = nil
                                self.alertMessage = "保存成功！"
                                                    self.showAlert = true
                            }
                            else {
                                self.alertMessage = "保存失败！请先选择图片。"
                                                    self.showAlert = true
                            }
                    } label: {
                        Text("结束")
                            .font(.title).bold()
                            .padding(25)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }.alert(isPresented: $showAlert) {
                        Alert(title: Text(alertMessage))
                    }
                }
            }.sheet(isPresented: $showingImagePicker){
                ImagePicker(selectedImage: $inputImage)
            }
            
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
    }
}
