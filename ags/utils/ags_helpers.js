export const GLOBAL_TRANSITION_DURATION = 1000;

export function togglePopupGroup(popups){
    popups.forEach(name => App.toggleWindow(name));
}

export function column(children, overrides = {}, outerOverrides = {}){
    return row(
        children, 
        { ...overrides, vertical: true, hexpand: true }, 
        { ...outerOverrides, hexpand: true }
    )
}

export function row(children, overrides = {}, outerOverrides = {}){
    overrides = { spacing: 10, ...overrides } 

    return Widget.CenterBox({
        center_widget: Widget.Box({
            children,
            ...overrides
        }),
        
        ...outerOverrides
    })
}

export function makeWindow({
    name, anchor, child, margins = [ 0, 0, 0, 0 ], extras = {}
}){
    return Widget.Window({
        name,
        class_names: ["window", `${name}-window`],
        anchor,
        margins,
        exclusivity: "ignore", // Ignore exclusivity of other windows
        canFocus: true,
        child,
        ...extras
    })
}

export function makePopupWindow({
    name, anchor, child, margins = [ 30, 30, 30, 30 ], transition = "slide_down", extras = {}
}){
    return makeWindow({
        name,
        anchor,
        margins,
        child: PopupRevealer({
            name,
            child,
            transition
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

export function sliderBox(slider){
    return Widget.Box({
        class_name: "slider-box",
        child: slider
    })
}

// Partially stolen from https://github.com/Aylur/dotfiles/blob/a7cfbdc80d79e063894e7b4f7dbeae241894eabd/ags/widget/PopupWindow.ts#L28
function PopupRevealer({name, child, transition}) {
    return Widget.Box(
        { css: "padding: 1px;" },
        Widget.Revealer({
            revealChild: false,
            transition,
            child,
            transitionDuration: GLOBAL_TRANSITION_DURATION,
            setup: self => self.hook(App, (_, wname, visible) => {
                if (wname === name)
                    self.reveal_child = visible
            }),
        }),
    )
}
