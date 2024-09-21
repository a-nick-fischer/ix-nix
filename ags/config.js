import { BarWindow } from "./widgets/bar.js"
import { registerBatteryNotifier } from "./utils/battery_notification.js"
import { NotificationPopups } from "./widgets/notifications.js"
import { registerBackgroundHandler } from "./utils/background.js"
import { SliderControlsPopup } from "./widgets/slider.js"
import { registerServiceNotifier } from "./utils/service_notification.js"
import { BatteryControlsPopup } from "./widgets/battery.js"
import { PowerControlsPopup } from "./widgets/power.js"
import { BluetoothControlsPopup } from "./widgets/bluetooth.js"
import { NetworkControlsPopup } from "./widgets/network.js"
import { registerBrightnessNotifier } from "./utils/brightness_notification.js"

App.config({
    style: "./style.css",

    onConfigParsed: () => {
        registerBatteryNotifier()
        registerBackgroundHandler()
        registerServiceNotifier()
        registerBrightnessNotifier()
    },

    windows: [
        BarWindow(),
        SliderControlsPopup(),
        NotificationPopups(),
        BatteryControlsPopup(),
        PowerControlsPopup(),
        BluetoothControlsPopup(),
        NetworkControlsPopup()
    ]
})

export { }