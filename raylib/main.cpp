#include <iostream>
#include <vector>
#include <map>
#include <random>
#include <raylib.h>

static constexpr Color dark_blue  = {44 , 44 , 127, 255};
static constexpr Color light_blue = {59 , 85 , 162, 255}; 
static constexpr Color dark_grey  = {26 , 31 , 40 , 255};
static constexpr Color green      = {47 , 230, 23 , 255};
static constexpr Color red        = {232, 18 , 18 , 255};
static constexpr Color orange     = {226, 116, 17 , 255};
static constexpr Color yellow     = {237, 234, 4  , 255};
static constexpr Color purple     = {166, 0  , 247, 255};
static constexpr Color cyan       = {21 , 204, 209, 255};
static constexpr Color blue       = {13 , 64 , 216, 255};

struct Grid {
    int grid[20][10];

    Grid() {
        num_rows  = 20;
        num_cols  = 10;
        cell_size = 30;

        for (int row = 0; row < num_rows; row++) {
            for (int col = 0; col < num_cols; col++) {
                grid[row][col] = 0;
            }
        }

        colors = {dark_grey, green, red, orange, yellow, purple, cyan, blue};
    }

    void reset() {
        for (int row = 0; row < num_rows; row++) {
            for (int col = 0; col < num_cols; col++) {
                grid[row][col] = 0;
            }
        }
    }

    void print() {
        for (int row = 0; row < num_rows; row++) {
            for (int col = 0; col < num_cols; col++) {
                std::cout << grid[row][col] << " ";
            }
            std::cout << std::endl;
        }
    }

    void draw() {
        for (int row = 0; row < num_rows; row++) {
            for (int col = 0; col < num_cols; col++) {
                int cell_value = grid[row][col];
                DrawRectangle(
                        col*cell_size+11,
                        row*cell_size+11,
                        cell_size-1, 
                        cell_size-1, 
                        colors[cell_value]);
            }
        }
    }

    bool is_cell_outside(int row, int col) {
        if (row >= 0 && row < num_rows && col >= 0 && col < num_cols) return false;
        return true;
    }

    bool is_cell_empty(int row, int col) {
        if (grid[row][col] == 0) return true;
        return false;
    }

    int clear_full_rows() {
        int completed = 0;
        for (int row = num_rows - 1; row >= 0; row--) {
            if (is_row_full(row)) {
                clear_row(row);
                completed++;
            } else if (completed > 0) {
                move_row_down(row, completed);
            }
        } 
        return completed;
    }
private:
    int num_rows;
    int num_cols;
    int cell_size;
    std::vector<Color> colors;

    bool is_row_full(int row) {
        for (int col = 0; col < num_cols; col++) {
            if (grid[row][col] == 0) return false;
        }
        return true;
    }

    void clear_row(int row) {
        for (int col = 0; col < num_cols; col++) {
            grid[row][col] = 0;
        }
    }

    void move_row_down(int row, int n) {
        for (int col = 0; col < num_cols; col++) {
            grid[row + n][col] = grid[row][col];
            grid[row][col] = 0;
        }
    }
};

struct Position {
    Position(int row, int col) {
        this->row = row;
        this->col = col;
    }
    int row;
    int col;
};

struct Block {
    int id;
    std::map<int, std::vector<Position>> cells;

    Block() {
        cell_size = 30;
        rotation_state = 0;
        colors = {dark_grey, green, red, orange, yellow, purple, cyan, blue};
        row_offset = 0;
        col_offset = 0;
    }

    void draw(int offset_x, int offset_y) {
        std::vector<Position> tiles = get_cell_positions();
        for (Position item : tiles) {
            DrawRectangle(
                    item.col*cell_size+offset_x,
                    item.row*cell_size+offset_y,
                    cell_size-1, 
                    cell_size-1, 
                    colors[id]);
        }
    }

    void move(int rows, int cols) {
        row_offset += rows;
        col_offset += cols;
    }

    std::vector<Position> get_cell_positions() {
        std::vector<Position> tiles = cells[rotation_state];
        std::vector<Position> moved_tiles;
        for (Position item : tiles) {
            Position new_pos = Position(item.row + row_offset, item.col + col_offset);
            moved_tiles.push_back(new_pos);
        }
        return moved_tiles;
    }

    void rotate() {
        rotation_state = (rotation_state + 1) % cells.size();
    }

    void undo_rotate() {
        rotation_state--;
        if (rotation_state == -1) rotation_state = cells.size() - 1;
    }
private:
    int cell_size;
    int rotation_state;
    int row_offset;
    int col_offset;
    std::vector<Color> colors;
};

