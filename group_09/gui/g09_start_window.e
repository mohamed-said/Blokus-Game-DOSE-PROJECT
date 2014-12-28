note
	description: "Summary description for {G09_START_WINDOW}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	G09_START_WINDOW

inherit

	EV_WINDOW
		redefine
			initialize,
			is_in_default_state
		end

	G09_GUI_CONSTANTS
		export
			{NONE} all
		undefine
			default_create,
			copy
		end

create
	make

feature {NONE} -- Private

		-- Buttons

	join_button, join_blokus_server_button, exit_button: G09_BUTTON_GREEN

		-- Main container
	main_area: EV_FIXED

		-- Pop-ups		
	enter_ip_popup: EV_FIXED

		-- Images
	background_image: G09_IMAGE

		-- Textfields
	enter_ip_textfield: EV_TEXT_FIELD

		-- Center position according to screen width

	get_center_position_x: INTEGER
		do
			result := ((create {EV_SCREEN}).width // 2) - (Window_width // 2)
		end

	get_center_position_y: INTEGER
		do
			result := ((create {EV_SCREEN}).height // 2) - (Window_height // 2)
		end

feature {NONE} -- Initialization

	make (a_main_ui_window: MAIN_WINDOW)
		do

				-- Store the main_ui object.
				-- We want to restore it later on (it's currently minimized).
			main_ui := a_main_ui_window

				-- Create the start window.
			make_with_title (window_title)

				-- Window settings
			disable_border
			disable_user_resize

				-- Center window according to user's screen size
			set_position (get_center_position_x, get_center_position_y)

				-- UI initialization
			setup_ui_containers
			setup_background
			setup_ui_buttons
			setup_enter_ip_popup
		end

	setup_ui_containers
		do
			create main_area
			extend (main_area)
			main_area.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
		end

	setup_background
		do
			create background_image.make ("g09_start_window_bg.png")
			main_area.set_background_pixmap (background_image.pixmap)
		end

	setup_ui_buttons
		do
			create join_button.make_with_text ("Join a game")
			create join_blokus_server_button.make_with_text ("Join Blokus server")
			create exit_button.make_with_text ("Exit")

				-- Adds buttons to main container
			main_area.extend (join_blokus_server_button)
			main_area.extend (join_button)
			main_area.extend (exit_button)

				-- Sets buttons positions
			main_area.set_item_position (join_blokus_server_button, 345, 250)
			main_area.set_item_position (join_button, 345, 310)
			main_area.set_item_position (exit_button, 345, 370)

				-- Button click events
			join_blokus_server_button.set_mouse_down_action (agent join_blokus_server)
			join_button.set_mouse_down_action (agent join_game)
			exit_button.set_mouse_down_action (agent exit_game)
		end


		-- Setup of pop-up for entering IP address when trying to join a game

	setup_enter_ip_popup
		local
			l_width, l_height, l_padding: INTEGER
			l_label_1: G09_LABEL_SMALL
			l_button_confirm, l_button_cancel: G09_BUTTON_STANDARD
		do
				-- Pop-up settings
			l_width := 200
			l_height := 130
			l_padding := 10
			create enter_ip_popup

				-- Add pop-up to main container
			main_area.extend_with_position_and_size (enter_ip_popup, 0, 0, l_width, l_height)

				-- UI elements
			create enter_ip_textfield
			create l_label_1.make_with_text_and_width ("Enter IP address", 155)
			create l_button_confirm.make_with_text ("Confirm")
			create l_button_cancel.make_with_text ("Cancel")

				-- Style
			enter_ip_popup.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
			l_label_1.set_label_background_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
			l_label_1.set_label_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))

				-- UI elements positioning
			enter_ip_popup.extend_with_position_and_size (enter_ip_textfield, l_padding, 40, l_width - (l_padding * 2), 20)
			enter_ip_popup.extend (l_label_1)
			enter_ip_popup.set_item_position (l_label_1, l_padding, l_padding)
			enter_ip_popup.extend (l_button_confirm)
			enter_ip_popup.set_item_position (l_button_confirm, 0, 80)
			enter_ip_popup.extend (l_button_cancel)
			enter_ip_popup.set_item_position (l_button_cancel, 0, 105)

				-- Mouse and key actions
			l_button_confirm.set_mouse_down_action (agent enter_ip_popup_confirm)
			l_button_cancel.set_mouse_down_action (agent enter_ip_popup_cancel)
			enter_ip_textfield.key_press_actions.extend (agent enter_ip_popup_key_down)

				-- Pop-up position
			main_area.set_item_position (enter_ip_popup, join_blokus_server_button.x_position, join_blokus_server_button.y_position)

				-- Hide the pop-up
			enter_ip_popup_hide
		end

	initialize
		do
			Precursor {EV_WINDOW}
				-- Execute 'request_close_window' when the user clicks
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
			Result := (width = Window_width) and then (height = Window_height) and then (title.is_equal (Window_title))
		end

feature {NONE} -- UI events

	join_blokus_server
		local
			window: G09_LOBBY_WINDOW
		do
			create window.make (main_ui, "80.162.1.209")
			window.show

				-- we inform the Main-UI about the game window; otherwise, the game window might get garbage collected
			main_ui.add_reference_to_game (window)
			destroy
		end

	join_game
		do
			enter_ip_popup_show
			enter_ip_textfield.set_focus
		end

	exit_game
		do
			destroy
		end

	enter_ip_popup_show
		do
			enter_ip_popup.show
			join_button.hide
			join_blokus_server_button.hide
			exit_button.hide
		end

	enter_ip_popup_hide
		do
			enter_ip_popup.hide
			join_button.show
			join_blokus_server_button.show
			exit_button.show
		end

	enter_ip_popup_key_down (key: EV_KEY)
		do
			if key.code = 41 then -- Enter key
				enter_ip_popup_confirm
			elseif key.code = 42 then -- Esc key
				enter_ip_popup_cancel
			end
		end

	enter_ip_popup_confirm
		local
			l_ip: STRING
			window: G09_LOBBY_WINDOW
		do
			l_ip := enter_ip_textfield.text
			if not l_ip.is_equal ("") then -- If textfield is not empty

				enter_ip_popup_hide
				create window.make (main_ui, l_ip)
				window.show

					-- we inform the Main-UI about the game window; otherwise, the game window might get garbage collected
				main_ui.add_reference_to_game (window)
				destroy
			end
		end

	enter_ip_popup_cancel
		do
			enter_ip_popup_hide
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

end
