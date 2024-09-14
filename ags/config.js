import { BarWindow } from "./widgets/bar.js"
import { registerBatteryNotifier } from "./utils/battery_notification.js"
import { NotificationPopups } from "./widgets/notifications.js"
import { registerBackgroundHandler } from "./utils/background.js"
import { SliderControlsPopup } from "./widgets/slidermenu.js"
import { registerServiceNotifier } from "./utils/service_notification.js"
import { BatteryControlsPopup } from "./widgets/battery.js"
import { PowerControlsPopup } from "./widgets/powermenu.js"
import { BluetoothControlsPopup } from "./widgets/bluetoothmenu.js"

App.config({
    style: "./style.css",

    onConfigParsed: () => {
        registerBatteryNotifier()
        registerBackgroundHandler()
        registerServiceNotifier()
    },

    windows: [
        BarWindow(),
        SliderControlsPopup(),
        NotificationPopups(),
        BatteryControlsPopup(),
        PowerControlsPopup(),
        BluetoothControlsPopup(),
    ]
})

export { }