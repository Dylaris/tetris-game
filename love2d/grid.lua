local Grid = {}
Grid.__index = Grid

-- grid cell value map to block shape  
local map_shape = {
    [0] = "-", -- no block occupy
    [1] = "I",
    [2] = "J",
    [3] = "S",
    [4] = "T",
    [5] = "L",
    [6] = "O",
    [7] = "Z"
}

-- block shape map to block color
local map_color = {
    ["-"] = _G.dark_grey, -- no block occupy
    ["I"] = _G.green,
    ["J"] = _G.red,
    ["S"] = _G.orange,
    ["T"] = _G.yellow,
    ["L"] = _G.purple,
    ["O"] = _G.cyan,
    ["Z"] = _G.blue
}

function Grid:new()
    local obj = {}
    setmetatable(obj, self)

    obj.cells = {}
    for row = 1, _G.grid_rows do
        obj.cells[row] = {}
        for col = 1, _G.grid_cols do
            obj.cells[row][col] = 0
        end
    end

    return obj
end

function Grid:reset()
    for row = 1, _G.grid_rows do
        for col = 1, _G.grid_cols do
            self.cells[row][col] = 0
        end
    end
end

function Grid:print()
    for row = 1, _G.grid_rows do
        print(unpack(self.cells[row]))
    end
end

function Grid:draw()
    for row = 1, _G.grid_rows do
        for col = 1, _G.grid_cols do
            love.graphics.setColor(self:get_cell_color(row, col))
            love.graphics.rectangle(
                "fill",
                (col-1)*_G.cell_size + _G.cell_gap,
                (row-1)*_G.cell_size + _G.cell_gap,
                _G.cell_size - _G.cell_gap,
                _G.cell_size - _G.cell_gap)
        end
    end
end

function Grid:get_cell_color(row, col)
    local value = self.cells[row][col]
    return map_color[map_shape[value]]
end

return Grid
