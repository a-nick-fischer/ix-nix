import { loadSecrets, saveSecrets } from "./secrets.js"


const browser = "librewolf" // TODO set via env var
const ticktickApiBase = "api.ticktick.com"

function urlEncodeObject(obj){
    return Object.entries(obj)
        .map(([key, value]) => `${encodeURIComponent(key)}=${encodeURIComponent(value)}`)
        .join("&")
}

async function oauthGrantStep(){
    const secrets = loadSecrets()
    const url = `https://ticktick.com/oauth/authorize?scope=tasks%3Aread+tasks%3Awrite&client_id=${secrets.ticktick.client_id}&redirect_uri=http%3A%2F%2Flocalhost%3A8420%2F&response_type=code`
    
    console.log(`Opening ${url}`)
    // IMPORTANT: CLOSE THE TAB AFTER THE REDIRECT!!!
    Utils.execAsync([browser, url])

    console.log("Starting netcat")
    const stdout = Utils.exec(["nc", "-l", "8420"])

    var matches = /GET \/\?code=(.+) HTTP/.exec(stdout)
    if(matches == null){
        console.error("Failed to parse stdout, damn that regex..")
        return
    }

    const code = matches[1]    
    if(!code || code == ''){
        console.error("No oauth code in redirect! Damn that regex..")
        return
    }

    console.log(`Got temporary code ${code}`)

    return code
}

async function retrieveAccessTokenStep(code){
    const secrets = loadSecrets()

    console.log(`Requesting access token`)

    const response = await Utils.fetch(
        "https://ticktick.com/oauth/token",
        {
            method: "POST",

            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },

            body: urlEncodeObject({
                ...secrets.ticktick,
                code,
                grant_type: "authorization_code",
                scope: "tasks:write tasks:read",
                redirect_uri: "http://localhost:8420/"
            })
        }
    )
    .then(response => response.json())
    .catch(response => console.log(JSON.stringify(response)))

    const accessToken = response.access_token
    const expireTime = Date.now() + response.expires_in

    if(!accessToken){
        console.error("Could not find access token!")
        return
    }

    console.log(`Success, saving access token and expire-time`)

    saveSecrets("ticktick.access_token", accessToken)
    saveSecrets("ticktick.expire_time", expireTime)

    return accessToken
}

export function shouldReauthenticate(){
    return false 
    
    const secrets = loadSecrets()
    let accessToken = secrets.ticktick.access_token
    let tokenValidForMoreThan24h = (Date.now() - (60 * 60 * 24)) > secrets.ticktick.expire_time

    return !accessToken || !tokenValidForMoreThan24h
}

export async function reauthenticateTickTick(){
    // TODO: Maybe we can re-autorize using the temporary code when the access token is expired?
    console.log("Starting re-authorization")
    const code = await oauthGrantStep()
    await retrieveAccessTokenStep(code)
}

export async function createClient(){
    if(shouldReauthenticate()){
        return null
    }

    const secrets = loadSecrets()
    let accessToken = secrets.ticktick.access_token

    return new TickTickAPI(accessToken)
}

export class TickTickAPI {
    constructor(access_token){
        this.access_token = access_token

        this.reloadData()
    }

    async get(path){
        return await Utils.fetch(
            `https://${ticktickApiBase}${path}`,
            {
                headers: {
                    "Authorization": `Bearer ${this.access_token}`
                }
            }
        )
        .then(response => response.json())
        .catch(error => console.error(`API Request ${path} failed: ${JSON.stringify(error)}`))
    }

    async reloadData(){
        console.log("Loading ticktick user project...")
        const projects = await this.get("/open/v1/project")
        console.log(JSON.stringify(projects, null, 4))
        
        console.log("Loading ticktick project data...")
        const projectData = await this.get(`/open/v1/project/${projects[0].id}/data`)
        this.projectData = projectData;

        console.log(JSON.stringify(projectData, null, 4))
    }
}