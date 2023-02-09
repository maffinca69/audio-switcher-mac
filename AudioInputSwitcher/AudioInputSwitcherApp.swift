//
//  AudioInputSwitcherApp.swift
//  AudioInputSwitcher
//
//  Created by  Jolly on 08.02.2023.
//

import SwiftUI
import SimplyCoreAudio

struct TitleItem: Hashable {
    var selected: Bool
    var text: String
    var device: AudioDevice
}

@main
struct AudioInputSwitcherApp: App {

    @State var titleList: [TitleItem] = []
    private let simplyCoreAudio: SimplyCoreAudio = SimplyCoreAudio()
    
    init() {
        let items = getTitleItems()
        _titleList = State(initialValue: items)
    }
    
    var body: some Scene {
        MenuBarExtra("🟢", systemImage: "mic") {
            ForEach(titleList, id: \.self) { item in
                Button(item.text) {
                    let device = item.device

                    setActiveAudioDevice(device: device)
                    checkSelected(device: device)
                }
            }
            
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
    }
    
    func setActiveAudioDevice(device: AudioDevice) -> Void {
        device.isDefaultInputDevice = true
    }
    
    func checkSelected(device: AudioDevice) -> Void {
        // reset currenct selected audioDevice
        if let index = titleList.firstIndex(where: { $0.selected == true }) {
            titleList[index].selected = false
            titleList[index].text = titleList[index].device.name + " 🔴"
        }
        
        // check selected
        if let index = titleList.firstIndex(where: { $0.device.id == device.id }) {
            titleList[index].text = device.name + " 🟢"
            titleList[index].selected = true
        }
    }
    
    func getTitleItems() -> [TitleItem] {
        var items: [TitleItem] = []
        
        let inputDevices = simplyCoreAudio.allInputDevices
        for inputDevice in inputDevices {
            let id = inputDevice.id
            let selected = simplyCoreAudio.defaultInputDevice?.id == id
            let text = inputDevice.name

            items.append(TitleItem(
                selected: selected,
                text: text + (selected ? " 🟢" : " 🔴"),
                device: inputDevice
            ))
        }

        return items
    }
}
