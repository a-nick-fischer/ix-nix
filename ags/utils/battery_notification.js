const battery = await Service.import("battery")

let wasCharging = false

// Ordering is important here
let notifications = [
    {
        triggered: false,
        percent: 20,
        summary: "Battery below 20%",
        iconName: "error-symbolic",
        body: "Buddy, I'm dying here"
    },

    {
        triggered: false,
        percent: 50,
        summary: "Battery below 50%",
        iconName: "info-symbolic",
        body: "Please get me some power chap"
    },
]

export function registerBatteryNotifier(){
    wasCharging = battery.charging

    battery.connect("changed", battery => {
        if(battery.charging && !wasCharging){
            notifications.forEach(notification => notification.triggered = false)
        }

        wasCharging = battery.charging

        if(battery.charging) return

        for(let notification of notifications){
            if(notification.triggered) continue

            if(battery.percent <= notification.percent){
                Utils.notify({
                    summary: notification.summary,
                    iconName: notification.iconName,
                    body: notification.body,
                })

                notification.triggered = true
            }
        }
    })
}