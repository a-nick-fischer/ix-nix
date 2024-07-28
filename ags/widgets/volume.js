import { makeWindow, withEventHandler } from "../utils/ags_helpers.js"

const audio = await Service.import("audio")

const icons = {
    101: "overamplified",
    67: "high",
    34: "medium",
    1: "low",
    0: "muted",
}

function getIconName() {
    const icon = audio.speaker.is_muted ? 0 : [101, 67, 34, 1, 0].find(
        threshold => threshold <= audio.speaker.volume * 100)

    return `audio-volume-${icons[icon]}-symbolic`
}


export function SmallVolumeWidget(){
    return withEventHandler({
        onPrimaryClick: () => 
            audio.speaker.is_muted = !audio.speaker.is_muted,

        child: Widget.Icon().hook(audio.speaker, (self) => {
            const vol = audio.speaker.volume * 100;

            self.icon = getIconName()
            self.tooltip_text = audio.speaker.is_muted? 
                "Volume Muted" : `Volume: ${Math.floor(vol)}%`;
        })
    })
}


export function VolumeControl() {
    return null // TODO
}