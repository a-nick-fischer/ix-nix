import brightness from '../libs/brightness.js';

const BLUE_LIGHT_FILTER_TIME = 1900;

const time = Variable("", {
    poll: [1000, 'date "+%H%M"'],
})

let confirmed = false;

export async function registerBrightnessNotifier(){
    brightness.screen_value = 0.75;
    
    time.connect("changed", (variable) => {
        if (
            +variable.value >= BLUE_LIGHT_FILTER_TIME && 
            !brightness.blueLightFilterEnabled &&
            !confirmed
        ) {
            confirmed = true;

            Utils.notify({
                summary: '[BLUE LIGHT FILTER]',
                body: 'It\'s getting late chap, enable blue light filter?',
                iconName: 'weather-clear-night-symbolic"',
                actions: {
                    'Enable': () => brightness.blueLightFilterEnabled = true
                }
            })
        }
    })
}