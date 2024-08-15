import { row, makePopupWindow } from "../utils/ags_helpers.js"

export const TODO_WINDOW_NAME = "todo"

function CustomTodoWidget(){
    return row([
        Widget.Label({
            label: "Todo   ",
            css: "margin: 238px 200px"
        })
    ])
}

export function CustomTodoPopup(){
    return makePopupWindow({
        name: TODO_WINDOW_NAME,
        transition: "slide_up",
        anchor: ["right", "bottom"],
        child: CustomTodoWidget()
    })
}