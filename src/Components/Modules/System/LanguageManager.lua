local LanguageManager = {}
LanguageManager.__index = LanguageManager

local function _findKey(_tblInput, _tblOutput)
    for k, v in pairs(_tblInput) do
        if type(v) == "table" then
            _findKey(v, _tblOutput)
        else
            _tblOutput[k] = v
        end
    end
end

local function _new(_language)
    local self = setmetatable({}, LanguageManager)
        self = {}

        local tempdata = json.decode(love.filesystem.read("assets/data/language/" .. _language .. ".lang"))
        _findKey(tempdata, self)
    return self
end

return setmetatable(LanguageManager, { __call = function(_, ...) return _new(...) end })