struct LBlock : public Block {
    LBlock() {
        id = 1;
        cells[0] = {Position(0, 2), Position(1, 0), Position(1, 1), Position(1, 2)};
        cells[1] = {Position(0, 1), Position(1, 1), Position(2, 1), Position(2, 2)};
        cells[2] = {Position(1, 0), Position(1, 1), Position(1, 2), Position(2, 0)};
        cells[3] = {Position(0, 1), Position(0, 2), Position(1, 1), Position(2, 1)};
        move(0, 3);
    }
};

struct JBlock : public Block {
    JBlock() {
        id = 2;
        cells[0] = {Position(0, 0), Position(1, 0), Position(1, 1), Position(1, 2)};
        cells[1] = {Position(0, 1), Position(0, 2), Position(1, 1), Position(2, 1)};
        cells[2] = {Position(1, 0), Position(1, 1), Position(1, 2), Position(2, 2)};
        cells[3] = {Position(0, 1), Position(1, 1), Position(2, 0), Position(2, 1)};
        move(0, 3);
    }
};

struct IBlock : public Block {
    IBlock() {
        id = 3;
        cells[0] = {Position(1, 0), Position(1, 1), Position(1, 2), Position(1, 3)};
        cells[1] = {Position(0, 2), Position(1, 2), Position(2, 2), Position(3, 2)};
        cells[2] = {Position(2, 0), Position(2, 1), Position(2, 2), Position(2, 3)};
        cells[3] = {Position(0, 1), Position(1, 1), Position(2, 1), Position(3, 1)};
        move(-1, 3);
    }
};

struct OBlock : public Block {
    OBlock() {
        id = 4;
        cells[0] = {Position(0, 0), Position(0, 1), Position(1, 0), Position(1, 1)};
        cells[1] = {Position(0, 0), Position(0, 1), Position(1, 0), Position(1, 1)};
        cells[2] = {Position(0, 0), Position(0, 1), Position(1, 0), Position(1, 1)};
        cells[3] = {Position(0, 0), Position(0, 1), Position(1, 0), Position(1, 1)};
        move(0, 4);
    }
};

struct SBlock : public Block {
    SBlock() {
        id = 5;
        cells[0] = {Position(0, 1), Position(0, 2), Position(1, 0), Position(1, 1)};
        cells[1] = {Position(0, 1), Position(1, 1), Position(1, 2), Position(2, 2)};
        cells[2] = {Position(1, 1), Position(1, 2), Position(2, 0), Position(2, 1)};
        cells[3] = {Position(0, 0), Position(1, 0), Position(1, 1), Position(2, 1)};
        move(0, 3);
    }
};

struct TBlock : public Block {
    TBlock() {
        id = 6;
        cells[0] = {Position(0, 1), Position(1, 0), Position(1, 1), Position(1, 2)};
        cells[1] = {Position(0, 1), Position(1, 1), Position(1, 2), Position(2, 1)};
        cells[2] = {Position(1, 0), Position(1, 1), Position(1, 2), Position(2, 1)};
        cells[3] = {Position(0, 1), Position(1, 0), Position(1, 1), Position(2, 1)};
        move(0, 3);
    }
};

struct ZBlock : public Block {
    ZBlock() {
        id = 7;
        cells[0] = {Position(0, 0), Position(0, 1), Position(1, 1), Position(1, 2)};
        cells[1] = {Position(0, 2), Position(1, 1), Position(1, 2), Position(2, 1)};
        cells[2] = {Position(1, 0), Position(1, 1), Position(2, 1), Position(2, 2)};
        cells[3] = {Position(0, 1), Position(1, 0), Position(1, 1), Position(2, 0)};
        move(0, 3);
    }
};

struct Game {
    bool running;
    int score;
    Music music;

    Game() {
        score = 0;
        running = true;
        grid = Grid();
        blocks = get_all_blocks();
        current_block = get_random_block();
        next_block = get_random_block();
        InitAudioDevice();
        music = LoadMusicStream("assets/music.mp3");
        PlayMusicStream(music);
        rotate_sound = LoadSound("assets/rotate.mp3");
        clear_sound = LoadSound("assets/clear.mp3");
    }

    void update_score(int lines_cleared, int move_down_points) {
        switch (lines_cleared) {
        case 1:
            score += 100;
            break;
        case 2:
            score += 300;
            break;
        case 3:
            score += 500;
            break;
        case 4:
            score += 700;
            break;
        default:
            break;
        }
        score += move_down_points;
    }

    Block get_random_block() {
        if (blocks.empty()) {
            blocks = get_all_blocks();
        }
        int idx = rand() % blocks.size();
        Block block = blocks[idx];
        blocks.erase(blocks.begin() + idx);
        return block;
    }

