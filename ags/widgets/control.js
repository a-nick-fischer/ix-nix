import { row, makePopupWindow } from "../utils/ags_helpers.js"

export const CONTROL_WINDOW_NAME = "control"

function CustomControlWidget(){
    return row([
        Widget.Label({
            label: "Weather",
            css: "margin: 50px 200px"
        })
    ])
}

export function CustomControlPopup(){
    return makePopupWindow({
        name: CONTROL_WINDOW_NAME,
        transition: "slide_down",
        anchor: ["top"],
        child: CustomControlWidget()
    })
}