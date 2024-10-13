import internet from '../libs/internet.js';

export function registerInternetConnectivityNotifier(){
    internet.connect('internet-connectivity-changed', (status) => {
        if(status.internet_connectivity){
            Utils.notify({
                summary: "[CONNECTIVITY RESTORED]",
                iconName: "face-cool-symbolic",
                body: "Internet connectivity has been restored",
            })
        } 
        else {
            Utils.notify({
                summary: "[CONNECTIVITY LOST]",
                iconName: "face-crying-symbolic",
                body: `Internet connectivity has been lost`,
            })
        }
    });

    internet.connect('dns-connectivity-changed', (status) => {
        if(status.dns_connectivity){
            Utils.notify({
                summary: "[DNS RESTORED]",
                iconName: "face-laugh-symbolic",
                body: "DNS connectivity has been restored",
            })
        } 
        else {
            Utils.notify({
                summary: "[DNS LOST]",
                iconName: "face-plain-symbolic",
                body: `DNS connectivity has been lost`,
            })
        }
    });

    internet.connect('gateway-connectivity-changed', (status) => {
        if(status.gateway_connectivity){
            Utils.notify({
                summary: "[GATEWAY RESTORED]",
                iconName: "face-surprise-symbolic",
                body: "Gateway connectivity has been restored",
            })
        } 
        else {
            Utils.notify({
                summary: "[GATEWAY LOST]",
                iconName: "face-tired-symbolic",
                body: `Gateway connectivity has been lost`,
            })
        }
    });
}