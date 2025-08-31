local Position = require("position")

-- Base class

local Block = {}
Block.__index = Block

function Block:init(id, shapes)
    self.id = id
    self.rotate_state = math.random(1, 4) -- 1..4
    self.shapes = shapes
    self.row_offset = 0
    self.col_offset = 0
    self:move(0, math.floor(1/3*_G.grid_cols))
end

function Block:draw(row_off, col_off)
    local positions = self:get_moved_positions()
    for _, position in ipairs(positions) do
        love.graphics.setColor(_G.map_color[self.id])
        love.graphics.rectangle(
            "fill",
            (position.col-1+col_off)*_G.cell_size + _G.cell_gap,
            (position.row-1+row_off)*_G.cell_size + _G.cell_gap,
            _G.cell_size - _G.cell_gap,
            _G.cell_size - _G.cell_gap)
    end
end

function Block:get_moved_positions()
    local moved_positions = {}
    local shapes = self.shapes[self.rotate_state]
    for _, position in ipairs(shapes) do
        local moved_pos = position + Position.new(self.row_offset, self.col_offset)
        table.insert(moved_positions, moved_pos)
    end
    return moved_positions
end

function Block:move(rows, cols)
    self.row_offset = self.row_offset + rows
    self.col_offset = self.col_offset + cols
end

function Block:rotate()
    -- 1..4
    self.rotate_state = self.rotate_state + 1
    if self.rotate_state > 4 then
        self.rotate_state = 1
    end
end

function Block:undo_rotate()
    self.rotate_state = self.rotate_state - 1
    if self.rotate_state < 1 then
        self.rotate_state = 4
    end
end

-- Inheritance

local IBlock = {}
local JBlock = {}
local SBlock = {}
local TBlock = {}
local LBlock = {}
local OBlock = {}
local ZBlock = {}

function IBlock.new()
    local obj = {}
    setmetatable(obj, Block)

    local shapes = {
        {Position.new(2, 1), Position.new(2, 2), Position.new(2, 3), Position.new(2, 4)},
        {Position.new(1, 3), Position.new(2, 3), Position.new(3, 3), Position.new(4, 3)},
        {Position.new(3, 1), Position.new(3, 2), Position.new(3, 3), Position.new(3, 4)},
        {Position.new(1, 2), Position.new(2, 2), Position.new(3, 2), Position.new(4, 2)},
    }
    obj:init(_G.id_i, shapes)

    return obj
end

function JBlock.new()
    local obj = {}
    setmetatable(obj, Block)

    local shapes = {
        {Position.new(1, 1), Position.new(2, 1), Position.new(2, 2), Position.new(2, 3)},
        {Position.new(1, 2), Position.new(1, 3), Position.new(2, 2), Position.new(3, 2)},
        {Position.new(2, 1), Position.new(2, 2), Position.new(2, 3), Position.new(3, 3)},
        {Position.new(1, 2), Position.new(2, 2), Position.new(3, 1), Position.new(3, 2)},
    }
    obj:init(_G.id_j, shapes)

    return obj
end

function SBlock.new()
    local obj = {}
    setmetatable(obj, Block)

    local shapes = {
        {Position.new(1, 2), Position.new(1, 3), Position.new(2, 1), Position.new(2, 2)},
        {Position.new(1, 2), Position.new(2, 2), Position.new(2, 3), Position.new(3, 3)},
        {Position.new(2, 2), Position.new(2, 3), Position.new(3, 1), Position.new(3, 2)},
        {Position.new(1, 1), Position.new(2, 1), Position.new(2, 2), Position.new(3, 2)},
    }
    obj:init(_G.id_s, shapes)

    return obj
end

function TBlock.new()
    local obj = {}
    setmetatable(obj, Block)

    local shapes = {
        {Position.new(1, 2), Position.new(2, 1), Position.new(2, 2), Position.new(2, 3)},
        {Position.new(1, 2), Position.new(2, 2), Position.new(2, 3), Position.new(3, 2)},
        {Position.new(2, 1), Position.new(2, 2), Position.new(2, 3), Position.new(3, 2)},
        {Position.new(1, 2), Position.new(2, 1), Position.new(2, 2), Position.new(3, 2)},
    }
    obj:init(_G.id_t, shapes)

    return obj
end

function LBlock.new()
    local obj = {}
    setmetatable(obj, Block)

    local shapes = {
        {Position.new(1, 3), Position.new(2, 1), Position.new(2, 2), Position.new(2, 3)},
        {Position.new(1, 2), Position.new(2, 2), Position.new(3, 2), Position.new(3, 3)},
        {Position.new(2, 1), Position.new(2, 2), Position.new(2, 3), Position.new(3, 1)},
        {Position.new(1, 2), Position.new(1, 3), Position.new(2, 2), Position.new(3, 2)}
    }
    obj:init(_G.id_l, shapes)

    return obj
end

function OBlock.new()
    local obj = {}
    setmetatable(obj, Block)

    local shapes = {
        {Position.new(1, 1), Position.new(1, 2), Position.new(2, 1), Position.new(2, 2)},
        {Position.new(1, 1), Position.new(1, 2), Position.new(2, 1), Position.new(2, 2)},
        {Position.new(1, 1), Position.new(1, 2), Position.new(2, 1), Position.new(2, 2)},
        {Position.new(1, 1), Position.new(1, 2), Position.new(2, 1), Position.new(2, 2)},
    }
    obj:init(_G.id_o, shapes)

    return obj
end

function ZBlock.new()
    local obj = {}
    setmetatable(obj, Block)

    local shapes = {
        {Position.new(1, 1), Position.new(1, 2), Position.new(2, 2), Position.new(2, 3)},
        {Position.new(1, 3), Position.new(2, 2), Position.new(2, 3), Position.new(3, 2)},
        {Position.new(2, 1), Position.new(2, 2), Position.new(3, 2), Position.new(3, 3)},
        {Position.new(1, 2), Position.new(2, 1), Position.new(2, 2), Position.new(3, 1)},
    }
    obj:init(_G.id_z, shapes)

    return obj
end

return { 
    ["IBlock"] = IBlock,
    ["JBlock"] = JBlock,
    ["SBlock"] = SBlock,
    ["TBlock"] = TBlock,
    ["LBlock"] = LBlock,
    ["OBlock"] = OBlock,
    ["ZBlock"] = ZBlock
}
