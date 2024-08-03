import { makeWindow, withEventHandler } from "../utils/ags_helpers.js"

const audio = await Service.import("audio")

const speakerIcons = {
    101: "overamplified",
    67: "high",
    34: "medium",
    1: "low",
    0: "muted",
}

function getSpeakerIconName() {
    const icon = audio.speaker.is_muted ? 0 : [101, 67, 34, 1, 0].find(
        threshold => threshold <= audio.speaker.volume * 100)

    return `audio-volume-${speakerIcons[icon]}-symbolic`
}


export function SmallVolumeWidget(){
    return withEventHandler({
        onPrimaryClick: () => 
            audio.speaker.is_muted = !audio.speaker.is_muted,

        child: Widget.Icon().hook(audio.speaker, (self) => {
            const vol = audio.speaker.volume * 100;

            self.icon = getSpeakerIconName()
            self.tooltip_text = audio.speaker.is_muted? 
                "Volume Muted" : `Volume: ${Math.floor(vol)}%`;
        })
    })
}

export function SmallMicrophoneWidget(){
    return withEventHandler({
        onPrimaryClick: () => 
            audio.microphone.is_muted = !audio.microphone.is_muted,

        child: Widget.Icon().hook(audio.microphone, (self) => {
            if(audio.microphone.is_muted){
                self.icon = "microphone-disabled-symbolic"
                self.tooltip_text = "Muted"
            }
            else {
                self.icon = "audio-input-microphone-symbolic"
                self.tooltip_text = "Unmuted"
            }
        })
    })
}


export function VolumeControl() {
    return null // TODO
}