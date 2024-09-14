import { column, makePopupWindow, row } from "../utils/ags_helpers.js"
import { windowsToToggle } from "./bar.js"

const battery = await Service.import("battery")

export function BatteryWidget(size = 15) {
    return Widget.Icon({
        icon: battery.bind('icon_name'),
        size,
        tooltip_text: battery.bind('percent').as(percent => {
            return `Battery: ${percent}%`
        })
    })
}

export function BatteryControl(){
    return row([
        BatteryWidget(50),

        column([
            Widget.Label({ 
                label: battery.bind('energy').as(energy => {
                    return `${energy}Wh / ${battery.energy_full}Wh @ ${battery.energy_rate}W`
                })
            }),

            Widget.Label({ 
                setup: self => self.hook(battery, () => {
                    self.label = `${battery.charging ? "Charged" : "Dead"} in ${Math.floor(battery.time_remaining / 60)}min`
                })
            }),
        ]),

    ], { class_name: "battery-controls-inner" })
}

export const BATTERY_CONTROL_WINDOW = "battery-controls"

export function BatteryControlsPopup(){
    windowsToToggle.push(BATTERY_CONTROL_WINDOW)

    return makePopupWindow({
        name: BATTERY_CONTROL_WINDOW,
        transition: "crossfade",
        margins: [250, 0, 0, 0],
        anchor: ["top"],
        child: BatteryControl()
    })
}