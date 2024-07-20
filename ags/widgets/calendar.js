import { getWindowName, makePopupWindow } from "../utils.js"

const WINDOW_NAME = "calendar"

export function toggleCalendar(){
    const rawName = getWindowName(WINDOW_NAME)
    App.toggleWindow(rawName)
}

function CustomCalendar(){
    return Widget.Calendar({
        class_name: "calendar",
        showDayNames: true,
        showDetails: true,
        showHeading: true,
        showWeekNumbers: false,

        detail: (self, y, m, d) => {
            return `<span color="white">${y}. ${m}. ${d}.</span>`
        },
        
        onDaySelected: ({ date: [y, m, d] }) => {
            print(`${y}. ${m}. ${d}.`)
        },
    })
}

export function CustomCalendarPopup(){
    return makePopupWindow({
        name: WINDOW_NAME,
        anchor: [],
        child: CustomCalendar()
    })
}