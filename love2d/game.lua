local Grid = require("grid")
local Block = require("block")

local Game = {}
Game.__index = Game

local function get_all_blocks()
    return { 
        Block.IBlock.new(),
        Block.JBlock.new(),
        Block.SBlock.new(),
        Block.TBlock.new(),
        Block.LBlock.new(),
        Block.OBlock.new(),
        Block.ZBlock.new()
    }
end

function Game.new()
    local obj = {}
    setmetatable(obj, Game)
    obj.running = true
    obj.score = 0
    obj.blocks = get_all_blocks()
    obj.grid = Grid.new()
    obj.current_block = obj:get_random_block()
    obj.next_block = obj:get_random_block()
    return obj
end

function Game:update()
    self:move_block_down()
end

function Game:listen(key)
    if not self.running and key ~= nil then 
        self.running = true
        self:reset()
        return
    end

    if key == "up" then
        self:rotate_block()
        love.audio.play(_G.rotate_sound)
    elseif key == "left" then
        self:move_block_left()
    elseif key == "right" then
        self:move_block_right()
    elseif key == "down" then
        self:move_block_down()
        self:update_score(0, 1)
    end
end

function Game:get_random_block()
    if #self.blocks == 0 then
        self.blocks = get_all_blocks()
    end
    local idx = math.random(1, #self.blocks)
    local block = self.blocks[idx];
    table.remove(self.blocks, idx)
    return block
end

function Game:update_score(cleared_rows, press_down)
    if cleared_rows > 0 then
        self.score = self.score + (2*cleared_rows-1)*100
    end
    self.score = self.score + press_down
end

function Game:move_block_left()
    if not self.running then return end

    self.current_block:move(0, -1)
    if self:is_block_outside() or not self:is_block_fits() then
        self.current_block:move(0, 1)
    end
end

function Game:move_block_right()
    if not self.running then return end

    self.current_block:move(0, 1)
    if self:is_block_outside() or not self:is_block_fits() then
        self.current_block:move(0, -1)
    end
end

function Game:move_block_down()
    if not self.running then return end

    self.current_block:move(1, 0)
    if self:is_block_outside() or not self:is_block_fits() then
        self.current_block:move(-1, 0)
        self:lock_block()
    end
end

function Game:rotate_block()
    if not self.running then return end

    self.current_block:rotate()
    if self:is_block_outside() or not self:is_block_fits() then
        self.current_block:undo_rotate()
    end
end

function Game:draw()
    self.grid:draw()
    self.current_block:draw(0, 0)

    -- draw user interface (hardcode)

    -- title (score, next, game over)
    local ui_x = _G.grid_cols * _G.cell_size
    love.graphics.setFont(_G.large_font)
    love.graphics.setColor(_G.white)
    love.graphics.print("Score", ui_x + 45, 18)
    love.graphics.print("Next", ui_x + 55, 160)
    if not self.running then
        love.graphics.setFont(_G.medium_font)
        love.graphics.print("GAME OVER", ui_x + 20, 500)
    end

    -- score background box
    love.graphics.setColor(_G.light_blue)
    love.graphics.rectangle("fill", ui_x + 30, 90, 170, 60, 0.3, 6)

    -- score text
    love.graphics.setFont(_G.medium_font)
    love.graphics.setColor(_G.white)
    local score_text = tostring(self.score)
    local text_width = _G.medium_font:getWidth(score_text)
    love.graphics.print(score_text, ui_x + 30 + (170-text_width)/2, 90)

    -- next block background box
    love.graphics.setColor(_G.light_blue)
    love.graphics.rectangle("fill", ui_x + 25, 240, 190, 160, 0.3, 6)

    -- next block
    self.next_block:draw(9, 9)
end

function Game:is_block_outside()
    local moved_positions = self.current_block:get_moved_positions()
    for _, pos in ipairs(moved_positions) do 
        if self.grid:is_cell_outside(pos.row, pos.col) then
            return true
        end
    end
    return false
end

function Game:is_block_fits()
    local moved_positions = self.current_block:get_moved_positions()
    for _, pos in ipairs(moved_positions) do
        if not self.grid:is_cell_empty(pos.row, pos.col) then 
            return false
        end
    end
    return true
end

function Game:lock_block()
    local moved_positions = self.current_block:get_moved_positions()
    for _, pos in ipairs(moved_positions) do
        self.grid.cells[pos.row][pos.col] = self.current_block.id
    end

    local cleared_rows = self.grid:clear_full_rows()
    if cleared_rows > 0 then
        self:update_score(cleared_rows, 0)
        love.audio.play(_G.clear_sound)
    end

    self.current_block = self.next_block
    if not self:is_block_fits() then
        self.running = false
        return
    end
    self.next_block = self:get_random_block()
end

function Game:reset()
    self.score = 0
    self.blocks = get_all_blocks()
    self.grid:reset()
    self.current_block = self:get_random_block()
    self.next_block = self:get_random_block()
end

return Game
