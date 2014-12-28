note
	description: "Represents a current blockus game status."
	author: "Mohamed Kamal  -  Sherif Khaled"
	date: "$Date: 06-11-2013$"
	revision: "$Revision: 1.0$"

class
	G09_GAME

create
	make,
	make_game

feature{NONE} -- Initlization
	make()
	--Depreacated
	do

	end

	make_game(turn_time_m:INTEGER; players_m:ARRAY[TUPLE[name:STRING; ai_active:BOOLEAN; ai_level:INTEGER]])
	-- creates a game model of blockus
	do
		create current_player_changed_listeners.make
		create game_started_listeners.make

		create players.make_filled (Void, {G09_PLAYER_COLORS}.blue, {G09_PLAYER_COLORS}.green)

		turn_time := turn_time_m;
		create the_board.make
		create_and_add_player(players_m.item ({G09_PLAYER_COLORS}.blue-1).name, {G09_PLAYER_COLORS}.blue)
		create_and_add_player(players_m.item ({G09_PLAYER_COLORS}.red-1).name, {G09_PLAYER_COLORS}.red)
		create_and_add_player(players_m.item ({G09_PLAYER_COLORS}.yellow-1).name, {G09_PLAYER_COLORS}.yellow)
		create_and_add_player(players_m.item ({G09_PLAYER_COLORS}.green-1).name, {G09_PLAYER_COLORS}.green)
	end

	create_and_add_player(name:STRING; id:INTEGER)
	local
		player:G09_PLAYER
	do
		create player.make_with_color(id, name)
		players.put (player, id)
	end

feature -- Open API
	get_board():G09_BOARD
	-- get the game board of the game
	-- GUI:you should handle events in the board to reflect updates of the game.
	do
		Result:=the_board;
	end

	-- get the last turn time set of the game by the master.
	get_turn_time():INTEGER
	do
		Result:=turn_time;
	end

	get_player(color_id:INTEGER):G09_PLAYER
	-- return the player using it's color ID
	do
		result:=players.item (color_id)
	end

	-- get the current player.
	get_current_player():G09_PLAYER
	-- returns the player color ID
	do
		result := players.item(curennt_color_id)
	end

	get_prev_player_color():INTEGER
	do
		result := curennt_color_id - 1
		if result < {G09_PLAYER_COLORS}.blue then
			result := {G09_PLAYER_COLORS}.green
		end
	end

	get_next_player_color():INTEGER
	do
		result := (curennt_color_id+1)
		if result > {G09_PLAYER_COLORS}.green then
			result := {G09_PLAYER_COLORS}.blue
		end
	end

	get_winner_player_color():INTEGER
  	-- announce the winner player
  	local
  		index:INTEGER
  		max:INTEGER
  		i:INTEGER
  	do
  		max := players.at (0).get_score();

  		from i:=1 until	i > 4
  		loop
  			if(players.at (i).get_score() > max) then
  				max := players.at (i).get_score();
  				index := i;
  			end
  		end

  		Result := i;
  	end

feature{ANY}

	curennt_color_id:INTEGER;

	start_game()
  	-- start the game and raise the event
  	do
  		raise_game_started()
  		set_current_player ({G09_PLAYER_COLORS}.blue)
  	end

feature{G09_LOGIC} -- update game status

	set_current_player(new_current_player_color:INTEGER)
	--handeles the situation when a player is disconnected and will be replaced with an AI player
	do
		curennt_color_id := new_current_player_color;
		raise_current_player_changed (new_current_player_color)
	end

	move_turn_to_next_player()
	do
		set_current_player (get_next_player_color)
	end

	apply_game_move(piece:G09_PIECE; player_color:INTEGER)
	-- apply game move directly without checking
	local
		new_score:INTEGER
	do
		if piece /= void then
	     	new_score := get_board.can_add_game_piece (piece, player_color)
			get_board.add_game_piece (piece, player_color)
			get_player (player_color).update_score(new_score)
			get_player (player_color).remove_piece (piece.get_id)
		end

		move_turn_to_next_player
	end

	validate_and_apply_game_move(piece:G09_PIECE; player_color:INTEGER) : BOOLEAN
	-- apply the piece move in the board and returns true if the move is correct
	-- returns false if the move is incorrect
    local
    	new_score:INTEGER
	do
		result:=true --assume that the move is correct

		if piece = void then
			--player skipped his turn or timeout
			move_turn_to_next_player
		else
	     	new_score := get_board.can_add_game_piece (piece, player_color)
			get_board.add_game_piece (piece, player_color)

			if new_score = -1 then
				-- move is incorrect, return false
				result:=false
			else
				-- move is correct like assumed, apply it to the game
				get_board.add_game_piece(piece, player_color)
				get_player (player_color).update_score(new_score)
				get_player (player_color).remove_piece (piece.get_id)

				print("Logic: Moving Turn%N")
				move_turn_to_next_player
				print("%NCurrent player after moving turn is %N")
				print(get_current_player)
				print("%N")
			end
		end
	end

	is_pieces_finished():BOOLEAN
	  local
		i:INTEGER;
	  do
	   Result:=false;
	  from i:=0 until i<4
	  loop
		if players.at (i).get_pieces_count() = 0 then
			Result:=true;
		end
	  end
	end

	is_game_blocked():BOOLEAN
	-- check if any player can make a move
	do

	end

feature{NONE} -- raise events features
	raise_game_started()
	do
		from game_started_listeners.start until game_started_listeners.after
		loop
			game_started_listeners.item.notify_game_started()
			game_started_listeners.forth
		end
	end

	raise_current_player_changed(new_player_id:INTEGER)
	do
		from current_player_changed_listeners.start until current_player_changed_listeners.exhausted
		loop
			current_player_changed_listeners.item.notify_current_player_changed(new_player_id)
			current_player_changed_listeners.forth
		end
	end

feature -- Events
	game_started_listeners:LINKED_LIST[G09_GAME_STARTED_LISTENER]
	current_player_changed_listeners:LINKED_LIST[G09_CURRENT_PLAYER_CHANGED_LISTENER]

feature{NONE} -- internal representation
	the_board:G09_BOARD;

feature{G09_TEST_GAME} -- internal representation
	players: ARRAY[G09_PLAYER]
	turn_time:INTEGER;
end
