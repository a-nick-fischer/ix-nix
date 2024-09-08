import { BarWindow } from "./widgets/bar.js"
import { registerBatteryNotifier } from "./utils/battery_notification.js"
import { NotificationPopups } from "./widgets/notifications.js"
import { registerBackgroundHandler } from "./utils/background.js"
import { SliderControlsPopup } from "./widgets/slider_controls.js"

App.config({
    style: "./style.css",

    onConfigParsed: () => {
        registerBatteryNotifier()
        registerBackgroundHandler()
    },

    windows: [
        BarWindow(),
        SliderControlsPopup(),
        NotificationPopups(),
    ]
})

export { }