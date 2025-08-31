local Position = {}
Position.__index = Position

function Position.new(row, col)
    local obj = {}
    setmetatable(obj, Position)
    obj.row = row or 1
    obj.col = col or 1
    return obj
end

Position.__add = function(p1, p2)
    return Position.new(p1.row + p2.row, p1.col + p2.col)
end

return Position
