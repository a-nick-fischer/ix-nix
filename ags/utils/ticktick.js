// 1. Log-in to your TickTick Account and go to the Developer page
// 2. Create a new App with the OAuth return URI 'https://localhost'
// 3. Replace the '<client_id>' in the following URL with the client ID of your newly generated app and paste the URL into the browser
// https://ticktick.com/oauth/authorize?scope=tasks%3Aread+tasks%3Awrite&client_id=<client_id>&redirect_uri=https%3A%2F%2Flocalhost%2F&response_type=code
// 4. You will be redirected to an URL like 'https://localhost/?code=AAAAAA', make sure to save the code in the URL somewhere save
// 5. Create a file 'secrets.json' with the following content:
// {
//    "ticktick": {
//        "client_id": "YOUR OAUTH APP ID",
//        "client_secret": "YOUR OAUTH APP SECRET",
//        "code": "THE USER CODE YOU RECEIVED FROM THE URL IN STEP 4"
//    }

import { loadSecrets, saveSecrets } from "./secrets.js"

// }
const browser = "librewolf" // TODO set via env var

function urlEncodeObject(obj){
    return Object.entries(obj)
        .map(([key, value]) => `${encodeURIComponent(key)}=${encodeURIComponent(value)}`)
        .join("&")
}

export class TickTickAPI {

}

async function oauthGrantStep(){
    const secrets = loadSecrets()
    const url = `https://ticktick.com/oauth/authorize?scope=tasks%3Aread+tasks%3Awrite&client_id=${secrets.ticktick.client_id}&redirect_uri=http%3A%2F%2Flocalhost%3A8420%2F&response_type=code`
    
    // IMPORTANT: CLOSE THE TAB AFTER THE REDIRECT!!!
    Utils.exec([browser, url])
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

    saveSecrets("ticktick.code", code)
}

async function retrieveAccessTokenStep(){
    const secrets = loadSecrets()

    const response = await Utils.fetch(
        "https://ticktick.com/oauth/token",
        {
            method: "POST",

            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },

            body: urlEncodeObject({
                ...secrets.ticktick,
                grant_type: "authorization_code",
                scope: "tasks:write tasks:read",
                redirect_uri: "http://localhost:8420/"
            })
        }
    )
    .then(response => response.json())
    .catch(response => console.log(response))

    console.log(response)

    const accessToken = response.access_token
    const expireTime = Date.now() + response.expire

    if(!accessToken){
        console.error("Could not find access token!")
        return
    }

    saveSecrets("ticktick.access_token", accessToken)
    saveSecrets("ticktick.expire_time", expireTime)
}

export async function authenticateTickTick(){
    oauthGrantStep()
    retrieveAccessTokenStep()
}