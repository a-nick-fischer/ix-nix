// Show journaloutput for systemd service changes for current boot 
// criticals, errors and warnings
const journal = Variable('', {
    listen: "journalctl -b -f _PID=1 -p 0..4"
})


const OUTPUT_REGEX = /.+ systemd\[1]: (.+)/;
function parseOutput(output){
    return output.split("\n").flatMap(line => {
        const match = line.match(OUTPUT_REGEX)
        return match? [match[1]] : []
    })
}

export async function registerServiceNotifier(){
    journal.connect("changed", ({ value }) => {
        parseOutput(value).forEach(async output => {
            Utils.notify({
                summary: "[SERVICE ERROR]",
                iconName: "error-symbolic",
                body: output,
            })
        })
    })
}