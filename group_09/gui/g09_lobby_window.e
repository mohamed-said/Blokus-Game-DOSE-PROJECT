note
	description: "Summary description for {G09_START_WINDOW}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	G09_LOBBY_WINDOW

inherit
	EV_TITLED_WINDOW
		redefine
			initialize,
			is_in_default_state
		end

	G09_GUI_GAME_EVENTS_LISTENER
	undefine
		default_create, copy
	end

	G09_GUI_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy
		end

create
	make

feature {NONE} -- Initialization

	make(a_main_ui_window: MAIN_WINDOW; ip: STRING)
	do
	create main_network.make (Current)

	-- Store the main_ui object. We want to restore it later on (it's currently minimized).
	main_ui := a_main_ui_window
	-- Create the Blokus window.
	make_with_title (window_title)

	--disable_border
	disable_user_resize
	set_position (get_center_position_x, get_center_position_y)

	create player_1.make_with_text (waiting_name)
	create player_2.make_with_text (waiting_name)
	create player_3.make_with_text (waiting_name)
	create player_4.make_with_text (waiting_name)
	create start_game.make_with_text("0/4 Players")
	create cancel_game.make_with_text("Leave Game")
	create easy_button.make_with_text("Easy")
	create medium_button.make_with_text("Medium")
	create hard_button.make_with_text("Hard")
	create ip_address.make_with_text_and_width (main_network.my_ip, 155)

	create increse_time.make_with_text_and_width ("+", 50)
	create decrese_time.make_with_text_and_width ("-", 50)

	easy_button.set_mouse_down_action (agent add_ai(0))
	medium_button.set_mouse_down_action (agent add_ai(1))
	hard_button.set_mouse_down_action (agent add_ai(2))

	create players.make_filled (void, 1, 4)
	players.put (player_1, 1)
	players.put (player_2, 2)
	players.put (player_3, 3)
	players.put (player_4, 4)

	round_time := 45

	create current_time_label.make_with_text_and_type (round_time.out + " sec", 1)
	create set_timer_label.make_with_text_and_type ("Set round time:", 1)

	create container
	create main_area
	create side_menu_1
	create side_menu_2
	create side_menu_3

	extend (container)
	container.set_minimum_size (window_width, window_height)
	container.extend(main_area)
	container.set_item_position (main_area, 200, 100)
	container.extend(side_menu_1)
	container.set_item_position (side_menu_1, 598, 102)
	container.extend(side_menu_2)
	container.set_item_position (side_menu_2, 635, 220)
	container.extend(side_menu_3)
	container.set_item_position (side_menu_3, 590, 447)

	main_area.extend (player_1)
	main_area.set_item_position (player_1, 0, 29)
	player_1.set_inactive
	main_area.extend (player_2)
	main_area.set_item_position (player_2, 0, 117)
	player_2.set_inactive
	main_area.extend (player_3)
	main_area.set_item_position (player_3, 0, 204)
	player_3.set_inactive
	main_area.extend (player_4)
	main_area.set_item_position (player_4, 0, 292)
	player_4.set_inactive

	main_network.join_game (ip, 1500)

	side_menu_3.extend (start_game)
	side_menu_3.set_item_position (start_game, 0, 0)
	start_game.set_inactive

	side_menu_2.extend (easy_button)
	side_menu_2.set_item_position (easy_button, 0, 0)
	side_menu_2.extend (medium_button)
	side_menu_2.set_item_position (medium_button, 0, 60)
	side_menu_2.extend (hard_button)
	side_menu_2.set_item_position (hard_button, 0, 120)

	easy_button.set_inactive
	medium_button.set_inactive
	hard_button.set_inactive

	if main_network.is_host then
		container.extend (decrese_time)
		container.set_item_position (decrese_time, 320, 473)

		container.extend (increse_time)
		container.set_item_position (increse_time, 450, 475)

		easy_button.set_active
		medium_button.set_active
		hard_button.set_active

		cancel_game.set_text ("Cancel Game")
	end

	container.extend (set_timer_label)
	container.set_item_position (set_timer_label, 100, 470)
	container.extend (current_time_label)
	container.set_item_position (current_time_label, 340, 470)

	container.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
	main_area.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))

	create background_image.make ("g09_lobby_window_bg.png")
	container.set_background_pixmap (background_image.pixmap)

	side_menu_1.extend (ip_address)
	side_menu_1.set_item_position (ip_address, 0, 0)

	side_menu_3.extend (cancel_game)
	side_menu_3.set_item_position (cancel_game, 0, 40)

	side_menu_1.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
	side_menu_2.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
	side_menu_3.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))

	start_game.set_mouse_down_action (agent begin_game)
	cancel_game.set_mouse_down_action (agent cancel_game_action)
	increse_time.set_mouse_down_action (agent increse_game_time)
	decrese_time.set_mouse_down_action (agent decrese_game_time)

	setup_change_name_popup

	update_players_state

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
			Result := (width = Window_width) and then
				(height = Window_height) and then
				(title.is_equal (Window_title))
		end

	player_1,player_2, player_3, player_4 : G09_BUTTON_GREEN
	players : ARRAY[G09_BUTTON_GREEN]
	ip_address: G09_LABEL_SMALL
	container: EV_FIXED
	main_area, side_menu_1, side_menu_2, side_menu_3: EV_FIXED
	background_image: G09_IMAGE
	waiting_name : STRING = "-- Waiting for player --"
	main_network: G09_NETWORK

	player_name : STRING
	change_name_popup : EV_FIXED
	new_name_text_field : EV_TEXT_FIELD
	change_client_id : INTEGER

	round_time: INTEGER
	set_timer_label, current_time_label  : G09_LABEL_HEADER

	increse_time, decrese_time, easy_button, medium_button, hard_button: G09_BUTTON_GREEN
	start_game, cancel_game: G09_BUTTON_STANDARD

	add_ai(level:INTEGER)
	do
		if  player_2.get_text.is_equal (waiting_name) then
			main_network.add_ai_player (2, level)
		elseif player_3.get_text.is_equal (waiting_name)	then
			main_network.add_ai_player (3, level)
		elseif player_4.get_text.is_equal (waiting_name)	then
				main_network.add_ai_player (4, level)
		end
	end

	increse_game_time
	do
		if round_time < 995 then
		round_time := round_time + 5
		current_time_label.set_text (round_time.out + " sec")
		main_network.change_turn_time (round_time)
		end
	end

	decrese_game_time
	do
		if round_time > 5 then
			round_time := round_time - 5
			current_time_label.set_text (round_time.out + " sec")
			main_network.change_turn_time (round_time)
		end
	end

	cancel_game_action
	local
		window: G09_START_WINDOW
	do
		create window.make (main_ui)
		main_network.disconnect
		window.show
		main_ui.add_reference_to_game (window)
		destroy
	end

	begin_game()
	local
			can_start_game : BOOLEAN
	do
		can_start_game := true

	 	 if player_2.get_text.is_equal (waiting_name) then
		 	can_start_game := false
		 end

		 if player_3.get_text.is_equal (waiting_name) then
		 	can_start_game := false
		 end

		 if player_4.get_text.is_equal (waiting_name) then
		 	can_start_game := false
		 end

		if can_start_game then
			main_network.start_game
		end
	end

	setup_change_name_popup
	local
	l_width, l_height, l_padding : INTEGER
	l_label_1 : G09_LABEL_SMALL
	l_button_confirm,l_button_cancel : G09_BUTTON_STANDARD
	l_your_label : G09_BUTTON_GREEN
	l_your_id : INTEGER
	do
		l_width := 200
		l_height := 90
		l_padding := 10

		create change_name_popup

		container.extend_with_position_and_size (change_name_popup, 0, 0, l_width, l_height)

		l_your_id := main_network.my_client_id
		l_your_label := players[l_your_id]

		create new_name_text_field
		create l_label_1.make_with_text_and_width ("Change name:", 100)
		create l_button_confirm.make_with_text ("Confirm")
		create l_button_cancel.make_with_text ("Cancel")

		change_name_popup.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
		l_label_1.set_label_background_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
		l_label_1.set_label_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))

		change_name_popup.extend_with_position_and_size(new_name_text_field, l_padding, 40, l_width-(l_padding*2), 20)
		change_name_popup.extend (l_label_1)
		change_name_popup.set_item_position (l_label_1, l_padding, l_padding)
		change_name_popup.extend (l_button_confirm)
		change_name_popup.set_item_position (l_button_confirm, 0, 80)
		change_name_popup.extend (l_button_cancel)
		change_name_popup.set_item_position (l_button_cancel, 0, 105)

		l_button_confirm.set_mouse_down_action (agent change_name_popup_confirm)
		l_button_cancel.set_mouse_down_action (agent change_name_popup_cancel)

		container.set_item_position (change_name_popup, main_area.x_position, l_your_label.y_position+l_your_label.height+main_area.y_position)

		change_name_popup_hide

		new_name_text_field.key_press_actions.extend (agent change_name_key_down)

		-- TODO: if host, then you should be able to change other players name

		l_your_label.set_hover_cursor_type(15)
		l_your_label.set_mouse_down_action (agent change_your_name_popup(l_your_id))
		l_your_label.set_active

	end

	change_name_key_down(key : EV_KEY)
	do
		if key.code = 41 then
			change_name_popup_confirm
		elseif key.code = 42 then
			change_name_popup_cancel
		end
	end

	change_your_name_popup(client_id : INTEGER)
	do
		if change_name_popup.is_displayed = false then
			change_name_popup_show
			change_client_id := client_id
		end
	end

	change_name_popup_confirm
	local
		new_name : STRING
	do
		new_name := new_name_text_field.text

		if not new_name.is_equal ("") then
			main_network.change_client_name (change_client_id, new_name)
			change_name_popup_hide
		end
	end

	change_name_popup_cancel
	do
		change_name_popup_hide
	end

	change_name_popup_show
	do
		change_name_popup.show
		new_name_text_field.set_focus
	end

	change_name_popup_hide
	do
		change_name_popup.hide
		new_name_text_field.set_text ("")
	end

	number_of_players : INTEGER
	do
		result := main_network.connected_clients.count
	end

	update_players_state
	do
		if number_of_players = 4 then
			if main_network.is_host then
				start_game.set_text ("Start Game")
				start_game.set_active
				easy_button.set_inactive
				medium_button.set_inactive
				hard_button.set_inactive
			else
				start_game.set_text ("Waiting For Host To Start")
			end
		else
			if main_network.is_host then
				easy_button.set_active
				medium_button.set_active
				hard_button.set_active
			end
			start_game.set_text (number_of_players.out + "/4 Players")
			start_game.set_inactive
		end
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
	local
			window: G09_MAIN_WINDOW
			l_players : ARRAY[TUPLE[name: STRING; is_ai : BOOLEAN; ai_level: INTEGER]]
			player : TUPLE[name: STRING; is_ai : BOOLEAN; ai_level: INTEGER]
			can_start_game : BOOLEAN
	do
		create l_players.make_filled (void, 0, 3)

		can_start_game := true

		 --get player 1
		 create player.default_create
		 player.name := player_1.get_text

	 	l_players.put (player, 0)

	 	--get player 2
	 	create player.default_create
		 player.name := player_2.get_text

		 if player.name.is_equal (waiting_name) then
		 	can_start_game := false
		 end


		 if player.name.starts_with ("[ai") then
			player.is_ai := true
		 end

		 if player.is_ai then
		 	--TODO: Get real AI level
	 		player.ai_level := player.name.substring (5, 5).to_integer
	 	end

	 	l_players.put (player, 1)

 		--get player 3
	 	create player.default_create
		 player.name := player_3.get_text

		 if player.name.is_equal (waiting_name) then
		 	can_start_game := false
		 end

		 if player.name.starts_with ("[ai") then
			player.is_ai := true
		 end

		 if player.is_ai then
		 	--TODO: Get real AI level
	 		player.ai_level := player.name.substring (5, 5).to_integer
	 	end

	 	l_players.put (player, 2)

	 	--get player 4
	 	create player.default_create
		 player.name := player_4.get_text

		 if player.name.is_equal (waiting_name) then
		 	can_start_game := false
		 end

		 if player.name.starts_with ("[ai") then
			player.is_ai := true
		 end

		 if player.is_ai then
		 	--TODO: Get real AI level
	 		player.ai_level := player.name.substring (5, 5).to_integer
	 	end

	 	l_players.put (player, 3)

		if can_start_game then

		create window.make (main_ui, main_network, l_players, round_time)
		window.notify_game_starts
		window.show

		-- we inform the Main-UI about the game window; otherwise, the game window might get garbage collected
		main_ui.add_reference_to_game (window)
		destroy
		end
	end

	notify_game_over
	local
		window: G09_START_WINDOW
	do
		-- TODO: Is this right, Mikael?

		-- TODO: First tell the user (popup?) that connection was lost or the host quit
		create window.make (main_ui)
		window.show
		main_ui.add_reference_to_game (window)
		destroy
	end

	notify_client_connected(id: INTEGER; name: STRING)
	do
		if id = 1 then
			player_1.set_text (name)
		elseif id = 2 then
			player_2.set_text (name)
		elseif id = 3 then
			player_3.set_text (name)
		elseif id = 4 then
			player_4.set_text (name)
		end

		if main_network.is_host then

			players[id].set_hover_cursor_type(15)
			players[id].set_mouse_down_action (agent change_your_name_popup(id))
			players[id].set_active

		end
		update_players_state
	end

	notify_client_name_changed(id: INTEGER; new_name: STRING)
  	do
  		if id = 1 then
			player_1.set_text (new_name)
		elseif id = 2 then
			player_2.set_text (new_name)
		elseif id = 3 then
			player_3.set_text (new_name)
		elseif id = 4 then
			player_4.set_text (new_name)
		end
  	end

	notify_client_disconnected(id: INTEGER)
  	do
  		if id = 1 then
			player_1.set_text (waiting_name)
		elseif id = 2 then
			player_2.set_text (waiting_name)
		elseif id = 3 then
			player_3.set_text (waiting_name)
		elseif id = 4 then
			player_4.set_text (waiting_name)
		end
		update_players_state
  	end


feature -- Game settings

	notify_turn_time_changed(seconds: INTEGER)
  	do
  		round_time := seconds
  		current_time_label.set_text (seconds.out + " sec")
  	end

feature -- Chat message

	notify_chat_message_received(client_id: INTEGER; client_name: STRING; message: STRING)
	do
			check False end -- Should not be called here!
	end
end


