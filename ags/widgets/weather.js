import { row, makePopupWindow } from "../utils/ags_helpers.js"

export const WEATHER_WINDOW_NAME = "weather"

function CustomWeatherWidget(){
    return row([
        Widget.Label({
            label: "Weather",
            css: "margin: 238px 200px"
        })
    ])
}

export function CustomWeatherPopup(){
    return makePopupWindow({
        name: WEATHER_WINDOW_NAME,
        transition: "slide_up",
        anchor: ["left", "bottom"],
        child: CustomWeatherWidget()
    })
}