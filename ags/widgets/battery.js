const battery = await Service.import("battery")

export function SmallBatteryWidget() {
    return Widget.Icon({
        icon: battery.bind('icon_name'),
        tooltip_text: battery.bind('percent').as(percent => {
            return `Battery: ${battery.charging? "Charging " : ""}${percent}%`
        })
    })
}

export function BatteryControl(){
    return null // TODO
}