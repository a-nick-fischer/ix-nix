import { column, makePopupWindow, row } from "../utils/ags_helpers.js"
import { makeBarPopup, windowsToToggle } from "./bar.js"

const battery = await Service.import("battery")

export function BatteryWidget(size = 15) {
    return Widget.Icon({
        icon: battery.bind('icon_name'),
        size,
        tooltip_text: battery.bind('percent').as(percent => {
            return `Battery ${percent}%`
        })
    })
}

export function BatteryControl(){
    return row([
        BatteryWidget(40),

        column([
            Widget.Label({ 
                label: battery.bind('energy').as(energy => {
                    return `${energy}Wh / ${battery.energy_full}Wh @ ${battery.energy_rate}W`
                })
            }),

            Widget.Label({ 
                setup: self => self.hook(battery, () => {
                    let secondPart = ""
                    if(!battery.charged){
                        secondPart = ` - ${battery.charging ? `charged` : `dead`} in ${Math.floor(battery.time_remaining / 60)}min`
                    }

                    self.label = `${battery.percent}${secondPart}%`
                })
            }),
        ]),

    ], { class_name: "battery-controls-inner",  css: "min-width: 294px"  })
}

export function BatteryControlsPopup(){
    return makeBarPopup("battery-controls", BatteryControl(), [970, 50])
}