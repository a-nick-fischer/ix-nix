import { SmallMicrophoneWidget, SmallVolumeWidget } from "./audio.js"
import { withEventHandler, makeWindow, row, column, togglePopupGroup } from "../utils/ags_helpers.js"
import { SmallBatteryWidget } from "./battery.js"
import { NetworkIndicator } from "./network.js"
import { CALENDAR_WINDOW_NAME } from "./calendar.js"
import { WEATHER_WINDOW_NAME } from "./weather.js"
import { TODO_WINDOW_NAME } from "./todo.js"

const date = Variable("", {
    poll: [1000, 'date "+%d:%m:%H:%M:%S"'],
})

function ClockLabel(){
    return withEventHandler({
        child: Widget.Label({
            class_name: "clock",
            label: date.bind(),
        })
    })
}

export function Opener() {
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

export function OpenerWindow(){
    return makeWindow({
        name: "opener",
        anchor: ["top"],
        child: Opener()
    })
}