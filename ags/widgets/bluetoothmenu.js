import { column, row, withEventHandler } from "../utils/ags_helpers.js"
import { makeBarPopup } from "./bar.js"

const bluetooth = await Service.import("bluetooth")

// Stolen from https://github.com/Aylur/dotfiles/blob/main/ags/widget/quicksettings/widgets/Bluetooth.ts
function DeviceItem(device) {
    return Widget.Box({
        spacing: 5,
        children: [
            Widget.Icon(device.icon_name + "-symbolic"),

            Widget.Label(device.name.length > 20 ? device.name.slice(0, 15) + "..." : device.name),

            Widget.Box({ hexpand: true }),

            Widget.Spinner({
                active: device.bind("connecting"),
                visible: device.bind("connecting"),
            }),

            Widget.Switch({
                active: device.connected,

                visible: device.bind("connecting").as(p => !p),

                setup: self => self.on("notify::active", () => {
                    device.setConnection(self.active)
                }),
            }),
        ],
    })
}

function BluetoothDevices() {
    const devices = bluetooth.bind("devices").as(ds => ds
        .filter(d => d.name)
        .map(DeviceItem))

    return column(devices)
}

function BluetoothWidget() {
    const icon = Widget.Icon({
        icon: bluetooth.bind("enabled")
            .as(e => e ? "bluetooth-active-symbolic" : "bluetooth-disabled-symbolic"),
        size: 40
    })

    return withEventHandler({
        onPrimaryClick: () => bluetooth.toggle(),

        child: icon
    })
}

function BluetoothControls() {
    return row([
        BluetoothWidget(),
        BluetoothDevices()
    ], { css: "min-width: 250px" })
}

export function BluetoothControlsPopup() {
    return makeBarPopup("bluetooth-controls", BluetoothControls(), [280, 50])
}