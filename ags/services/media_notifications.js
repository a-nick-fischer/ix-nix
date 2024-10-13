const CHANGED = /\d{2}:\d{2}:\d{2}\.\d{3}: (Removed|Added) \/org\/freedesktop\/UDisks2\/block_devices\/(sda|sdb|sdc)$/

function parseOutput(output){
    const match = output.match(CHANGED)
    if(!match) return { added: false, removed: false }

    return {
        added: match[1] === "Added",
        removed: match[1] === "Removed",
        device: `/dev/${match[2]}`
    }
}

async function getMountpoint(device){
    return await Utils.execAsync(["lsblk", "-no", "MOUNTPOINT", device])
        .then(output => output.trim())
}

async function openNautlius(path){
    return await Utils.execAsync(["nautilus", "-w", path])
}

export async function registerMediaNotifier(){
    const log = Variable('', {
        listen: "udisksctl monitor"
    })

    log.connect("changed", ({ value }) => {
        const { added, removed, device } = parseOutput(value)
        //console.log(added, removed, device)

        if(added){
            Utils.notify({
                summary: "[MEDIA ADDED]",
                iconName: "media-optical-symbolic",
                body: `Device ${device} added`,
                actions: {
                    'Open in Nautilus': () => getMountpoint(device).then(openNautlius)
                }
            })
        }

        if(removed){
            Utils.notify({
                summary: "[MEDIA REMOVED]",
                iconName: "media-optical-symbolic",
                body: `Device ${device} removed`
            })
        }
    })
}