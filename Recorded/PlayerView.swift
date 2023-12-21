//
//  PlayerView.swift
//  Recorded
//
//  Created by Sunny Hwang on 12/21/23.
//

import SwiftUI
import AVFoundation

struct PlayerView: View {
    @StateObject var viewmodel = PlayerViewModel()
    var uri : URL
    var audios : [URL]  = []
    var index : Int
    
    @State var timer = Timer.publish(every: 0.01, on: .current, in: .default).autoconnect()
    var body: some View {
        ZStack {
            WaveForm(color: .cyan, amplify: 50, isReversed: false)
                .opacity(0.7)
                .offset(y: 300)
            WaveForm(color: .cyan, amplify: 50, isReversed: true)
                .opacity(0.4)
                .offset(y: 300)
            VStack {
                Text(UserDefaults.standard.string(forKey: audios[index].relativeString) ?? "No Name")
                    .font(.system(size: 24))
                    .bold()
                    .padding()
                Text(audios[index].relativeString)
                    .foregroundStyle(.secondary)
                    .font(.system(size: 16))
                    .padding()
                HStack {
                    Text(viewmodel.GetCurrentTime(a: viewmodel.player.currentTime))
                    
                    Button {
                        viewmodel.Play()
                    } label: {
                        Image(systemName: viewmodel.isPlaying ? "pause.fill" : "play.fill")
                    }
                    .font(.system(size: 40))
                    
                    Text(viewmodel.GetCurrentTime(a: viewmodel.player.duration))
                }
            }
            .padding(.bottom, 20)
            
        }
        .onAppear(perform: {
            print(uri)
            print(audios[index])
            viewmodel.player = try! AVAudioPlayer(contentsOf: audios[index])
        })
        .onReceive(timer) { (_) in
            viewmodel.UpdateTimer()
        }
    }
}

