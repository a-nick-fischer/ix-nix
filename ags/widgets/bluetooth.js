import { AccordionList, column, row, withEventHandler } from "../utils/ags_helpers.js"
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
        BluetoothList()
    ], { css: "min-width: 250px; min-height: 165px;" })
}

export function BluetoothControlsPopup() {
    return makeBarPopup("bluetooth-controls", BluetoothControls(), [280, 50])
}

function BluetoothList(){
    const getDevices = () => bluetooth.devices
        .filter(d => d.name)
        .map(device => {

            const spinner = Widget.Spinner({
                active: device.bind("connecting"),
                visible: device.bind("connecting"),
            })

            const connectionButton = Widget.Button({
                label: device.bind("connected").as(connected => connected? "Disconnect" : "Connect"),
                visible: device.bind("connecting").as(connecting => !connecting),
                onPrimaryClick: () =>
                    device.setConnection(!device.connected)
            })

            return {
                title: device.name,
                iconName: device.bind("icon_name").as(iconName => iconName + "-symbolic"),
                classNames: device.bind("connected").as(connected => connected ? ["connected-entry"] : []),
                child: column([
                    Widget.Label(`${device.address}`),

                    Widget.Label({ 
                        label: device.bind("battery_percentage")
                            .as(percentage => percentage == 0? "Battery: Unknown" : `Battery: ${percentage}%`) 
                    }),

                    spinner,
                    
                    connectionButton
                ]),
            }
        })
        
    return AccordionList(getDevices)
}