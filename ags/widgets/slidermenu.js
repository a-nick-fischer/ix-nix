import { column, makePopupWindow, sliderBox, withEventHandler } from '../utils/ags_helpers.js';
import brightness from '../utils/brightness.js';
import { VolumeSlider, MicrophoneSlider } from './audio.js';
import { makeBarPopup, windowsToToggle } from './bar.js';

function BrightnessWidget(){
    let blueLightEnabled = Utils.exec("hyprshade current")
        .includes("blue-light-filter");

    const getIcon = () => {
        if(blueLightEnabled)
            return "weather-clear-night-symbolic";
        else
            return "display-brightness-symbolic";
    }

    const icon = Widget.Icon({
        icon: getIcon(),
        size: 30
    })

    return withEventHandler({
        onPrimaryClick: () => {
            Utils.exec("hyprshade toggle blue-light-filter")
            blueLightEnabled = !blueLightEnabled;
            icon.icon = getIcon();
        },

        child: icon
    })
}

function BrightnessSlider(){
    const slider = Widget.Slider({
        min: 0.10,
        on_change: self => brightness.screen_value = self.value,
        value: brightness.bind('screen-value'),
        draw_value: false,
    });

    const icon = BrightnessWidget()

    return sliderBox(icon, slider)
}

export function SliderControls(){
    return column([
        BrightnessSlider(),
        VolumeSlider(),
        MicrophoneSlider()
    ], { class_name: "slider-controls-inner" })
}

export function SliderControlsPopup(){
    return makeBarPopup("slider-controls", SliderControls(), [590, 50])
}