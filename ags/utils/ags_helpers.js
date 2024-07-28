export const GLOBAL_TRANSITION_DURATION = 1000;

export function getWindowName(name, extras = {}){
    return `${name}-${extras["monitor"] || 0}`
}

export function makeWindow({name, anchor, child, extras = {}}){
    return Widget.Window({
        name: getWindowName(name, extras),
        class_names: ["window", `${name}-window`],
        anchor: anchor,
        exclusivity: "ignore", // Ignore exclusivity of other windows
        canFocus: true,
        child,
        ...extras
    })
}

export function makePopupWindow({name, anchor, child, extras = {}}){
    return makeWindow({
        name,
        anchor,
        child: PopupRevealer({
            name,
            child
        }),

        extras: {
            visible: false,
            ...extras
        }
    })
}

export function withEventHandler({ child, ...handlers }){
    return Widget.Box({
        child: Widget.EventBox({ 
            child,
            ...handlers
        })
    }) 
}

// Partially stolen from https://github.com/Aylur/dotfiles/blob/a7cfbdc80d79e063894e7b4f7dbeae241894eabd/ags/widget/PopupWindow.ts#L28
function PopupRevealer({name, child, transition = "slide_down"}) {
    return Widget.Box(
        { css: "padding: 1px;" },
        Widget.Revealer({
            revealChild: false,
            transition: "slide_down",
            child,
            transitionDuration: GLOBAL_TRANSITION_DURATION,
            setup: self => self.hook(App, (_, wname, visible) => {
                const windowName = getWindowName(name)

                if (wname === windowName)
                    self.reveal_child = visible
            }),
        }),
    )
}
