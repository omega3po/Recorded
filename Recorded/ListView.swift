//
//  ListView.swift
//  Recorded
//
//  Created by Sunny Hwang on 11/13/23.
//

import SwiftUI

struct ListView: View {
    @State var audios: [URL] = []
    var body: some View {
        VStack {
            List {
                Section(header: Text("Recodings")) {
                    ForEach(Array(zip(self.audios.indices, self.audios)),id:\.1) { index, i in
                        NavigationLink(destination: EmptyView()) {
                            Text((UserDefaults.standard.string(forKey: i.relativeString)!)
                            ).onAppear(perform: {
                                print(UserDefaults.standard.string(forKey: i.relativeString)!)
                            })
                        }
                    }
                }
            }
        }.onAppear(perform: {
            GetAudios()
        })
    }
    func GetAudios() {
        do {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            let result = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .producesRelativePathURLs)
            
            self.audios.removeAll()
            for i in result{
                self.audios.append(i)
            }
            
        }
        catch{
            
        }
    }
}

#Preview {
    ListView()
}
