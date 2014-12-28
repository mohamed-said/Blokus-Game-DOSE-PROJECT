note
description: "API for Artificial Intelligence component of the Blokus game."
author: "Bruno, Gasparrini, Gaumet, Marchisio, Ocejo."
date: "10/31/2013"
revision: "0.1"

class
    G09_AI

create
    make_ai_with_game

feature{ANY}
    --Constructor of the class with difficulty level easy.
    make_ai_with_game(game: G09_GAME)
    do
        my_game:= game
        best_play_count:= 21
        my_board:= game.get_board
    end

feature{ANY}
    --Returns true if some player has movements to play.
    --Note to guys in denmark, this might be moved to the logic, so we didn't add contracts
    remaning_movements_in_board: BOOLEAN
    do
        if (player_has_movements(my_game.get_board, my_game.get_player({G09_PLAYER_COLORS}.blue)) or
            player_has_movements(my_game.get_board, my_game.get_player({G09_PLAYER_COLORS}.yellow)) or
            player_has_movements(my_game.get_board, my_game.get_player({G09_PLAYER_COLORS}.red)) or
            player_has_movements(my_game.get_board, my_game.get_player({G09_PLAYER_COLORS}.green)))
        then
            Result := True
        else
            Result := False
        end
    end

feature{ANY}
    --Return a piece and the position where it has to go
    best_play(ai_level: INTEGER): G09_PIECE
    require
        references: my_game.get_current_player/=void and my_board/=void
        difficulty: ai_level>=0 and ai_level<=2
    do
        if best_play_count > 17 then
            Result:= opening_ai(my_game.get_current_player, ai_level)
        else
            if ai_level = 0 then
                Result := best_play_easy(my_game.get_current_player)
            end
            if ai_level = 1 then
                Result := best_play_medium(my_game.get_current_player)
            end
            if ai_level = 2 then
                Result := best_play_hard(my_game.get_current_player)
            end
        end
        ensure
            --my_game.get_current_player.get_pieces_count = old my_game.get_current_player.get_pieces_count -1
    end

