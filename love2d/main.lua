local grid = nil

function love.load()
    -- color
    _G.dark_blue  = {44 /255, 44 /255, 127/255, 255/255};
    _G.light_blue = {59 /255, 85 /255, 162/255, 255/255}; 
    _G.dark_grey  = {26 /255, 31 /255, 40 /255, 255/255};
    _G.green      = {47 /255, 230/255, 23 /255, 255/255};
    _G.red        = {232/255, 18 /255, 18 /255, 255/255};
    _G.orange     = {226/255, 116/255, 17 /255, 255/255};
    _G.yellow     = {237/255, 234/255, 4  /255, 255/255};
    _G.purple     = {166/255, 0  /255, 247/255, 255/255};
    _G.cyan       = {21 /255, 204/255, 209/255, 255/255};
    _G.blue       = {13 /255, 64 /255, 216/255, 255/255};

    -- screen
    -- +++++++++++++++++++++
    -- +            +      +
    -- +            +      +
    -- +            +      +
    -- +            +      +
    -- +    grid    +  ui  +
    -- +            +      +
    -- +            +      +
    -- +            +      +
    -- +            +      +
    -- +++++++++++++++++++++
    _G.cell_size     = 30
    _G.cell_gap      = 1
    _G.grid_rows     = 20
    _G.grid_cols     = 10
    _G.ui_cols       = 6
    _G.screen_height = _G.grid_rows * _G.cell_size
    _G.screen_width  = (_G.grid_cols + _G.ui_cols) * _G.cell_size

    love.window.setMode(_G.screen_width, _G.screen_height, {resizable = false})
    love.window.setTitle("My Tetris Game")
    love.graphics.setBackgroundColor(unpack(_G.dark_blue))

    grid = require("grid"):new()
end

function love.update()
end

function love.draw()
    grid:draw()
end
