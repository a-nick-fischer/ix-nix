import { BarWindow } from "./widgets/bar.js"
import { registerBatteryNotifier } from "./utils/battery_notification.js"
import { NotificationPopups } from "./widgets/notifications.js"

App.config({
    style: "./style.css",

    onConfigParsed: () => {
        registerBatteryNotifier()
    },

    windows: [
        BarWindow(),
        NotificationPopups(),
    ]
})

export { }