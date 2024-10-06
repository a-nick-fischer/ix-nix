import { column, makePopupWindow, row, withEventHandler } from "../utils/ags_helpers.js"
import { makeBarPopup } from "./bar.js"

const network = await Service.import('network')

function disconnectFromNetwork(ssid){
    Utils.exec(["nmcli", "con", "down", ssid])
}

function loginToNetwork(ssid){
    const content = column([
        Widget.Label(`Enter password for ${ssid}`),
        Widget.Entry({
            text: "",
            placeholder_text: "Password",
            visibility: false,
            onAccept: ({ text }) => {
                if(text == "") return
                Utils.exec(["nmcli", "device", "wifi", "connect", ssid, "password", text])
                App.removeWindow(window)
            }
        })
    ])


    const window = makePopupWindow({
        name: "password-dialog",
        anchor: [],
        extras: { visible: true },
        child: Widget.Box({
            child: content,
            css: 'padding: 10px;'
        })
    })

    App.add_window(window)
}

function WifiMenu(){
    network.wifi.scan()

    const generateWifiEntry = (aps) => {
        const apWithBestConnection = aps.sort((a, b) => b.strength - a.strength)[0]

        const details = Widget.Revealer({
            revealChild: false,
            transitionDuration: 1000,
            transition: 'slide_down',
            child: column([
                Widget.Label(`Max Strength: ${apWithBestConnection.strength}%`),
                Widget.Label(`${aps.length} APs available`),


                network.wifi.ssid == aps[0].ssid?
                    Widget.Button({
                        label: "Disconnect",
                        onClicked: () =>
                            disconnectFromNetwork(aps[0].ssid)
                    })
                    :
                    Widget.Button({
                        label: "Connect",
                        onClicked: () =>
                            loginToNetwork(aps[0].ssid)
                    }),

                Widget.Separator()
            ])
        })

        const header = withEventHandler({
            child: row([ 
                Widget.Icon({ icon: apWithBestConnection.iconName, size: 15 }),
                Widget.Label(apWithBestConnection.ssid) 
            ]),

            onPrimaryClick: () => details.reveal_child = !details.reveal_child
        })

        return column([
            header,
            details
        ], { class_name: network.wifi.ssid == apWithBestConnection.ssid? "connected-network-entry" : ""  })
    }

    const wifiList = column(
        network.wifi.bind("access_points")
            .as(aps => {
                const sorted = aps.sort((a, b) => b.strength - a.strength)
                const networks = groupBy(sorted, "ssid")
                return Object.values(networks)
                    .map((apsOfSsid) => generateWifiEntry(apsOfSsid))
            }),
    { spacing: 5 })

    return row([
        column([
            WifiIndicator(40),
            VpnIndicator(40)
        ], { spacing: 70 }),

        Widget.Scrollable({
            hscroll: "never",
            vscroll: "automatic",
            css: 'min-width: 170px;',
            child: wifiList
        })
    ])
}

function WifiIndicator(size = 15) {
    return Widget.Icon({
        icon: network.wifi.bind('icon_name'),
        size,
        tooltip_text: network.wifi.bind('state').as(state =>
            state? `Connected to ${network.wifi.ssid}` : "Disconnected"
        )
    })
}

function VpnIndicator(size = 15) {
    return Widget.Icon({
        icon: "network-vpn-disconnected-symbolic",
        size,
    })
}

function WiredIndicator(size = 15) {
    return Widget.Icon({
        icon: network.wired.bind('icon_name'),
        size,
        tooltip_text: network.wired.bind('state')
    })
}

export function NetworkWidget(size) {
    return Widget.Stack({
        children: {
            wifi: WifiIndicator(size),
            wired: WiredIndicator(size),
        },
        shown: network.bind('primary').as(p => p || 'wifi'),
    })
}


function NetworkControls(){
    return row([
        WifiMenu(),
    ], { class_name: "network-controls-inner",  css: "min-width: 200px; min-height: 165px;"  })
}

export function NetworkControlsPopup(){
    return makeBarPopup("network-controls", NetworkControls(), [1320, 50])
}

// From https://stackoverflow.com/questions/14446511/most-efficient-method-to-groupby-on-an-array-of-objects
const groupBy = (items, key) => items.reduce(
    (result, item) => ({
      ...result,
      [item[key]]: [
        ...(result[item[key]] || []),
        item,
      ],
    }), 
    {},
  );