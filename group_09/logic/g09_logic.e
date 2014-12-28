note
	description: "A class representing the LOGIC component of a blockus game."
	author: "Mohamed Kamal"
	date: "1.12.2013"
	revision: "1.1"

class
	G09_LOGIC

inherit
	 G09_MOVE_SUBMITTER_INTERFACE
	 G09_LOGIC_GAME_EVENTS_LISTENER

create
	make_client,
	make_host

feature{NONE} -- Initialization
	make_client(this_computer_color:INTEGER; turn_time_m:INTEGER; players_m:ARRAY[TUPLE[name:STRING; ai_active:BOOLEAN; ai_level:INTEGER]];
				net_m:G09_NETWORK; gui_m:G09_MAIN_WINDOW)
	-- create a logic component on client computer
	do

		create game.make_game(turn_time_m, players_m)
		create this_computer_player.make_controller_with_gui(this_computer_color, game, current)
		net := net_m
		gui := gui_m

		this_computer_player.activate()

		-- subscribe to net MAKE_MOVE
		-- subscribe to net CLIENT_NAME_CHANGED
		net.set_logic_listener (Current)
	end

	make_host(turn_time:INTEGER; players_m:ARRAY[TUPLE[name:STRING; ai_active:BOOLEAN; ai_level:INTEGER]];
			  net_m:G09_NETWORK;gui_m:G09_MAIN_WINDOW)
	-- create a logic component on host computer (is a client but also has the AI players)
	-- by default, the human player takes the first color which is blue, and ai players (if any) takes the rest of the colors
	do
		make_client({G09_PLAYER_COLORS}.blue, turn_time, players_m, net_m, gui_m)

		create ai_players.make_filled (Void, {G09_PLAYER_COLORS}.blue, {G09_PLAYER_COLORS}.green)
		create_ai_player_to_players ({G09_PLAYER_COLORS}.red, players_m.item ({G09_PLAYER_COLORS}.red-1).ai_level)
		create_ai_player_to_players ({G09_PLAYER_COLORS}.yellow, players_m.item ({G09_PLAYER_COLORS}.yellow-1).ai_level)
		create_ai_player_to_players ({G09_PLAYER_COLORS}.green, players_m.item ({G09_PLAYER_COLORS}.green-1).ai_level)

		if net.is_host then
			change_AI_active ({G09_PLAYER_COLORS}.yellow, players_m.item ({G09_PLAYER_COLORS}.yellow-1).ai_active)
			change_AI_active ({G09_PLAYER_COLORS}.green,  players_m.item ({G09_PLAYER_COLORS}.green-1).ai_active)
			change_AI_active ({G09_PLAYER_COLORS}.red,  players_m.item ({G09_PLAYER_COLORS}.red-1).ai_active)
		end

		-- subscribe to net CLIENT_DISCONNECTED
	end

feature -- Access
	get_game():G09_GAME
	-- get the object representing the game.
	do
		result := game
	end

	get_this_computer_controller():G09_THIS_COMPUTER_PLAYER_CONTROLLER
	-- get the gui player controller representing the current computer human player
	do
		result := this_computer_player
	end

feature {NONE} -- host only
	host_validate_and_broadcast_move(update_obj:TUPLE[piece:G09_PIECE; player_color:INTEGER])
	do
		if game.validate_and_apply_game_move(update_obj.piece, update_obj.player_color) then
	     	net.send_game_update({G09_GAME_UPDATES_CONSTANTS}.player_make_move, update_obj)
		else
	     	-- send update to the clients to indicate a wrong move
	     	--net.send_game_update ({G09_GAME_UPDATES_CONSTANTS}.host_move_validate_fail, update_obj.player_color)
		end
	end

feature{NONE}  -- getting players controllers move submittions
	submit_move(piece:G09_PIECE; player_color:INTEGER)
     -- Respond to play moves from players
     local
     	update_obj:TUPLE[piece:G09_PIECE; player_color:INTEGER]
     do
     	print("player ")
     	print(player_color)
     	print(" is submitting move with piece: ")
     	print(piece)
     	print("%N")

     	create update_obj.default_create
     	update_obj.piece := piece
     	update_obj.player_color := player_color

--     	remove_net_echo_msg:=true
--     	if net.is_host then
--     		-- Host: check if move is correct, apply it on my board and send it to all clients to apply it
--     		host_validate_and_broadcast_move(update_obj)
--	     else
	     	-- Client: send it to the host to check if it is correct
	     	net.send_game_update({G09_GAME_UPDATES_CONSTANTS}.player_make_move, update_obj)
--     	end
		if net.is_host and game.is_game_blocked then
			net.send_game_update ({G09_GAME_UPDATES_CONSTANTS}.game_end, void)
		end
     end
--remove_net_echo_msg:BOOLEAN
feature{NONE}  -- listening to NET events
	notify_game_update(update_id: INTEGER; object: ANY)
	-- Respond to NET move received updates
	do
--		if remove_net_echo_msg then
--			remove_net_echo_msg := false
--		else
			if update_id = {G09_GAME_UPDATES_CONSTANTS}.player_make_move then
--				-- casting the update object to game_move update object
				if attached {TUPLE[piece:G09_PIECE; player_color:INTEGER]} object as update_obj then
--			     	if net.is_host then
--			     		--updates recived from clients, validate them, apply them on my board (host) and send them to all clients
--			     		host_validate_and_broadcast_move(update_obj)
--				     else
--				     	--updates recived from host, apply them directly
				     	game.apply_game_move (update_obj.piece, update_obj.player_color)
--			     	end
				end
--			elseif update_id = {G09_GAME_UPDATES_CONSTANTS}.host_move_validate_fail then
--				if attached {INTEGER} object as player_color then
--					if player_color = get_this_computer_controller.get_color_id then
--						get_this_computer_controller.alert_last_move_failed()
--					end
--				end
--			end
			elseif update_id = {G09_GAME_UPDATES_CONSTANTS}.game_end then
				gui.game_over
		end
	end

	notify_client_name_changed(id: INTEGER; new_name: STRING)
	-- Respond to net player name changed updates and apply it to GAME
	do
		game.get_player(id).set_name(new_name)
	end

	notify_client_disconnected(id: INTEGER)
	do
		if net.is_host then
			get_ai_player(id).activate
		end
	end

feature{NONE} -- private features for internal use

	create_ai_player_to_players(color:INTEGER; diffculty:INTEGER)
	local
		new_ai_player:G09_AI_PLAYER_CONTROLLER
	do
		create new_ai_player.make_controller_with_AI(color, game, current, diffculty)
		ai_players.put(new_ai_player, color)
	end

	get_ai_player(color:INTEGER):G09_AI_PLAYER_CONTROLLER
	do
		result:=ai_players[color]
	end

	change_ai_active(ai_color:INTEGER; active:BOOLEAN)
	do
		if active then
			ai_players[ai_color].activate
		else
			ai_players[ai_color].deactivate
		end
	end

feature{NONE} -- Internal representation
	ai_players:ARRAY[G09_AI_PLAYER_CONTROLLER]
	this_computer_player:G09_THIS_COMPUTER_PLAYER_CONTROLLER
	game:G09_GAME
	net:G09_NETWORK
	gui:G09_MAIN_WINDOW
end
