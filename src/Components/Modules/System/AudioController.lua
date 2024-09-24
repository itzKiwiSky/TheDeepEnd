local AudioController = {}
AudioController.__index = AudioController

local function _new()
    local this = setmetatable({}, AudioController)
    this.channels = {}
    return this
end

function AudioController:playAudioChannel(_filename, _channel, _loop)
    if not self.channels[_channel] then
        self.channels[_channel] = love.audio.newSource(_filename, "static")
        self.channels[_channel]:setLooping(_loop or false)
        self.channels[_channel]:play()
    else
        self.channels[_channel]:setLooping(_loop or false)
        self.channels[_channel]:play()
    end
end

function AudioController:checkAudio()
    for k, v in pairs(self.channels) do
        if not v:isLooping() and not v:isPlaying() and v:tell("seconds") >= v:getDuration("seconds") then
            v:release()
            collectgarbage("collect")
        end
    end 
end

function AudioController:clearChannels()
    for k, v in pairs(self.channels) do
        v:stop()
    end
    for k, v in pairs(self.channels) do
        v:release()
    end
    collectgarbage("collect")
end

return setmetatable(AudioController, { __call = function(_, ...) return _new(...) end })