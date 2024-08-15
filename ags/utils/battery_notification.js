const battery = await Service.import("battery")

let notified50 = false
let notified20 = false

export function registerBatteryNotifier(){
    battery.bind('percent').as(percent => {
        if(percent < 50 && !notified50){
            notified50 = true

            Utils.notify({
                summary: "Battery below 50%",
                iconName: "info-symbolic",
                body: "Please get me some power chap"
            })
        }

        if(percent < 20 && !notified20){
            notified20 = true

            Utils.notify({
                summary: "Battery below 20%",
                iconName: "error-symbolic",
                body: "Buddy, I'm dying here"
            })
        }
    })
}