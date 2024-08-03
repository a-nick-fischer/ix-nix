const SECRETS_FILE = "secrets.json"

export function loadSecrets(){
    return JSON.parse(Utils.readFile(SECRETS_FILE))
}

export function saveSecrets(key, value){
    const secrets = loadSecrets()
    
    const subKeys = key.split(".")
    const lastKey = subKeys.pop()

    let current = secrets
    for(const subkey of subKeys){
        current = current[subkey]
    }

    current[lastKey] = value

    Utils.writeFileSync(JSON.stringify(secrets, null, 4), SECRETS_FILE)  
}