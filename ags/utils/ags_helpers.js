export const GLOBAL_TRANSITION_DURATION = 1000;

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

function AccordionEntry(openChild, { iconName, title, classNames, child }){
    const details = Widget.Revealer({
        revealChild: false,
        visible: false,
        transitionDuration: 1000,
        transition: 'slide_down',
        child: column([
            child,
            Widget.Separator()
        ])
    })

    const header = withEventHandler({
        child: Widget.CenterBox({
            start_widget: Widget.Icon({ icon: iconName, size: 15 }),
            center_widget: Widget.Label(title.length > 20 ? title.slice(0, 15) + "..." : title.name) 
        }),

        onPrimaryClick: () => {
            if(openChild.value) { 
                openChild.value.reveal_child = false;
                openChild.value.visible = false;
                openChild.value = null;
            }
            
            const shouldReveal = !details.reveal_child
            if(shouldReveal){
                openChild.value = details
            }

            details.visible = shouldReveal
            details.reveal_child = shouldReveal
        }
    })

    

    return column([
        header,
        details
    ], { class_names: classNames || []  })
}

// [{ iconName, title, classNames, child }, ...]
export function AccordionList(specs){
    const openChild = Variable(null)

    const toEntryList = (list) => list.map(spec => AccordionEntry(openChild, spec) )

    const makeScrollable = (entries) => Widget.Scrollable({
        hscroll: "never",
        vscroll: "automatic",
        css: 'min-width: 170px;',
        child: column(entries)
    })

    // If the given spec is a conrete list just convert it to widgets
    if(specs instanceof Array)
        return makeScrollable(toEntryList(specs))


    // We cannot update entries while an entry is "open" - as this will rearrange and close all entries
    // So we use a proxy to selectively apply updated only when no entry is open
    const proxy = Variable([])

    specs.emitter.connect("changed", () => {
        const concreteSpecs = specs.value
        console.log(concreteSpecs)

        // If any child is open
        if(openChild.value != null){
            // Register a handler which applies the update once the entry is closed
            const handlerId = openChild.connect("changed", (newOpenChild) => {
                if(newOpenChild) return

                openChild.disconnect(handlerId)
                proxy.value = toEntryList(concreteSpecs)
            })
        }
        else 
            proxy.value = toEntryList(concreteSpecs)
    })

    return makeScrollable(proxy.bind())
}