    std::vector<Block> get_all_blocks() {
        return {IBlock(), JBlock(), ZBlock(), TBlock(), OBlock(), SBlock(), LBlock()};
    } 

    void draw() {
        grid.draw();
        current_block.draw(11, 11);
        switch (next_block.id) {
        case 3: 
            next_block.draw(255, 290);
            break;
        case 4:
            next_block.draw(255, 280);
            break;
        default:
            next_block.draw(270, 270);
            break;
        }
    }

    void handle_input() {
        int key = GetKeyPressed();
        if (!running && key != 0) {
            reset();
            running = true;
        }

        switch (key) {
        case KEY_LEFT:
            move_block_left();
            break;
        case KEY_RIGHT:
            move_block_right();
            break;
        case KEY_DOWN:
            move_block_down();
            update_score(0, 1);
            break;
        case KEY_UP:
            rotate_block();
            break;
        default:
            break;
        }
    }

    void move_block_left() {
        if (!running) return;
        current_block.move(0, -1);
        if (is_block_outside() || !block_fits()) {
            current_block.move(0, 1);
        }
    }

    void move_block_right() {
        if (!running) return;
        current_block.move(0, 1);
        if (is_block_outside() || !block_fits()) {
            current_block.move(0, -1);
        }
    }

    void move_block_down() {
        if (!running) return;
        current_block.move(1, 0);
        if (is_block_outside() || !block_fits()) {
            current_block.move(-1, 0);
            lock_block();
        }
    }

    bool is_block_outside() {
        std::vector<Position> tiles = current_block.get_cell_positions();
        for (Position item : tiles) {
            if (grid.is_cell_outside(item.row, item.col)) {
                return true;
            }
        }
        return false;
    }

    void rotate_block() {
        if (!running) return;
        current_block.rotate();
        if (is_block_outside() || !block_fits()) {
            current_block.undo_rotate();
        } else {
            PlaySound(rotate_sound);
        }
    }

    void lock_block() {
        std::vector<Position> tiles = current_block.get_cell_positions();
        for (Position item : tiles) {
            grid.grid[item.row][item.col] = current_block.id;
        }
        current_block = next_block;
        if (!block_fits()) {
            running = false;
            return;
        }
        next_block = get_random_block();
        int cleared_rows = grid.clear_full_rows();
        if (cleared_rows > 0) {
            PlaySound(clear_sound);
            update_score(cleared_rows, 0);
        }
    }

    bool block_fits() {
        std::vector<Position> tiles = current_block.get_cell_positions();
        for (Position item : tiles) {
            if (!grid.is_cell_empty(item.row, item.col)) return false;
        }
        return true;
    }

    void reset() {
        grid.reset();
        blocks = get_all_blocks(); 
        current_block = get_random_block();
        next_block = get_random_block();
        score = 0;
    }
private:
    Grid grid;
    std::vector<Block> blocks;
    Block current_block;
    Block next_block;
    Sound rotate_sound;
    Sound clear_sound;
};

static double last_update_time = 0;

bool event_triggered(double internal)
{
    double current_time = GetTime();
    if (current_time - last_update_time >= internal) {
        last_update_time = current_time;
        return true;
    }
    return false;
}

int main() {
    srand((int)time(0));

    InitWindow(500, 620, "My Tetris Game");
    SetTargetFPS(60);

    Font font = LoadFontEx("assets/monogram.ttf", 64, NULL, 0);

    Game game = Game();

    while (!WindowShouldClose()) {
        // Updating
        UpdateMusicStream(game.music);
        game.handle_input();
        if (event_triggered(0.2)) game.move_block_down();

        // Drawing
        BeginDrawing();
        ClearBackground(dark_blue);

        DrawTextEx(font, "Score", {355, 15}, 38, 2, WHITE);
        DrawTextEx(font, "Next", {365, 175}, 38, 2, WHITE);
        if (!game.running) {
            DrawTextEx(font, "GAME OVER", {320, 450}, 38, 2, WHITE);
        }

        DrawRectangleRounded({320, 55, 170, 60}, 0.3, 6, light_blue);

        char score_text[10];
        sprintf(score_text, "%d", game.score);
        Vector2 text_size = MeasureTextEx(font, score_text, 38, 2);
        DrawTextEx(font, score_text, {320 + (170 - text_size.x) / 2, 65}, 38, 2, WHITE);

        DrawRectangleRounded({320, 215, 170, 180}, 0.3, 6, light_blue);
        game.draw();
        EndDrawing();
    }

    CloseWindow();

    return 0;
}
