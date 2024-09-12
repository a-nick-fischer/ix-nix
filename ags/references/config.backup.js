const hyprland = await Service.import("hyprland")
const notifications = await Service.import("notifications")
const mpris = await Service.import("mpris")
const audio = await Service.import("audio")
const battery = await Service.import("battery")
const systemtray = await Service.import("systemtray")

const date = Variable("", {
    poll: [1000, 'date "+%H:%M:%S %b %e."'],
})

// widgets can be only assigned as a child in one container
// so to make a reuseable widget, make it a function
// then you can simply instantiate one by calling it

function Workspaces() {
    const activeId = hyprland.active.workspace.bind("id")
    const workspaces = hyprland.bind("workspaces")
        .as(ws => ws.map(({ id }) => Widget.Button({
            on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
            child: Widget.Label(`${id}`),
            class_name: activeId.as(i => `${i === id ? "focused" : ""}`),
        })))

    return Widget.Box({
        class_name: "workspaces",
        children: workspaces,
    })
}


function Clock() {
    return Widget.Label({
        class_name: "clock",
        label: date.bind(),
    })
}


function Volume() {
    const icons = {
        101: "overamplified",
        67: "high",
        34: "medium",
        1: "low",
        0: "muted",
    }

    function getIcon() {
        const icon = audio.speaker.is_muted ? 0 : [101, 67, 34, 1, 0].find(
            threshold => threshold <= audio.speaker.volume * 100)

        return `audio-volume-${icons[icon]}-symbolic`
    }

    const icon = Widget.Icon({
        icon: Utils.watch(getIcon(), audio.speaker, getIcon),
    })

    const slider = Widget.Slider({
        hexpand: true,
        draw_value: false,
        on_change: ({ value }) => audio.speaker.volume = value,
        setup: self => self.hook(audio.speaker, () => {
            self.value = audio.speaker.volume || 0
        }),
    })

    return Widget.Box({
        class_name: "volume",
        css: "min-width: 180px",
        children: [icon, slider],
    })
}


function BatteryLabel() {
    const value = battery.bind("percent").as(p => p > 0 ? p / 100 : 0)
    const icon = battery.bind("percent").as(p =>
        `battery-level-${Math.floor(p / 10) * 10}-symbolic`)

    return Widget.Box({
        class_name: "battery",
        visible: battery.bind("available"),
        children: [
            Widget.Icon({ icon }),
            Widget.LevelBar({
                widthRequest: 140,
                vpack: "center",
                value,
            }),
        ],
    })
}


function Search() {
    return Widget.Entry({
        class_name: "search",
        placeholder_text: "...",
        visibility: true,
        xalign: 0.5,
        onAccept: ({ text }) => print(`${text}\n`),
    })
}

function Stats() {
    return Widget.Box({
        class_name: "stats",
        children: [
            Volume(),
            BatteryLabel(),
            Clock(),
        ],
    })
}

function makeWindow({name, anchor, box, extras = {}}){
    return Widget.Window({
        name: `${name}-${extras["monitor"] || 0}`,
        class_names: ["bar-widget", `${name}-widget`],
        anchor: anchor,
        exclusivity: "ignore", // Ignore exclusivity of other windows
        canFocus: true,
        child: box,
        ...extras
    })
}

App.config({
    style: "./style.css",
    windows: [
        makeWindow({
            name: "workspaces",
            anchor: ["top", "left"],
            box: Workspaces()
        }),

        makeWindow({
            name: "search",
            anchor: ["top"],
            box: Search(),
            extras: {
                keymode: "on-demand",
                exclusivity: "exclusive" // Reserves spaces for other windows too
            }
        }),

        makeWindow({
            name: "stats",
            anchor: ["top", "right"],
            box: Stats()
        })
    ]
})

export { }