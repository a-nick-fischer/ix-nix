import { AccordionList, column, makePopupWindow, row, withEventHandler } from "../utils/ags_helpers.js"
import { makeBarPopup } from "./bar.js"

const network = await Service.import('network')

function existingConnections(){
    return Utils.exec(["nmcli", "-t", "--fields", "NAME", "con"]).split("\n")
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

                if(ssid in existingConnections) 
                    Utils.exec(["nmcli", "con", "up", ssid])
                else
                    Utils.exec(["nmcli", "device", "wifi", "connect", ssid, "password", text])
            }
        })
    ])
}

function WifiMenu(){
    network.wifi.scan()

    return row([
        column([
            WifiIndicator(40),
            VpnIndicator(40)
        ], { spacing: 70 }),

        WifiList()
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

function WifiList(){
    return AccordionList(() => {
        const sorted = network.wifi.access_points.sort((a, b) => b.strength - a.strength)
        const networks = groupBy(sorted, "ssid")
        return Object.values(networks)
            .map((apsOfSsid) => {
                const ssid = apsOfSsid[0].ssid
                const connected = network.wifi.ssid == ssid
                const apWithBestConnection = apsOfSsid.sort((a, b) => b.strength - a.strength)[0]

                const loginDialog = Widget.Entry({
                    text: "",
                    placeholder_text: "Password",
                    visible: false,
                    visibility: false,
                    onAccept: ({ text }) => {
                        if(text == "") return
        
                        if(ssid in existingConnections) 
                            Utils.exec(["nmcli", "con", "up", ssid])
                        else
                            Utils.exec(["nmcli", "device", "wifi", "connect", ssid, "password", text])
                    }
                })

                return {
                    title: ssid,
                    iconName: apWithBestConnection.iconName,
                    classNames: connected? ["connected-entry"] : [],
                    child: column([
                        Widget.Label(`Max Strength: ${apWithBestConnection.strength}%`),
                        Widget.Label(`${apsOfSsid.length} APs available`),

                        loginDialog,
        
                        connected?
                            Widget.Button({
                                label: "Disconnect",
                                onClicked: () =>
                                    Utils.exec(["nmcli", "con", "down", ssid])
                            })
                            :
                            Widget.Button({
                                label: "Connect",
                                onClicked: () => {
                                    if(ssid in existingConnections)
                                        Utils.exec(["nmcli", "con", "up", ssid])
                                    else
                                        loginDialog.visible = true
                                }
                            }),
                    ])
                }
            })
    })
}