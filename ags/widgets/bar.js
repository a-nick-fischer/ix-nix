import { SmallMicrophoneWidget, SmallVolumeWidget } from "./audio.js"
import { withEventHandler, makeWindow, row} from "../utils/ags_helpers.js"
import { SmallBatteryWidget } from "./battery.js"
import { NetworkIndicator } from "./network.js"
import { SLIDER_CONTROL_WINDOW } from "./slider_controls.js"

const date = Variable("", {
    poll: [1000, 'date "+%d:%m:%H:%M:%S"'],
})

function ClockLabel(){
    return withEventHandler({
        child: Widget.Label({
            class_name: "clock",
            label: date.bind(),
        }),

        onPrimaryClick: () => {
            App.toggleWindow(SLIDER_CONTROL_WINDOW)
        }
    })
}

// TODO: Do not forget about bluetooth widget
export function Bar() {
    return row([
        row([
            SmallMicrophoneWidget(),
            SmallVolumeWidget(),
        ]),
        
        ClockLabel(),

        row([
            SmallBatteryWidget(),
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