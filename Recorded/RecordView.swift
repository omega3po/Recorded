//
//  RecordView.swift
//  Recorded
//
//  Created by Sunny Hwang on 11/13/23.
//

import SwiftUI
import AVFoundation

struct RecordView: View {
    @State var recordFileName: String = ""
    @State var showResultView: Bool = false
    @State var showAlert: Bool = false
    @State var session: AVAudioSession!
    @State var recorder: AVAudioRecorder!
    @State var urls: [URL] = []
    @State var timer: Timer? = nil
    @State var hour: Int = 0
    @State var minute: Int = 0
    @State var second: Int = 0
    @State var isRecording: Bool = false
    @State var urlString: String?
    var body: some View {
        ZStack {
            WaveForm(color: isRecording ? .red : .cyan, amplify: isRecording ? 75 : 50, isReversed: false)
                .opacity(0.7)
            WaveForm(color: isRecording ? .red : .cyan, amplify: isRecording ? 75 : 50, isReversed: true)
                .opacity(0.4)
            
            VStack {
                ZStack {
                    if (hour < 10) {
                        Text("0\(hour)")
                            .font(.system(size: 48))
                            .offset(x: -80)
                    } else {
                        Text("\(hour)")
                            .font(.system(size: 48))
                            .offset(x: -80)
                    }
                    
                    Text(":")
                        .font(.system(size: 48))
                        .offset(x: -40)
                    
                    if (minute < 10) {
                        Text("0\(minute)")
                            .font(.system(size: 48))
                            .offset(x: 0)
                    } else {
                        Text("\(minute)")
                            .font(.system(size: 48))
                            .offset(x: 0)
                    }
                    
                    Text(":")
                        .font(.system(size: 48))
                        .offset(x: 40)
                    
                    if (second < 10) {
                        Text("0\(second)")
                            .font(.system(size: 48))
                            .offset(x: 80)
                    } else {
                        Text("\(second)")
                            .font(.system(size: 48))
                            .offset(x: 80)
                    }
                }
                
                
                Button {
                    if (!isRecording) {
                        startTimer()
                        do {
                            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
                            var currentDate =  dateFormatter.string(from: Date())
                            let filename = url.appendingPathComponent("\(currentDate)")
                            urlString = filename.lastPathComponent
                            let settings = [
                                AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
                                AVSampleRateKey : 12000,
                                AVNumberOfChannelsKey : 1,
                                AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue
                            ]
                            try recorder = AVAudioRecorder(url: filename, settings: settings)
                            recorder.record()
                            
                        } catch {
                            print(error.localizedDescription)
                        }
                    } else {
                        stopTimer()
                        showResultView.toggle()
                    }
                    isRecording.toggle()
                } label: {
                    Image(systemName: !isRecording ? "mic.fill" : "stop.fill")
                        .frame(width: 100, height: 100)
                        .font(.system(size: 50))
                        .foregroundStyle(!isRecording ? .cyan : .red)
                        .background(.white)
                        .cornerRadius(50)
                }.padding(.top, 150)
            }
            if (showResultView) {
                VStack {
                    Text("Filename")
                        .font(.system(size: 30))
                        .padding()
                    TextField("file name...", text: $recordFileName)
                        .padding()
                        .background(.black.opacity(0.1))
                        .cornerRadius(10)
                        .padding()
                        
                    Spacer()
                    
                    Button {
                        UserDefaults.standard.set($recordFileName, forKey: urlString!)
                        print(urlString!)
                    } label: {
                        HStack {
                            Image(systemName: "arrow.down.to.line.circle")
                            Text("Save")
                        }
                        .foregroundStyle(.white)
                        .padding()
                        .background(.cyan)
                        .cornerRadius(10)
                        .padding()
                        
                    }
                }
                .frame(width: 350, height: 350)
                .background(.white)
                .cornerRadius(15)
                .shadow(radius: 10)
            }
        }
        .ignoresSafeArea()
        .onAppear(perform: {
            do {
                session = AVAudioSession.sharedInstance()
                try session.setCategory(.playAndRecord)
                session.requestRecordPermission { isAuthorized in
                    if (!isAuthorized) {
                        showAlert.toggle()
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        })
        .alert(isPresented: self.$showAlert) {
            Alert(title: Text("Mic Usage is not allowed"), message: Text("record file will be empty"), primaryButton: .default(Text("Cancel"), action: {
                //some Action
                
            }), secondaryButton: .default(Text("Settings"), action: {
                if let appsettings = URL(string: UIApplication.openSettingsURLString){
                    
                    UIApplication.shared.open(appsettings,options: [:],completionHandler:nil)
                }
            }))
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { time in
            if (second < 100) {
                second += 1
            } else {
                minute += 1
                second = 0
            }
            if (minute == 60){
                hour += 1
                minute = 0
            }
        })
    }
    
    func stopTimer() {
        hour = 0
        minute = 0
        second = 0
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    RecordView()
}
