const hyprland = await Service.import("hyprland")

const NO_FOCUSED_WINDOW_ADDRESS = "0x"

let wasAnyWindowFocused = false

function changeBackground(imagename){
    const command = `hyprctl hyprpaper wallpaper ", ~/.config/nixos/assets/${imagename}.png"`
    Utils.exec(command)
}

// Only show background cat if no window is open in workspace
export async function registerBackgroundHandler(){
    hyprland.active.connect("changed", active => {
        
        const isAnyWindowFocused = active.client.address !== NO_FOCUSED_WINDOW_ADDRESS

        const isKando = active.client.class == "kando"

        // Do not change background if kando is the only thing on the workspace
        if(!wasAnyWindowFocused && isKando) return;
        
        if(isAnyWindowFocused == wasAnyWindowFocused) return
        wasAnyWindowFocused = isAnyWindowFocused

        changeBackground(isAnyWindowFocused ? "empty" : "main")
    })
}