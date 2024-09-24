local Presence = {
    state = "Initializing...",
    details = "Getting everything done",
    largeImageKey = "icon",
    largeImageText = "Playing Neonix!",
}

function Presence.update()
    discordrpc.updatePresence(Presence)
end

return Presence