feature{ANY}
    --Returns True iff the game has finished (some player hasn't got anymore pieces or any player can be place any of their current pieces)
    is_game_finished(game: G09_GAME) : BOOLEAN
    require
        correct_reference: game /= Void
    local
        finished : BOOLEAN
    do
        finished := False
        -- if some player players had placed all his pieces
        if (game.get_player({G09_PLAYER_COLORS}.blue).get_pieces_count = 0 or
        game.get_player({G09_PLAYER_COLORS}.yellow).get_pieces_count = 0 or
        game.get_player({G09_PLAYER_COLORS}.red).get_pieces_count = 0 or
        game.get_player({G09_PLAYER_COLORS}.green).get_pieces_count = 0) then
            finished := True
        end
        if (not finished) then
            -- if any player doesn't have any piece which fits in any available corner (game blocked)
            if (not (player_has_movements(game.get_board, game.get_player({G09_PLAYER_COLORS}.blue)) or
            player_has_movements(game.get_board, game.get_player({G09_PLAYER_COLORS}.yellow)) or
            player_has_movements(game.get_board, game.get_player({G09_PLAYER_COLORS}.red)) or
            player_has_movements(game.get_board, game.get_player({G09_PLAYER_COLORS}.green)))) then
                finished := True
            end
        end
        Result := finished
    end

feature{ANY}
    -- Return True iff "player" has any valid movement remaining
    player_has_movements(board: G09_BOARD; player: G09_PLAYER) : BOOLEAN
    require
        correct_references: board /= Void and player /= Void
    local
        i, piece_index : INTEGER_32
        movement_found : BOOLEAN
        corners : LINKED_LIST[G09_POINT]
        aux_piece : G09_PIECE
    do
        corners := available_corners(player)
        movement_found := False
        from
            piece_index := 0
        until
            piece_index >= player.get_pieces_count or movement_found
        loop
            from
                i := 0
            until
                i >= corners.count or movement_found
            loop
            	aux_piece := player.get_piece(piece_index)
            	aux_piece.set_board_position(corners.at(i))
                if (board.can_add_game_piece(aux_piece,player.get_color_id) /= -1) then
                    movement_found := True
                else
                	aux_piece.rotate_clockwise
                	if (board.can_add_game_piece(aux_piece,player.get_color_id) /= -1) then
                    	movement_found := True
					else
						aux_piece.rotate_clockwise
						if (board.can_add_game_piece(aux_piece,player.get_color_id) /= -1) then
							movement_found := True
						else
							aux_piece.rotate_clockwise
							if (board.can_add_game_piece(aux_piece,player.get_color_id) /= -1) then
                    			movement_found := True
							end
						end
					end
                end
                if movement_found
                then
                	board.erase (corners.at(i).get_x, corners.at(i).get_y, player.get_color_id)
                end
                i := i + 1
            end
            piece_index := piece_index + 1
        end
        Result := movement_found
    end

feature {NONE}
    my_board:G09_BOARD --Deprecated (probably).

feature {NONE}
    my_game: G09_GAME

feature {NONE}
    --Returns true iff was able to plays the piece.
    try(piece: G09_PIECE; corner: G09_POINT): BOOLEAN
    do
        if (my_game.get_board.can_add_piece (corner.get_x,corner.get_y,piece,my_game.curennt_color_id) /= -1) then
            -- my_game.get_board.add_piece (corner.get_x,corner.get_y,piece,my_game.get_current_player)
            -- I commented the previous line, because feature can_add_piece has already placed the piece on the corner.
        end
    end

feature {NONE}
    --AI plays with the easy difficulty level.
    best_play_easy(player: G09_PLAYER) : G09_PIECE
    local
        corners: LINKED_LIST[G09_POINT]
        random: G09_RANDOM_NUMBER
        n,p,rotations: INTEGER_32
        flag: BOOLEAN
        corner: G09_POINT
        piece: G09_PIECE
    do
        create random.make
        corners := available_corners (player)
        from
            flag := False
        until
            flag
        loop
            n := random.random_integer (corners.count)
            p := random.random_integer (player.get_pieces_count)
            piece := player.get_piece(p)
            create corner.make_fromxy(corners.at(n).get_x, corners.at(n).get_y)
            piece.set_board_position(corner)
            from
                rotations := 0
            until
                rotations > 3 or flag
            loop
                if (rotations > 0)
                then
                    piece.rotate_clockwise
                end
                if (my_game.get_board.can_add_game_piece(piece, player.get_color_id)) /= -1
                then
                    flag := True
                    my_game.get_board.erase(corner.get_x, corner.get_y, player.get_color_id)
                end
                rotations := rotations + 1
            end
        end
        Result := piece
    end

feature {NONE}
    --AI plays with the medium difficulty level.
    best_play_medium(player: G09_PLAYER) : G09_PIECE
    local
        corners:LINKED_LIST[G09_POINT]
        best_piece, aux_piece:G09_PIECE
        point:G09_POINT
        max_heuristic,current_score,index1,index2: INTEGER
        x, y: INTEGER
        aux_board: G09_BOARD
    do
        corners := available_corners (player)
        max_heuristic := 0
        if corners.count>0 then
            from
                index1 := 1
            until
                index1 > player.get_pieces_count
            loop
                from
                    index2 := 1
                until
                    index2 > corners.count
                loop
                    --aux_board := my_game.get_board.clone_board -- aca deberia clonarse my_game.get_board para probarse todas las piezas en todas las posiciones
                    aux_piece := player.get_piece(index1)
                    aux_piece.set_board_position(corners.at(index2))
                    if my_game.get_board.can_add_game_piece(aux_piece, player.get_color_id) /= -1
                    then
                        -- pero para poder usarlo primero tengo que tener clonado el board
                        current_score := heuristics_piece(my_game.get_board, aux_piece, player.get_color_id)
                        -- aca deberia ser aux_board en lugar de my_game.get_board

                        if current_score > max_heuristic then
                            max_heuristic := current_score
                            best_piece := aux_piece
                        end
                        x := aux_piece.get_board_position.get_x
                        y := aux_piece.get_board_position.get_y
                        my_game.get_board.erase(x, y, player.get_color_id)
                    end
                    index2 := index2 + 1
                end
                index1 := index1 + 1
            end
            --my_game.get_board.add_game_piece(aux_piece,player.get_color_id)
        end
        Result := best_piece
    end


feature {NONE}
    --AI plays with the hard difficulty level.
    best_play_hard(player: G09_PLAYER) : G09_PIECE
    local
        corners:LINKED_LIST[G09_POINT]
        best_piece, aux_piece:G09_PIECE
        point:G09_POINT
        max_heuristic,current_score,index1,index2: INTEGER
        rotations : INTEGER
    do
        corners := available_corners (player)
        max_heuristic := 0
        if corners.count > 0 then
            from
                index1 := 1
            until
                index1 > player.get_pieces_count
            loop
                from
                    index2 := 1
                until
                    index2 > corners.count
                loop
                    aux_piece := player.get_piece(index1)
                    aux_piece.set_board_position(corners.at(index2))
                    from
                        rotations := 0
                    until
                        rotations > 3
                    loop
                        if (rotations > 0)
                        then
                            aux_piece.rotate_clockwise
                        end
                        --aux_board := my_game.get_board.clone_board -- aca deberia clonarse my_game.get_board para probarse todas las piezas en todas las posiciones
                        if my_game.get_board.can_add_game_piece(aux_piece, player.get_color_id) /= -1
                        then
                            current_score := heuristics_piece(my_game.get_board, aux_piece, player.get_color_id)
                            if current_score >= max_heuristic then
                                max_heuristic := current_score
                                best_piece := aux_piece
                            end
                            my_game.get_board.erase(aux_piece.get_board_position.get_x, aux_piece.get_board_position.get_y, player.get_color_id)
                        end
                        rotations := rotations + 1
                    end
                    index2 := index2 + 1
                end
                index1 := index1 + 1
            end
            --my_game.get_board.add_game_piece(aux_piece,player.get_color_id)
        end
        Result := best_piece
    end

feature {NONE}
    -- Returns a linked list of the available corners.
    available_corners(player: G09_PLAYER):LINKED_LIST[G09_POINT]
    local
        count1:INTEGER
        count2:INTEGER
        res:LINKED_LIST[G09_POINT]
        auxpoint:G09_POINT
    do
        create res.make
        from
            count1 := 1
        until
            count1 > 20
        loop
            from
                count2 := 1
            until
                count2 > 20
            loop
                if cell_revision(count1,count2,player.get_color_id) then
                    create auxpoint.make_fromxy (count1, count2)
                    res.sequence_put(auxpoint)
                end
                count2:= count2 + 1
            end
            count1 := count1 + 1
        end
        Result:=res
    end

feature {NONE}
    cell_revision(x:INTEGER; y:INTEGER; color:INTEGER): BOOLEAN
    --NOT FOR USE IN OPENING PLAY BECAUSE IT DOESNT CHECKS FOR CORNERS, ONLY FOR USING AFTER THE OPENING
    local
        flag: BOOLEAN
    do
        flag:=true
    if (my_game.get_board.get_color_at (x, y) = {G09_PLAYER_COLORS}.empty) then
        --check for upper, lower,left and right cells
        if (((x>1) and (my_game.get_board.get_color_at (x-1, y) = color)) or
        ((x<20) and (my_game.get_board.get_color_at (x+1, y) = color)) or
        ((y>1) and (my_game.get_board.get_color_at (x, y-1) = color)) or
        ((y<20) and (my_game.get_board.get_color_at (x, y+1) = color)) ) then
            flag:= false;
        end
        if flag then
            --check upperleft, upperright, downleft, downright
            if (((x>1) and (y>1) and (my_game.get_board.get_color_at (x-1, y-1) = color)) or
            ((x>1) and (y<20) and (my_game.get_board.get_color_at (x-1, y+1) = color)) or
            ((x<20) and (y>1) and (my_game.get_board.get_color_at (x+1, y-1) = color)) or
            ((x<20) and (y<20) and (my_game.get_board.get_color_at (x+1, y+1) = color)) ) then
                flag:=true;
            else
                flag:=false;
            end
        end
        else
            flag:=false
        end
    Result:=flag
    end

feature{NONE}
    -- Features used for doing the valuation of a piece
    block_player_corner_score: INTEGER_32 = 8

feature{NONE}
    block_my_corner_score: INTEGER_32 = -20

feature{NONE}
    free_corners_score: INTEGER_32 = 10

feature{NONE}
    -- Heuristics
    -- Returns the value of how good this movement was in the game's board
    heuristics_piece(board: G09_BOARD; piece: G09_PIECE; player_color: INTEGER_32): INTEGER_32
    require
        correct_references: board /= Void and piece /= Void
        correct_corner: piece.get_board_position.get_x > 0 and piece.get_board_position.get_x < 21 and
                        piece.get_board_position.get_y > 0 and piece.get_board_position.get_y < 21
        is_corner_of_player: board.get_color_at(piece.get_board_position.get_x, piece.get_board_position.get_y) = player_color
    local
        i, pos_x, pos_y, free_corners, score : INTEGER_32
        points : ARRAY[G09_POINT]
    do
        score := 0
        free_corners := 0
        points := piece.get_points
        from -- index for the points of the piece
            i := 1
        until
            i > points.count
        loop
            -- respectives x and y positions of the point in the board
            pos_x := points[i].get_x + piece.get_board_position.get_x
            pos_y := points[i].get_y + piece.get_board_position.get_y
            -- if this point blocks some player's corner
            score := score + get_corner_score(board, pos_x - 1, pos_y - 1, player_color)
            score := score + get_corner_score(board, pos_x - 1, pos_y + 1, player_color)
            score := score + get_corner_score(board, pos_x + 1, pos_y - 1, player_color)
            score := score + get_corner_score(board, pos_x + 1, pos_y + 1, player_color)
            -- if it gives a new corner for the player
            if (cell_revision(pos_x - 1, pos_y - 1, player_color))
            then
               free_corners := free_corners + 1
            end
            -- if it gives a new corner for the player
            if (cell_revision(pos_x - 1, pos_y + 1, player_color))
            then
               free_corners := free_corners + 1
            end
            -- if it gives a new corner for the player
            if (cell_revision(pos_x + 1, pos_y - 1, player_color))
            then
               free_corners := free_corners + 1
            end
            -- if it gives a new corner for the player
            if (cell_revision(pos_x + 1, pos_y + 1, player_color))
            then
               free_corners := free_corners + 1
            end
            i := i + 1
        end -- points
        -- Result has the total score of the piece plus the amount of points it has and the free corners that it gives
        Result := score + points.count + free_corners * free_corners_score
    end

feature{NONE}
    -- Return the how good it is if this (x,y) point isn't an empty corner
    get_corner_score(board: G09_BOARD; x: INTEGER_32; y: INTEGER_32; player_color: INTEGER_32) : INTEGER_32
    require
        correct_reference: board /= Void
        correct_corner: x > 0 and x < 21 and y > 0 and y < 21
    do
        -- if this point blocks some player's corner
        if (board.get_color_at(x, y) /= {G09_PLAYER_COLORS}.empty)
        then
            if (board.get_color_at(x, y) /= player_color)
            then
               Result := block_player_corner_score
            else
               Result := block_my_corner_score
            end
        else
            Result := 0
        end
    end

feature {NONE}
    opening_ai(player: G09_PLAYER; ai_level: INTEGER): G09_PIECE
    local
        aux_piece: G09_PIECE
        aux_point: G09_POINT
	do
        if best_play_count = 21 then
            aux_piece:= player.get_piece(10)
            if player.get_color_id = 2 then--Yellow
                create aux_point.make_fromxy(1, 1)
                aux_piece.rotate_clockwise
            	aux_piece.rotate_clockwise
            end
            if player.get_color_id = 3 then--Red
                aux_piece.rotate_clockwise
                create aux_point.make_fromxy(18, 1)
            end
            if player.get_color_id = 4 then--Green
                create aux_point.make_fromxy(18, 18)
            end
        end
        if best_play_count = 20 then
            aux_piece:= player.get_piece(13)
            if player.get_color_id = 2 then--Yellow
                create aux_point.make_fromxy(3, 3)
            end
            if player.get_color_id = 3 then--Red
                create aux_point.make_fromxy(16, 3)
            end
            if player.get_color_id = 4 then--Green
                create aux_point.make_fromxy(16, 16)
            end
        end
        if best_play_count = 19 then
            aux_piece:= player.get_piece(5)
            if player.get_color_id = 2 then--Yellow
            	aux_piece.rotate_clockwise
            	aux_piece.rotate_clockwise
            	aux_piece.rotate_clockwise
                create aux_point.make_fromxy(5, 5)
            end
            if player.get_color_id = 3 then--Red
            	aux_piece.rotate_anticlockwise
                create aux_point.make_fromxy(14, 5)
            end
            if player.get_color_id = 4 then--Green
            	aux_piece.rotate_clockwise
                create aux_point.make_fromxy(14, 14)
            end
        end
        if best_play_count = 18 then
            if player.get_color_id = 2 then--Yellow
            	create aux_piece.make_with_id (20)
            	aux_piece.rotate_clockwise
                create aux_point.make_fromxy(8, 6)
            end
            if player.get_color_id = 3 then--Red
           		create aux_piece.make_with_id (15)
        		aux_piece.rotate_clockwise
        		aux_piece.rotate_clockwise
                create aux_point.make_fromxy(12, 7)
            end
            if player.get_color_id = 4 then--Green
                create aux_piece.make_with_id (20)
                create aux_point.make_fromxy(12,13)
            end
        end
        best_play_count:= best_play_count - 1
        aux_piece.set_board_position(aux_point)
        Result:= aux_piece
	end

feature {NONE}
	get_succesors_boards(current_board:G09_BOARD; player:G09_PLAYER; available_corner:G09_POINT):LINKED_LIST[G09_BOARD]
	local
		list_aux:LINKED_LIST[G09_BOARD]
		board_aux:G09_BOARD
		count1:INTEGER
		count2:INTEGER
		do
			create list_aux.make
      	    from
           		count1 := 1
        	until
                count1 > player.get_pieces_count
     	    loop
           		from
                	count2 := 1
            	until
                	count2 >10  --aunque aca va la cantidad de rotaciones de la ficha, metodo a ser provisto por el cairo
            	loop
            		--ANALISIS CONDICION DE LA PIEZA
					--current_board.can_add_piece (available_corner.get_x, available_corner.get_y, piece: G09_PIECE, player.get_color_id)
					create board_aux.make
					board_aux:= board_aux.deep_clone(current_board)
					list_aux.sequence_put (board_aux)  --LO AGREGO
                	 count2:= count2 + 1
          		 end
            	count1 := count1 + 1
        end
			Result:=list_aux;
		end

feature{NONE}
	best_play_count: INTEGER
end
