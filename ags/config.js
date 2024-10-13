import { BarWindow } from "./widgets/bar.js"
import { registerBatteryNotifier } from "./services/battery_notification.js"
import { NotificationPopups } from "./widgets/notifications.js"
import { registerBackgroundHandler } from "./services/background.js"
import { SliderControlsPopup } from "./widgets/slider.js"
import { registerServiceNotifier } from "./services/service_notification.js"
import { BatteryControlsPopup } from "./widgets/battery.js"
import { PowerControlsPopup } from "./widgets/power.js"
import { BluetoothControlsPopup } from "./widgets/bluetooth.js"
import { NetworkControlsPopup } from "./widgets/network.js"
import { registerBrightnessNotifier } from "./services/brightness_notification.js"
import { registerInternetConnectivityNotifier } from "./services/internet_notification.js"
import { registerMediaNotifier } from "./services/media_notifications.js"

App.config({
    style: "./style.css",

    onConfigParsed: () => {
        registerBatteryNotifier()
        registerBackgroundHandler()
        registerServiceNotifier()
        registerBrightnessNotifier()
        registerInternetConnectivityNotifier()
        registerMediaNotifier()
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