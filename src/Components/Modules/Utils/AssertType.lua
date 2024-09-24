function assertType(_var, _expected)
    local strTemplate = "[ERROR] : Invalid parameter type. Expected '%s', got: '%s'"
    assert(type(_var) == _expected, string.format(strTemplate, _expected, type(_var)))
end