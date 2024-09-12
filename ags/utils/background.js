const hyprland = await Service.import("hyprland")

const NO_FOCUSED_WINDOW_ADDRESS = "0x"

let was_any_window_focused = false

function changeBackground(imagename){
    const command = `hyprctl hyprpaper wallpaper ", ~/.config/nixos/assets/${imagename}.png"`
    Utils.exec(command)
}

// Only show background cat if no window is open in workspace
export async function registerBackgroundHandler(){
    hyprland.active.connect("changed", active => {
        
        const is_any_window_focused = active.client.address !== NO_FOCUSED_WINDOW_ADDRESS
        
        if(is_any_window_focused == was_any_window_focused) return
        was_any_window_focused = is_any_window_focused

        changeBackground(is_any_window_focused ? "empty" : "main")
    })
}