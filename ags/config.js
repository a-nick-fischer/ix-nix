import { OpenerWindow } from "./widgets/opener.js"
import { CustomCalendarPopup } from "./widgets/calendar.js"


App.config({
    style: "./style.css",

    windows: [
        OpenerWindow(),
        CustomCalendarPopup()
    ]
})

export { }