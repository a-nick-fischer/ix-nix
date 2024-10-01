import internet from '../services/internet.js';

const CHECK_INTERVAL_MS = 10000;
const TIMEOUT_SEC = 3;
const CHECK_IP = '1.1.1.1';
const CHECK_DNS = 'one.one.one.one';
const CHECK_ADDRESS = ' ifconfig.io '

// From https://aylur.github.io/ags-docs/config/custom-service/
class InternetConnectivityService extends Service {
    // every subclass of GObject.Object has to register itself
    static {
        // takes three arguments
        // the class itself
        // an object defining the signals
        // an object defining its properties
        Service.register(
            this,
            {
                // 'name-of-signal': [type as a string from GObject.TYPE_<type>],
                'internet-connectivity-changed': ['boolean'],

                'dns-connectivity-changed': ['boolean'],

                'gateway-connectivity-changed': ['boolean'],
            },
            {
                // 'kebab-cased-name': [type as a string from GObject.TYPE_<type>, 'r' | 'w' | 'rw']
                // 'r' means readable
                // 'w' means writable
                // guess what 'rw' means
                'internet-connectivity': ['boolean', 'r'],

                'dns-connectivity': ['boolean', 'r'],

                'gateway-connectivity': ['boolean', 'r'],
            },
        );
    }

    #internetConnectivity = true;
    #dnsConnectivity = true;
    #gatewayConnectivity = true;

    // the getter has to be in snake_case
    get internet_connectivity() {
        return this.#internetConnectivity;
    }

    get dns_connectivity() {
        return this.#dnsConnectivity;
    }

    get gateway_connectivity() {
        return this.#gatewayConnectivity;
    }

    get external_ip(){
        return Utils.exec(`curl ${CHECK_ADDRESS}`);
    }

    get gateway_ip(){
        return Utils.exec(["bash", "-c", `ip route list | awk ' /^default/ {print $3}'`]);
    }

    constructor() {
        super();

        // setup monitors
        Utils.interval(CHECK_INTERVAL_MS, () => {
            this.#checkInternetConnectivity();
            this.#checkDNSConnectivity();
            this.#checkGatewayConnectivity();
        });
    }

    async #checkGatewayConnectivity() {
        const status = await this.#checkConnectivityViaPing(this.gateway_ip)

        if(status !== this.#gatewayConnectivity){
            this.#gatewayConnectivity = status;
            this.notify('gateway-connectivity');
            this.emit('changed');
            this.emit('gateway-connectivity-changed', status);
        }
    }

    async #checkDNSConnectivity() {
        const status = await this.#checkConnectivityViaCurl(CHECK_DNS)

        if(status !== this.#dnsConnectivity){
            this.#dnsConnectivity = status;
            this.notify('dns-connectivity');
            this.emit('changed');
            this.emit('dns-connectivity-changed', status);
        }
    }

    async #checkInternetConnectivity() {
        const status = await this.#checkConnectivityViaCurl(CHECK_IP)

        if(status !== this.#internetConnectivity){
            this.#internetConnectivity = status;
            this.notify('internet-connectivity');
            this.emit('changed');
            this.emit('internet-connectivity-changed', status);
        }
    }

    async #checkConnectivityViaCurl(address) {
        try {
            return await Utils.execAsync(['bash', '-c', `curl -m ${TIMEOUT_SEC} ${address} -s --output /dev/null && echo $?`]) == "0"
        }
        catch(e){
            return false
        }
    }

    async #checkConnectivityViaPing(address) {
        if(address == "") return false

        try {
            return await Utils.execAsync(['bash', '-c', `ping -c 1 -W ${TIMEOUT_SEC} ${address} > /dev/null && echo $?`]) == "0"
        }
        catch(e){
            return false
        }
        
    }
}

// the singleton instance
const service = new InternetConnectivityService;

// export to use in other modules
export default service;