import { makeWindow, sliderBox, withEventHandler } from "../utils/ags_helpers.js"

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

export function VolumeWidget(size = 15){
    return withEventHandler({
        onPrimaryClick: () => 
            audio.speaker.is_muted = !audio.speaker.is_muted,

        child: Widget.Icon({ size }).hook(audio.speaker, (self) => {
            const vol = audio.speaker.volume * 100;
    
            self.icon = getSpeakerIconName()
            self.tooltip_text = audio.speaker.is_muted? 
                "Volume Muted" : `Volume: ${Math.floor(vol)}%`;
        })
    })
}

export function MicrophoneWidget(size = 15){
    return withEventHandler({
        onPrimaryClick: () => 
            audio.microphone.is_muted = !audio.microphone.is_muted,

        child: Widget.Icon({ size }).hook(audio.microphone, (self) => {
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


export function VolumeSlider() {
    const slider = Widget.Slider({
        on_change: self => audio.speaker.volume = self.value,
        value: audio.speaker.bind('volume'),
        draw_value: false,
    });

    const icon = VolumeWidget(30)

    return sliderBox(icon, slider)
}

export function MicrophoneSlider() {
    const slider = Widget.Slider({
        on_change: self => audio.microphone.volume = self.value,
        value: audio.microphone.bind('volume'),
        draw_value: false,
    });

    const icon = MicrophoneWidget(30)

    return sliderBox(icon, slider)
}