const network = await Service.import('network')

function WifiIndicator() { 
    return Widget.Icon({
        icon: network.wifi.bind('icon_name'),
        tooltip_text: network.wifi.bind('state').as(state => 
            `SSID: ${network.wifi.ssid} State: ${state}`
        )
    })
}

function WiredIndicator(){ 
    return Widget.Icon({
        icon: network.wired.bind('icon_name'),
        tooltip_text: network.wired.bind('state').as(state => 
            `SSID: ${network.wired} State: ${state}`
        )
    })
}

export const NetworkIndicator = () => Widget.Stack({
    children: {
        wifi: WifiIndicator(),
        wired: WiredIndicator(),
    },
    shown: network.bind('primary').as(p => p || 'wifi'),
})
