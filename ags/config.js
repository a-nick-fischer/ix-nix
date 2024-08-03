import { OpenerWindow } from "./widgets/opener.js"
import { CustomCalendarPopup } from "./widgets/calendar.js"
import { createClient, reauthenticateTickTick, shouldReauthenticate } from "./utils/ticktick.js"


App.config({
    style: "./style.css",

    onConfigParsed: () => {
        
    },

    windows: [
        OpenerWindow(),
        CustomCalendarPopup()
    ]
})

export { }