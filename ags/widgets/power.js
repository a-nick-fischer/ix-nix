import { dndMode } from "./notifications.js"
import { row, column } from "../libs/ags_helpers.js"
import { makeBarPopup } from "./bar.js"

export function PowerControls(){
    const callback = Variable(null)

    const menu = Widget.Revealer({
        transition: "slide_down",
        reveal_child: callback.bind().as(value => value != null),
        child: column([
            Widget.Separator(),

            row([
                Widget.Button({
                    label: "Do it",
                    class_name: "verification-button",
                    onPrimaryClick: () => callback.getValue()()
                }),

                Widget.Button({
                    label: "Nevermind",
                    class_name: "verification-button",
                    onPrimaryClick: () => callback.setValue(null)
                })
            ])
        ])
    })

    const makeButton = (icon, action) => Widget.Button({
        image: Widget.Icon({
            icon,
            size: 50
        }),

        onPrimaryClick: () => {
            callback.setValue(action)
        }
    })

    const dndButton = Widget.Button({
        image: Widget.Icon({
            icon: dndMode.bind().as(dnd => dnd? "notifications-disabled-symbolic" : "preferences-system-notifications-symbolic"),
            size: 50
        }),

        onPrimaryClick: () => dndMode.value = !dndMode.value
    })

    const buttonRow = row([
        
        makeButton("system-shutdown-symbolic", () => {
            Utils.exec("shutdown -h now")
        }),

        makeButton("emblem-synchronizing-symbolic", () => {
            Utils.exec("reboot")
        }),

        makeButton("system-lock-screen-symbolic", () => {
            Utils.exec("hyprlock")
        }),

        dndButton
    ])

    return column([
        buttonRow,
        menu
    ], { class_name: "power-controls-list", css: "min-width: 294px" })
}

export function PowerControlsPopup(){
    return makeBarPopup("power-controls", PowerControls(), [970, 155])
}