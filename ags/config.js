import { OpenerWindow } from "./widgets/opener.js"
import { CustomCalendarPopup } from "./widgets/calendar.js"
import { authenticateTickTick } from "./utils/ticktick.js"


App.config({
    style: "./style.css",

    onConfigParsed: () => {
        authenticateTickTick()
    },

    windows: [
        OpenerWindow(),
        CustomCalendarPopup()
    ]
})

export { }