var url = "https://cdn.rawgit.com/wakatime/c9-wakatime/master"
var pathConfig = {};
pathConfig["plugins/wakatime"] = url
require.config({paths: pathConfig})

require(["plugins/wakatime/wakatime", "plugins/wakatime/install"], function(plugin, install) {
    plugin({}, services, function(e, r) {
        r.wakatime.name = "wakatime";
        console.log(e, r)
        services.installer.createSession("wakatime", install.version, install)
    })
})