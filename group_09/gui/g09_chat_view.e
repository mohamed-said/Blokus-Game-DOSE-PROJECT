note
	description: "Summary description for {G09_CHAT_VIEW}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	G09_CHAT_VIEW

inherit
	EV_FIXED

create
	make_with_parent


feature {NONE} -- Implementation

	chat_box: EV_TEXT
	message: EV_TEXT_FIELD
	button: EV_BUTTON
	main_window : G09_MAIN_WINDOW

	make_with_parent(window: G09_MAIN_WINDOW)
		local
		do
			default_create
			create chat_box.make_with_text ("")
			create message.make_with_text("")
			create button.make_with_text ("Send")

			main_window := window

			chat_box.disable_edit
			extend_with_position_and_size (chat_box, 0,0, 228, 120)
			extend_with_position_and_size (message, 0,120, 200, 20)
			extend_with_position_and_size (button, 180, 120, 48, 20)

			button.pointer_button_press_actions.extend (agent send_pressed)

			message.key_press_actions.extend (agent key_pressed)
		end

		key_pressed(key: EV_KEY)
		do
			if key.code = 41
			then
			 send_pressed(1,1,1,1,1,1,1,1)
			end

		end


		send_pressed(a, b, c: INTEGER_32; d,e,f: REAL_64; g,j: INTEGER_32)
		do
			main_window.chat_send(message.text.out)
			message.set_text ("")
		end

feature
	add_new_message(new_message: STRING)
	local
	do
		chat_box.append_text (new_message + "%N")
		chat_box.scroll_to_end
	end

end
