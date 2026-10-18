function MineSweeper2_GUI()
    n = 9; % Define board size
    num_mines = 11; % Define number of mines
    
    fh = figure('Position', [400, 400, 250, 300]);
    % Adjust appearance
    set(fh, 'Resize', 'off');
    set(fh, 'MenuBar', 'none');
    set(fh, 'NumberTitle', 'off');
    set(fh, 'Name', 'MATLAB MineSweeper');
    % Generate mine locations
    mine_locations = randperm(n^2, num_mines);
    is_mine = false(1, n^2);
    is_mine(mine_locations) = true;
    % Initialize the game board
    game_board = cell(1, n^2);
    for i = 1:n^2
        if is_mine(i)
            game_board{i} = 'M';
        else
            game_board{i} = '';
        end
    end

    non_bomb_cells = n^2 - num_mines;
    opened_non_bomb_cells = 0;
    game_won_flag = false;

    % Create buttons and text boxes
    buttons = cell(1, n^2);
    text_boxes = cell(1, n^2);
    c = 1;
    for xpos = 1:n
        for ypos = 1:n
            buttons{c} = uicontrol('Style', 'pushbutton', 'Units', 'normalized');
            set(buttons{c}, 'Position', [0.11 * (xpos - 1), 0.11 * (ypos - 1), 0.1, 0.1]);
            set(buttons{c}, 'Callback', {@left_click_callback, c});
            set(buttons{c}, 'ButtonDownFcn', {@right_click_callback, c});
            
            text_boxes{c} = uicontrol('Style', 'text', 'Units', 'normalized');
            set(text_boxes{c}, 'Position', [0.11 * (xpos - 1), 0.11 * (ypos - 1), 0.1, 0.1]);
            set(text_boxes{c}, 'Visible', 'off');
            
            c = c + 1;
        end
    end

    function left_click_callback(~, ~, idx)
        if game_won_flag
            return;
        end

        mouse_click = get(gcf, 'SelectionType');
        if strcmp(mouse_click, 'normal') % Left click
            if is_mine(idx)
                set(buttons{idx}, 'String', 'M');
                game_over();
            else
                set(buttons{idx}, 'Visible', 'off');
                set(text_boxes{idx}, 'String', num2str(count_adjacent_mines(idx)));
                set(text_boxes{idx}, 'Visible', 'on');
                opened_non_bomb_cells = opened_non_bomb_cells + 1;
                
                if opened_non_bomb_cells == non_bomb_cells
                    game_won();
                end
            end
        end
    end

    function right_click_callback(~, ~, idx)
        mouse_click = get(gcf, 'SelectionType');
        if strcmp(mouse_click, 'alt') || strcmp(mouse_click, 'extend') % Right click
            if strcmp(get(buttons{idx}, 'String'), 'F') % Toggle flag
                set(buttons{idx}, 'String', '');
            else
                set(buttons{idx}, 'String', 'F');
            end
        end
    end

    function count = count_adjacent_mines(idx)
        count = 0;
        [x, y] = ind2sub([n, n], idx);

        % Check for mines in all adjacent cells (including diagonals)

        neighbors = [x-2, y-2; x-2, y-1; x-2, y; x-2, y+1; x-2, y+2;
                     x-1, y-2; x-1, y-1; x-1, y; x-1, y+1; x-1, y+2;
                     x  , y-2; x  , y-1;         x  , y+1; x  , y+2;
                     x+1, y-2; x+1, y-1; x+1, y; x+1, y+1; x+1, y+2;
                     x+2, y-2; x+2, y-1; x+2, y; x+2, y+1; x+2, y+2];

        for i = 1:size(neighbors, 1)
            if neighbors(i, 1) >= 1 && neighbors(i, 1) <= n && neighbors(i, 2) >= 1 && neighbors(i, 2) <= n
                neighbor_idx = sub2ind([n, n], neighbors(i, 1), neighbors(i, 2));
                if is_mine(neighbor_idx)
                    count = count + 1;
                end
            end
        end
    end

    function game_over()
        for i = 1:n^2
            if is_mine(i)
                set(buttons{i}, 'String', 'M');
            end
        end
        msgbox('Game Over! You hit a mine.', 'Game Over', 'warn');
    end

    function game_won()
        game_won_flag = true;
        for i = 1:n^2
            if is_mine(i)
                set(buttons{i}, 'String', 'M'); % Reveal bomb locations
            else
                set(buttons{i}, 'Visible', 'off'); 
            end
        end
        msgbox('Congratulations! You cleared the board.', 'Victory!', 'help');
    end

end % of MineSweeper2_GUI()
