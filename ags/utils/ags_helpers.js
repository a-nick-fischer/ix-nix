export const GLOBAL_TRANSITION_DURATION = 1000;
export const UPDATE_FN_POLLING_INTERVAL = 3000;

export function togglePopupGroup(popups) {
    popups.forEach(name => App.toggleWindow(name));
}

export function column(children, overrides = {}, outerOverrides = {}) {
    return row(
        children,
        { ...overrides, vertical: true, hexpand: true },
        { ...outerOverrides, hexpand: true }
    )
}

export function row(children, overrides = {}, outerOverrides = {}) {
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
    name, anchor, child, margins = [ 30, 30, 30, 30 ], transition = "crossfade", extras = {}
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

export function withEventHandler({ child, ...handlers }) {
    return Widget.Box({
        child: Widget.EventBox({
            child,
            ...handlers
        })
    })
}

export function SliderBox(icon, slider) {
    return Widget.Box({
        class_name: "slider-box",

        children: [
            icon,
            slider
        ]
    })
}

// Partially stolen from https://github.com/Aylur/dotfiles/blob/a7cfbdc80d79e063894e7b4f7dbeae241894eabd/ags/widget/PopupWindow.ts#L28
function PopupRevealer({ name, child, transition }) {
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

function AccordionEntry(currentlyOpenChild, { iconName, title, classNames, child }){
    const details = Widget.Revealer({
        revealChild: false,
        transitionDuration: 1000,
        transition: 'slide_down',
        child: column([
            child,
            Widget.Separator()
        ])
    })

    const setChildOpen = (child, state) => {
        child.reveal_child = state
    }

    const header = withEventHandler({
        child: Widget.CenterBox({
            start_widget: Widget.Icon({ 
                icon: iconName, 
                size: 15, 
                css: "min-width: 30px" 
            }),

            center_widget: Widget.Label({ 
                label: title.length > 20 ? title.slice(0, 15) + "..." : title, 
                css: "min-width: 150px" 
            }),

            spacing: 15
        }),

        onPrimaryClick: () => {
            const isAnyOpen = currentlyOpenChild.value != null
            const isThisOpen = details.reveal_child
            
            // This menu is open and was clicked - close it
            if(isAnyOpen && isThisOpen){
                setChildOpen(details, false)
                currentlyOpenChild.value = null
            }
            // Another menu is open and this was clicked - close the other one and open this one
            else if(isAnyOpen){
                setChildOpen(currentlyOpenChild.value, false)
                setChildOpen(details, true)
                currentlyOpenChild.value = details
            }
            // No menu is open and this was clicked - open the menu
            else {
                setChildOpen(details, true)
                currentlyOpenChild.value = details
            }
        }
    })

    

    return column([
        header,
        details
    ], { class_names: classNames || []  })
}

// () => [{ iconName, title, classNames, child }, ...]
export function AccordionList(updateSpecFn){
    const openChild = Variable(null)
    const proxy = Variable([])

    const generateEntries = () => updateSpecFn().map(spec => AccordionEntry(openChild, spec))

    openChild.connect("changed", ({ value }) => {
        if(value == null) 
            Utils.timeout(GLOBAL_TRANSITION_DURATION, () => proxy.value = generateEntries())
    })

    Utils.interval(UPDATE_FN_POLLING_INTERVAL, () => {
        if(openChild.value == null) proxy.value = generateEntries()
    })

    return Widget.Scrollable({
        hscroll: "never",
        vscroll: "automatic",
        css: 'min-width: 170px;',
        child: column(proxy.bind())
    })
}