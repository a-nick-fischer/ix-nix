import { MicrophoneWidget, VolumeWidget } from "./audio.js"
import { withEventHandler, makeWindow, row} from "../utils/ags_helpers.js"
import { BatteryWidget } from "./battery.js"
import { NetworkIndicator } from "./network.js"

const date = Variable("", {
    poll: [1000, 'date "+%d:%m:%H:%M:%S"'],
})

export const windowsToToggle = []

function ClockLabel(){
    return withEventHandler({
        child: Widget.Label({
            class_name: "clock",
            label: date.bind(),
        }),

        onPrimaryClick: () => {
            windowsToToggle.forEach((window) => App.toggleWindow(window))
        }
    })
}

// TODO: Do not forget about bluetooth widget
export function Bar() {
    return row([
        row([
            MicrophoneWidget(),
            VolumeWidget(),
        ]),
        
        ClockLabel(),

        row([
            BatteryWidget(),
            NetworkIndicator()
        ]),
    ], 
        { spacing: 30 }
    )
}

export function BarWindow(){
    return makeWindow({
        name: "bar",
        anchor: ["top"],
        child: Bar()
    })
}