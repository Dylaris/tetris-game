local game = nil

function love.load()
    -- color
    _G.white      = {255/255, 255/255, 255/255, 255/255};
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
    
    -- font
    _G.small_font  = love.graphics.newFont("assets/monogram.ttf", 40)
    _G.medium_font  = love.graphics.newFont("assets/monogram.ttf", 60)
    _G.large_font  = love.graphics.newFont("assets/monogram.ttf", 80)

    -- music
    _G.bg_music     = love.audio.newSource("assets/music.mp3", "stream")
    _G.clear_sound  = love.audio.newSource("assets/clear.mp3", "static")
    _G.rotate_sound = love.audio.newSource("assets/rotate.mp3", "static")

    love.audio.play(_G.bg_music)
    _G.bg_music:setLooping(true)
    _G.bg_music:setVolume(0.5)

    -- value of grid cell
    _G.id_nil = "-"
    _G.id_i   = "I"
    _G.id_j   = "J"
    _G.id_s   = "S"
    _G.id_t   = "T"
    _G.id_l   = "L"
    _G.id_o   = "O"
    _G.id_z   = "Z"

    -- block shape map to block color
    _G.map_color = {
        [_G.id_nil] = _G.dark_grey, -- no block occupy
        [_G.id_i]   = _G.green,
        [_G.id_j]   = _G.red,
        [_G.id_s]   = _G.orange,
        [_G.id_t]   = _G.yellow,
        [_G.id_l]   = _G.purple,
        [_G.id_o]   = _G.cyan,
        [_G.id_z]   = _G.blue
    }

    _G.total_ids = 7

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
    _G.ui_cols       = 8
    _G.screen_height = _G.grid_rows * _G.cell_size
    _G.screen_width  = (_G.grid_cols + _G.ui_cols) * _G.cell_size

    love.window.setMode(_G.screen_width, _G.screen_height, {resizable = false})
    love.window.setTitle("My Tetris Game")
    love.graphics.setBackgroundColor(_G.dark_blue)

    math.randomseed(os.time())

    game = require("game").new()
end

local last_update_time = 0
local function event_triggered(internal)
    local current_time = love.timer.getTime()
    if current_time - last_update_time >= internal then
        last_update_time = love.timer.getTime()
        return true
    end
    return false
end

function love.update()
    if event_triggered(0.2) then
        game:update()
    end
end

function love.keypressed(key)
    game:listen(key)
end

function love.draw()
    game:draw()
end
