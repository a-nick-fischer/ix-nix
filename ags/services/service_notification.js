const OUTPUT_REGEX = /.+ systemd\[1]: (.+)/;
function parseOutput(output){
    return output.split("\n").flatMap(line => {
        const match = line.match(OUTPUT_REGEX)
        return match? [match[1]] : []
    })
}

export async function registerServiceNotifier(){
    // Show journaloutput for systemd service changes for current boot 
    // criticals, errors and warnings
    // This thing itself throws errors but works anyways so we just pretend it doesn't
    const journal = Variable('', {
        listen: "journalctl -b -f _PID=1 -p 0..4"
    })

    const handle = journal.connect("changed", ({ value }) => {
        parseOutput(value).forEach(async output => {
            Utils.notify({
                summary: "[SERVICE ERROR]",
                iconName: "error-symbolic",
                body: output,
                actions: {
                    'Ye Shut Up': () => journal.disconnect(handle)
                }
            })
        })
    })
}