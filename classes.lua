local classes = {}

classes.tile = {
    new = function(self)
        local newTile = {}
        setmetatable(newTile, {__index = self})
        return newTile
    end
}


return classes