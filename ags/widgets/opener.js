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

function ClockLabel(panelPopup){
    return withEventHandler({
        onPrimaryClick: () => {
            panelPopup.visible = !panelPopup.visible
        },

        child: Widget.Label({
            class_name: "clock",
            label: date.bind(),
        })
    })
}

function Bar(panelPopup){
    return row([
        row([
            SmallMicrophoneWidget(),
            SmallVolumeWidget(),
        ]),
        
        ClockLabel(panelPopup),

        row([
            SmallBatteryWidget(),
            NetworkIndicator()
        ]),
    ], 
        { spacing: 30 }
    )
}

function ControlPanel(){
    return row([
        Widget.Button({
            image: Widget.Icon("x-office-calendar-symbolic"),
            onClicked: () => togglePopupGroup([CALENDAR_WINDOW_NAME])
        }),
    ])
}

export function Opener() {
    const panelPopup = column([
        ControlPanel(),

        Widget.Separator({
            vertical: true,
        }),
    ])

    return column([
        panelPopup,

        Bar(panelPopup),
    ])
}

export function OpenerWindow(){
    return makeWindow({
        name: "opener",
        anchor: ["top"],
        child: Opener()
    })
}