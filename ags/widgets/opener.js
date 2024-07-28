import { SmallVolumeWidget } from "./volume.js"
import { withEventHandler, makeWindow } from "../utils/ags_helpers.js"
import { SmallBatteryWidget } from "./battery.js"
import { toggleCalendar } from "./calendar.js"

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

    return Widget.Box({
        spacing: 20,
        children: [
            SmallVolumeWidget(),
            clockLabel,
            SmallBatteryWidget()
        ]
    })
}

export function OpenerWindow(){
    return makeWindow({
        name: "opener",
        anchor: ["top"],
        child: Opener()
    })
}