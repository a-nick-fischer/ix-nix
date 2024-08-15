import { makePopupWindow } from "../utils/ags_helpers.js"

export const CALENDAR_WINDOW_NAME = "calendar"

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
        name: CALENDAR_WINDOW_NAME,
        anchor: ["bottom"],
        transition: "slide_up",
        child: CustomCalendar()
    })
}