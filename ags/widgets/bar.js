import { MicrophoneWidget, VolumeWidget } from "./audio.js"
import { withEventHandler, makeWindow, row, makePopupWindow } from "../libs/ags_helpers.js"
import { BatteryWidget } from "./battery.js"
import { NetworkWidget } from "./network.js"

const date = Variable("", {
    poll: [1000, 'date "+%d:%m:%H:%M:%S"'],
})

export const windowsToToggle = []

function toggleWindows(){
    windowsToToggle.forEach((window) => App.toggleWindow(window))
}

function ClockLabel(){
    return withEventHandler({
        child: Widget.Label({
            class_name: "clock",
            label: date.bind(),
        }),

        onPrimaryClick: toggleWindows
    })
}

export function Bar() {
    return row([
        row([
            MicrophoneWidget(),
            VolumeWidget(),
        ]),
        
        ClockLabel(),

        row([
            BatteryWidget(),
            NetworkWidget()
        ]),
    ], 
        { spacing: 30 }
    )
}

export function BarWindow(){
    return makeWindow({
        name: "bar",
        anchor: ["top"],
        child: Bar(),

        extras: {
            setup: self => {
                self.keybind("Escape", toggleWindows)
            }
        }
    })
}

export function makeBarPopup(name, widget, offset){
    windowsToToggle.push(name)

    let anchor = ["top"]
    let margins = [offset[0], 0, 0, 0]

    if(offset.length == 2){
        anchor.push(offset[1] < 0? "right" : "left")
        margins = [offset[1], offset[0], 0, offset[0]]
    }
    
    return makePopupWindow({
        name,
        anchor,
        margins,

        child: Widget.Box({ 
            child: widget, 
            class_names: [`${name}-popup-inner`, "bar-popup-inner"]
        }),

        extras: {
            setup: self => {
                self.keybind("Escape", toggleWindows)
            }
        }
    })
}