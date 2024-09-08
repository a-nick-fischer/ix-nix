import { column, makePopupWindow, sliderBox } from '../utils/ags_helpers.js';
import brightness from '../utils/brightness.js';
import { VolumeSlider, MicrophoneSlider } from './audio.js';

function BrightnessSlider(){
    const slider = Widget.Slider({
        min: 0.10,
        on_change: self => brightness.screen_value = self.value,
        value: brightness.bind('screen-value'),
    });

    return sliderBox(slider)
}

export function SliderControls(){
    return column([
        BrightnessSlider(),
        VolumeSlider(),
        MicrophoneSlider()
    ])
}

export const SLIDER_CONTROL_WINDOW = "slider-controls"

export function SliderControlsPopup(){
    return makePopupWindow({
        name: SLIDER_CONTROL_WINDOW,
        transition: "crossfade",
        margins: [50, 0, 0, 0],
        anchor: ["top"],
        child: SliderControls()
    })
}