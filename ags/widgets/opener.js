import { SmallMicrophoneWidget, SmallVolumeWidget } from "./audio.js"
import { withEventHandler, makeWindow, group } from "../utils/ags_helpers.js"
import { SmallBatteryWidget } from "./battery.js"
import { toggleCalendar } from "./calendar.js"
import { NetworkIndicator } from "./network.js"

const date = Variable("", {
    poll: [1000, 'date "+%d:%m:%H:%M:%S"'],
})

export function Opener() {
    const clockLabel = withEventHandler({
        onPrimaryClick: toggleCalendar,

        child: Widget.Label({
            class_name: "clock",
            label: date.bind(),
        })
    })

    return group([
        group([
            SmallMicrophoneWidget(),
            SmallVolumeWidget(),
        ]),
        
        clockLabel,

        group([
            SmallBatteryWidget(),
            NetworkIndicator()
        ]),
    ], 
        { spacing: 30 }
    )
}

export function OpenerWindow(){
    return makeWindow({
        name: "opener",
        anchor: ["top"],
        child: Opener()
    })
}