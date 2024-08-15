import { OpenerWindow } from "./widgets/opener.js"
import { CustomCalendarPopup } from "./widgets/calendar.js"
import { CustomWeatherPopup } from "./widgets/weather.js"
import { CustomTodoPopup } from "./widgets/todo.js"
import { registerBatteryNotifier } from "./utils/battery_notification.js"
import { NotificationPopups } from "./widgets/notifications.js"

App.config({
    style: "./style.css",

    onConfigParsed: () => {
        registerBatteryNotifier()
    },

    windows: [
        OpenerWindow(),
        CustomCalendarPopup(),
        CustomWeatherPopup(),
        CustomTodoPopup(),
        NotificationPopups(),
    ]
})

export { }