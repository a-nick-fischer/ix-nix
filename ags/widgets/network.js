import { row } from "../utils/ags_helpers.js"
import { makeBarPopup } from "./bar.js"

const network = await Service.import('network')

function WifiIndicator(size = 15) {
    return Widget.Icon({
        icon: network.wifi.bind('icon_name'),
        size,
        tooltip_text: network.wifi.bind('state').as(state =>
            state? `Connected to ${network.wifi.ssid}` : "Disconnected"
        )
    })
}

function WiredIndicator(size = 15) {
    return Widget.Icon({
        icon: network.wired.bind('icon_name'),
        size,
        tooltip_text: network.wired.bind('state')
    })
}

export function NetworkWidget(size) {
    return Widget.Stack({
        children: {
            wifi: WifiIndicator(size),
            wired: WiredIndicator(size),
        },
        shown: network.bind('primary').as(p => p || 'wifi'),
    })
}


function NetworkControls(){
    return row([
        NetworkWidget(40),

    ], { class_name: "network-controls-inner",  css: "min-width: 200px"  })
}

export function NetworkControlsPopup(){
    return makeBarPopup("network-controls", NetworkControls(), [1320, 50])
}