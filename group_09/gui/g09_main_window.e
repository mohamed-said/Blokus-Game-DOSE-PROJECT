note
	description	: "Main window for this application"
	author		: "Mikael Hardø"
	date		: "$Date: 2013/11/1 $"
	revision	: "0.1"

class
	G09_MAIN_WINDOW

inherit
	EV_TITLED_WINDOW
		redefine
			initialize,
			is_in_default_state
		end

	G09_GUI_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy
		end

		G09_GUI_GAME_EVENTS_LISTENER
		undefine
			default_create, copy
		end

		G09_COLOR_OF_SQUARE_CHANGED_LISTENER
		undefine
				default_create, copy
			end

		G09_SCORE_OF_COLOR_CHANGED_LISTENER
		undefine
				default_create, copy
			end

		G09_CURRENT_PLAYER_CHANGED_LISTENER
		undefine
			default_create, copy
		end

		G09_PIECE_REMOVED_LISTENER
		undefine
			default_create, copy
		end

		G09_CAN_PLAY_CHANGED_LISTENER
		undefine
			default_create, copy
		end

create
	make

feature {NONE} -- Initialization

	make(a_main_ui_window: MAIN_WINDOW; network : G09_NETWORK; players : ARRAY[TUPLE[STRING_8, BOOLEAN, INTEGER]]; game_time : INTEGER)
			-- Creation procedure
		do
				-- Store the main_ui object. We want to restore it later on (it's currently minimized).
			main_ui := a_main_ui_window
			l_network := network
			l_game_time := game_time
			l_players := players
			l_network.set_gui_listener(Current)

				-- Create the Blokus window.
			make_with_title (window_title)

--			disable_border
			disable_user_resize
			set_position (get_center_position_x, get_center_position_y)

		end

	get_center_position_x : INTEGER
	do
		result := ((create {EV_SCREEN}).width // 2)-(Window_width//2)
	end

	get_center_position_y : INTEGER
	do
		result := ((create {EV_SCREEN}).height // 2)-(Window_height//2)
	end

	initialize
			-- Build the interface for this window.
		do
			Precursor {EV_TITLED_WINDOW}

			build_main_container
			extend (main_container)

				-- Execute `request_close_window' when the user clicks
				-- on the cross in the title bar.
			close_request_actions.extend (agent request_close_window)

				-- Set the title of the window
			set_title (Window_title)

				-- Set the initial size of the window
			set_size (Window_width, Window_height)
		end

	is_in_default_state: BOOLEAN
			-- Is the window in its default state
			-- (as stated in `initialize')
		do
			Result := true
--			Result := (width = Window_width) and then
--				(height = Window_height) and then
--				(title.is_equal (Window_title))
		end


feature {NONE} -- Implementation, Close event

	request_close_window
			-- The user wants to close the window
		local
			question_dialog: EV_CONFIRMATION_DIALOG
		do
			create question_dialog.make_with_text ("Do you want to close?")
			question_dialog.show_modal_to_window (Current)

			if question_dialog.selected_button.is_equal ((create {EV_DIALOG_CONSTANTS}).ev_ok) then
						-- Restore the main UI which is currently minimized
					if attached main_ui then
						main_ui.restore
						main_ui.remove_reference_to_game_window (Current)
					end
				destroy
			end
		end

feature {NONE} -- Implementation

	main_container: EV_HORIZONTAL_BOX
	play_area, time_bar, splash_end, splash_disconnect: EV_FIXED
	chat_area : G09_CHAT_VIEW
	board_area: G09_BOARD_VIEW
	l_piece: G09_PIECE_VIEW
	l_world: EV_MODEL_WORLD
	l_projector: EV_MODEL_DRAWING_AREA_PROJECTOR
	block_group_area: G09_BLOCK_GROUP
	rotate_but_cw, rotate_but_ccw: G09_BUTTON_PIX
	confirm_button, skip_button : G09_BUTTON_GREEN
	timer: EV_TIMEOUT
	time_label : G09_LABEL_SMALL
	start_time : TIME
	l_network : G09_NETWORK
	is_your_turn : BOOLEAN
	l_players : ARRAY[TUPLE[name: STRING; is_ai: BOOLEAN; ai_level: INTEGER]]
	l_game_time : INTEGER
	listener : G09_MOVE_SUBMITTER_INTERFACE
	area: EV_DRAWING_AREA
	score_area: G09_PLAYER_STATE
	logic_piece : G09_PIECE
	logic : G09_LOGIC

	build_main_container
			-- Create and populate `main_container'.
		require
			main_container_not_yet_created: main_container = Void
		local
			l_bg, board_pixmap: EV_PIXMAP
			board_pic: EV_MODEL_PICTURE
			l_buffer: EV_PIXMAP
		do

			if l_network.is_host then
				create logic.make_host (l_game_time, l_players, l_network, current)
			else
				create logic.make_client (l_network.my_client_id, l_game_time, l_players, l_network, current)
			end
			logic.get_game.current_player_changed_listeners.extend (current)
			logic.get_game.get_board.color_of_square_color_changed.extend (current)
			logic.get_game.get_board.score_of_color_changed.extend (current)
			logic.get_game.get_player (l_network.my_client_id).piece_removed_listeners.extend (current)

			listener := logic.get_this_computer_controller.get_submitter

			create main_container
			create play_area

			create time_bar
			time_bar.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))

			create chat_area.make_with_parent(Current)
			create block_group_area.make_with_color (l_network.my_client_id, Current)
			create time_label.make_with_text_and_width ("", 20)

			play_area.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
			main_container.extend (play_area)

			-- Create the background pixmap
			create l_bg
			create board_pixmap

			board_pixmap.set_with_named_file (file_system.pathname_to_string (img_board))
			l_bg.set_with_named_file (file_system.pathname_to_string (img_background))

			create board_pic.make_with_pixmap (board_pixmap)

			create l_world
			play_area.extend_with_position_and_size (l_bg, 0, 0, 800, 600)
			l_world.extend (board_pic)

			is_your_turn := false

			create board_area.make_with_world(l_world)

			create l_buffer.make_with_size (l_bg.width, l_bg.height)

			-- Create the drawing area and assign a model projector to it
			create area
			create l_projector.make_with_buffer (l_world, l_buffer, area)
			l_projector.draw_figure_picture (board_pic)
			play_area.extend_with_position_and_size (area, 299, 97, 440, 440)
			play_area.extend_with_position_and_size (chat_area, 10, 450, 228, 140)
			play_area.extend_with_position_and_size (block_group_area, 5, 200, 228, 244)

			play_area.extend_with_position_and_size (time_label, 570, 35, 20, 20)
			play_area.extend_with_position_and_size (time_bar, 294, 29, 315, 33)

			create rotate_but_cw.make_with_background("rotate_but_cw.png", true)
			create rotate_but_ccw.make_with_background("rotate_but_ccw.png", true)

			rotate_but_cw.set_inactive
			rotate_but_ccw.set_inactive

			create confirm_button.make_with_text("Confirm")
			create skip_button.make_with_text ("Skip")

			play_area.extend (rotate_but_cw)
			play_area.set_item_position (rotate_but_cw, 190, 160)
			play_area.extend (rotate_but_ccw)
			play_area.set_item_position (rotate_but_ccw, 140, 160)

			play_area.extend (confirm_button)
			play_area.set_item_position (confirm_button, 300, 550)
			play_area.extend (skip_button)
			play_area.set_item_position (skip_button, 660, 550)

			create score_area.make(l_players[0].name, l_players[1].name, l_players[2].name, l_players[3].name)
			play_area.extend_with_position_and_size (score_area, 41, 38, 155, 100)

			rotate_but_cw.set_mouse_down_action (agent rotate_cw)
			rotate_but_ccw.set_mouse_down_action (agent rotate_ccw)

			confirm_button.set_mouse_down_action (agent confirm_move)
			skip_button.set_mouse_down_action (agent skip_move)

			-- setup mouse events for active piece (l_piece) on world
			main_container.pointer_button_release_actions.extend(agent l_piece_on_pointer_button_release_on_world)
			main_container.pointer_motion_actions.extend (agent l_piece_on_pointer_motion_on_world)

			-- setup active piece shader
			create_active_piece_shader

			-- setup splashes
			create_splash_end
			create_splash_disconnect


		ensure
			main_container_created: main_container /= Void
		end

feature{G09_LOGIC} -- exposing this feature to be used by the logic to end the game
	game_over
	do
		update_winner_splash(score_area.get_score_evaluation)
		splash_end_show
		other_players_turn
	end

feature{NONE}
	game_end
	do
		splash_disconnect_show
		other_players_turn
	end

	winner_label,player1_score,player2_score,player3_score,player4_score : G09_LABEL_SMALL

	create_splash_end
	local
		splash_height,splash_width : INTEGER
		splash_header: G09_LABEL_HEADER
		message : G09_LABEL_SMALL
	do
		create splash_end

		splash_height := 430
		splash_width := 236

		splash_end.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
		splash_end.set_minimum_size (splash_width, splash_height)

		play_area.extend (splash_end)
		play_area.set_item_position (splash_end, 2, 1)

		create splash_header.make_with_text_and_type ("GAME OVER", 0)

		splash_end.extend (splash_header)
		splash_end.set_item_position (splash_header, 20, 20)

		create player1_score.make_with_text_and_width ("player1 : 0", 200)
		create player2_score.make_with_text_and_width ("player2 : 0", 200)
		create player3_score.make_with_text_and_width ("player3 : 0", 200)
		create player4_score.make_with_text_and_width ("player4 : 0", 200)

		splash_end.extend (player1_score)
		splash_end.extend (player2_score)
		splash_end.extend (player3_score)
		splash_end.extend (player4_score)

		splash_end.set_item_position (player1_score, 30, 140)
		splash_end.set_item_position (player2_score, 30, 180)
		splash_end.set_item_position (player3_score, 30, 220)
		splash_end.set_item_position (player4_score, 30, 260)

		create message.make_with_text_and_width ("The winner is", 200)
		splash_end.extend (message)
		splash_end.set_item_position (message, 20, 70)

		create winner_label.make_with_text_and_width ("MADS!", 200)
		splash_end.extend (winner_label)
		splash_end.set_item_position (winner_label, 20, 90)

		splash_end_hide

	end

	splash_end_show
	do
		splash_end.show
		splash_disconnect_hide
	end

	splash_end_hide
	do
		splash_end.hide
	end

	update_winner_splash(score_eval :  ARRAY[TUPLE[name: STRING; score: INTEGER]])
	do
		player1_score.set_text (score_eval[3].name + ":" + score_eval[3].score.out)
		player2_score.set_text (score_eval[2].name + ":" + score_eval[2].score.out)
		player3_score.set_text (score_eval[1].name + ":" + score_eval[1].score.out)
		player4_score.set_text (score_eval[0].name + ":" + score_eval[0].score.out)

		winner_label.set_text (score_eval[3].name)
	end

	create_splash_disconnect
	local
		splash_height,splash_width : INTEGER
		splash_header: G09_LABEL_HEADER
		message : G09_LABEL_SMALL
	do
		create splash_disconnect

		splash_height := 430
		splash_width := 236

		splash_disconnect.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
		splash_disconnect.set_minimum_size (splash_width, splash_height)

		play_area.extend (splash_disconnect)
		play_area.set_item_position (splash_disconnect, 2, 1)

		create splash_header.make_with_text_and_type ("GAME ENDED", 0)

		splash_disconnect.extend (splash_header)
		splash_disconnect.set_item_position (splash_header, 20, 20)

		create message.make_with_text_and_width ("A player has left", 200)
		splash_disconnect.extend (message)
		splash_disconnect.set_item_position (message, 20, 70)

		splash_disconnect_hide
	end

	splash_disconnect_show
	do
		splash_disconnect.show
		splash_end_hide
	end

	splash_disconnect_hide
	do
		splash_disconnect.hide
	end

	l_piece_on_pointer_motion_on_world (ax, ay: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
	do
		l_piece.on_pointer_motion_on_world(ax, ay, x_tilt, y_tilt, pressure, a_screen_x, a_screen_y)
		l_projector.project
	end

	l_piece_on_pointer_button_press_on_world (ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
	do
		l_piece.on_pointer_button_press_on_world (ax+area.x_position, ay+area.y_position, button, x_tilt, y_tilt, pressure, a_screen_x, a_screen_y)
		main_container.enable_capture
	end

	l_piece_on_pointer_button_release_on_world (ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
	do
		l_piece.on_pointer_button_release_on_world (ax, ay, button, x_tilt, y_tilt, pressure, a_screen_x, a_screen_y)
		main_container.disable_capture
		l_projector.project
	end

	rotate_cw
	do
		-- temp. until rotate ccw works
		logic_piece.rotate_clockwise
		logic_piece.rotate_clockwise
		logic_piece.rotate_clockwise
		logic_piece.get_board_position.set_x (l_piece.get_x)
		logic_piece.get_board_position.set_y (l_piece.get_y)
		l_piece.update_points(logic_piece.get_points_on_board)

		l_projector.project
	end

	rotate_ccw
	do
		-- temp. until rotate ccw works
		--logic_piece.rotate_anticlockwise
		logic_piece.rotate_clockwise
		logic_piece.get_board_position.set_x (l_piece.get_x)
		logic_piece.get_board_position.set_y (l_piece.get_y)
		l_piece.update_points(logic_piece.get_points_on_board)
		l_projector.project
	end

	confirm_move
	local
		can_add : INTEGER
		l_game : G09_GAME
		l_board : G09_BOARD
		l_point : G09_POINT
	do
		if l_piece /= void then
			if l_world.has (l_piece) then
				create l_point.make_fromxy (l_piece.get_x, l_piece.get_y)
				logic_piece.set_board_position (l_point)

				l_game :=logic.get_game
				l_board := l_game.get_board
				can_add := l_board.can_add_game_piece (logic_piece, l_network.my_client_id)

				if can_add /= -1 then
					l_world.prune (l_piece)
					l_piece := void
					rotate_but_cw.set_inactive
					rotate_but_ccw.set_inactive
					listener.submit_move (logic_piece, l_network.my_client_id)
				else
					notify_can_play_changed(false)
				end
			end
		end
	end

	skip_move
	do
		listener.submit_move (Void, l_network.my_client_id)
		l_world.prune (l_piece)
		l_piece := void
		rotate_but_cw.set_inactive
		rotate_but_ccw.set_inactive
	end

feature {NONE} -- Active piece shader

	active_piece_shader : G09_ACTIVE_PIECE_SHADER
	active_piece_offset_x: INTEGER
	active_piece_offset_y: INTEGER

	create_active_piece_shader
	do
		create active_piece_shader.make

		active_piece_offset_x := block_group_area.x_position
		active_piece_offset_y := block_group_area.y_position

		play_area.extend (active_piece_shader)
		play_area.set_item_position (active_piece_shader, active_piece_offset_x, active_piece_offset_y)

		active_piece_shader.hide

	end

	set_active_piece_position(block:INTEGER)
	local
		l_x,l_y : INTEGER
	do

		l_x := ((block-1) \\ 5) * 47
		l_y := ((block / 5 - 1).ceiling) * 47

		if block = 21  then
			active_piece_shader.set_type (2)
		else
			active_piece_shader.set_type (1)
		end

		active_piece_shader.show
		play_area.set_item_position_and_size(active_piece_shader, active_piece_offset_x + l_x, active_piece_offset_y + l_y, active_piece_shader.get_width, active_piece_shader.height)

	end

	hide_active_piece
	do
		active_piece_shader.hide
	end

feature -- Status setting

	chat_send(message: STRING)
	do
		l_network.send_chat_message (message)
		do_command (message)
	end

	do_command(message: STRING)
	local
		x,y: INTEGER
	do
		if message.starts_with ("state:") then
			l_piece.update_validity ((message.split (':')[2]).to_boolean)
		end

		if message.starts_with ("remove:") then
			block_group_area.remove_block ((message.split (':')[2]).to_integer)
		end

		if message.starts_with ("timer start") then
			start_timer
		end

		if message.starts_with ("game over") then
			game_over
		end

		if message.starts_with ("end game") then
			game_end
		end

		l_projector.project
	end

	start_timer
	do
		create start_time.make_now
		start_time.second_add (l_game_time)
		create timer.make_with_interval (50)
		timer.actions.extend (agent update_clock)
	end

	update_clock
	local
		seconds : REAL_64
		clock : TIME
		red, green: INTEGER_32
	do
		create clock.make_now
		seconds := start_time.fine_seconds - clock.fine_seconds
		if seconds < 0 then
			timer.destroy
			time_label.set_text ("")
			time_bar.set_background_color (create {EV_COLOR} .make_with_8_bit_rgb  (0, 0, 0))
		else
			clock.make_by_fine_seconds (seconds)
			time_label.set_text (clock.formatted_out ("ss"))
			red :=  (254 - seconds * (254 / l_game_time)).floor
			green := (seconds * (254 / l_game_time)).floor
			time_bar.set_background_color (create {EV_COLOR} .make_with_8_bit_rgb  (red, green, 0))
			play_area.set_item_width (time_bar, ((seconds / l_game_time) * 315).ceiling)
		end
	end

	block_selected(block: INTEGER)
	local
		l_x,l_y : INTEGER
	do
		l_x := 176
		l_y := 176
		if l_piece /= void then
			l_x := l_piece.point_x
			l_y := l_piece.point_y
			l_piece.hide
			l_world.prune (l_piece)
			l_piece := void
		end

		create logic_piece.make_with_id (block)
		logic_piece.set_board_position (create {G09_POINT}.make_fromxy (l_x \\ 22, l_y \\ 22))

		-- Add a brick to the world
		create l_piece.make_with_color(l_network.my_client_id, logic_piece.get_points_on_board)
		l_world.extend (l_piece)

		l_piece.set_point_position (l_x, l_y)
		l_projector.project

		l_piece.pointer_button_press_actions.extend(agent l_piece_on_pointer_button_press_on_world)

		set_active_piece_position(block)

		l_piece.set_pointer_style (create {EV_POINTER_STYLE}.make_predefined (15))

		rotate_but_cw.set_active
		rotate_but_ccw.set_active

		if is_your_turn then
			confirm_button.set_active
			skip_button.set_active
		else
			confirm_button.set_inactive
			skip_button.set_inactive
		end
	end

	your_turn
	do
		-- activate the buttons, if you have an active block

		skip_button.set_active
		confirm_button.set_inactive

		if l_piece /= Void then
			if l_world.has (l_piece) then
				confirm_button.set_active
			end
		end

		-- start the timer
		start_timer

		is_your_turn := true
	end

	other_players_turn
	do
		if not confirm_button.is_inactive then
			confirm_button.set_inactive
		end
		if not skip_button.is_inactive then
			skip_button.set_inactive
		end
		if timer /= void and timer.is_initialized then
			timer.destroy
		end

		is_your_turn := false

		time_bar.set_background_color (create {EV_COLOR} .make_with_8_bit_rgb  (0, 0, 0))
		play_area.set_item_width (time_bar, 1)
		time_label.set_text ("")
	end

feature {NONE} -- Implementation / Constants

	main_ui: MAIN_WINDOW
		-- the main ui, i.e. the game selector
		-- we need this reference to bring back (i.e. maximize) the game selector once the user closes this window

	Window_width: INTEGER = 800
			-- Initial width for this window.

	Window_height: INTEGER = 600
			-- Initial height for this window.


-- EVENTS
feature -- Client events (player)

	notify_game_starts
	do
		logic.get_game.start_game
	end

	notify_game_over
	do
		game_over
	end

	notify_client_connected(id: INTEGER; name: STRING)
	do
	end

	notify_client_name_changed(id: INTEGER; new_name: STRING)
  	do
  	end

	notify_client_disconnected(id: INTEGER)
  	do
  		game_end
  	end


feature -- Game settings

	notify_turn_time_changed(seconds: INTEGER)
  	do
  	end

feature -- Chat message

	notify_chat_message_received(client_id: INTEGER; client_name: STRING; message: STRING)
	do
		chat_area.add_new_message(client_name + ": " + message)
	end

feature -- Gameplay

  	notify_color_of_square_changed(X:INTEGER; Y:INTEGER; new_color_id:INTEGER)
  	do
		board_area.set_tile (X, Y, new_color_id)
		l_projector.project
  	end

  	notify_score_of_color_changed(color_id:INTEGER; new_score:INTEGER)
  	do
  		score_area.update_score (color_id, new_score)
  	end

  	notify_current_player_changed(new_player:INTEGER)
  	do
	 	if l_network.my_client_id = new_player then
 			your_turn
 		else
 			other_players_turn
 		end
 		score_area.set_next_player (logic.get_game.curennt_color_id)
  	end

 	notify_can_play_changed(new_can_play:BOOLEAN)
 	do
 		l_piece.update_validity (new_can_play)
		l_projector.project
 	end

  	notify_piece_removed(removed_piece:INTEGER)
  	do
  		block_group_area.remove_block(removed_piece)
  	end

end
