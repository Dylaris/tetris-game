local Grid = {}
Grid.__index = Grid

function Grid.new()
    local obj = {}
    setmetatable(obj, Grid)

    obj.cells = {}
    for row = 1, _G.grid_rows do
        obj.cells[row] = {}
        for col = 1, _G.grid_cols do
            obj.cells[row][col] = _G.id_nil
        end
    end

    return obj
end

function Grid:reset()
    for row = 1, _G.grid_rows do
        for col = 1, _G.grid_cols do
            self.cells[row][col] = _G.id_nil
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
    return _G.map_color[value]
end

function Grid:is_cell_empty(row, col)
    return self.cells[row][col] == _G.id_nil
end

function Grid:is_cell_outside(row, col)
    if row >= 1 and row <= _G.grid_rows and col >= 1 and col <= _G.grid_cols then
        return false
    end
    return true
end

function Grid:clear_full_rows()
    local function is_row_full(row)
        for col = 1, _G.grid_cols do
            if self.cells[row][col] == _G.id_nil then
                return false
            end
        end
        return true
    end

    local function clear_row(row)
        for col = 1, _G.grid_cols do
            self.cells[row][col] = _G.id_nil
        end
    end

    local function move_row_down(row, n)
        for col = 1, _G.grid_cols do
            self.cells[row + n][col] = self.cells[row][col]
            self.cells[row][col] = _G.id_nil
        end
    end

    local completed = 0
    for row = _G.grid_rows, 1, -1 do
        if is_row_full(row) then
            clear_row(row)
            completed = completed + 1
        elseif completed > 0 then
            move_row_down(row, completed)
        end
    end
    return completed
end

return Grid
