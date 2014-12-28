note
	description: "Constants for the Graphical User Interface of the Blokus game."
	author: "Mikael Hardø"
	date: "$Date: 2013/10/30 08:43:00 $"
	revision: "1.0.0"

class
	G09_GUI_CONSTANTS

inherit
    KL_SHARED_FILE_SYSTEM
        export {NONE}
            all
        end
-- Constants for internal use
feature {NONE} -- Access

	Dose_folder: STRING = "dose"
	Image_folder: STRING = "images"
	G09_folder: STRING = "group_09"

	img_path: KL_PATHNAME
			-- Path were the images of G09 are stored
		do
			create Result.make
			Result.set_relative (True)
			Result.append_name (Dose_folder)
			Result.append_name (Image_folder)
			Result.append_name (G09_folder)
		end

	player_background: KL_PATHNAME
	do
			Result := img_path
			Result.append_name ("players_background.png")
	end
	img_board: KL_PATHNAME
		-- Path to "background" image
		do
			Result := img_path
			Result.append_name ("board.png")
		end

	img_background: KL_PATHNAME
			-- Path to "background" image
		do
			Result := img_path
			Result.append_name ("game_background.png")
		end

	img_brick(brick_color: STRING; state : INTEGER): KL_PATHNAME
	require
		valid_state: state < 3 and state > -1
	local
		state_name : STRING
	do
		if state = 0 then
			state_name := ""
		elseif state = 1 then
			state_name := "_valid"
		elseif state = 2 then
			state_name := "_invalid"
		end
		result := img_path
		result.append_name (brick_color + state_name + ".png")
	end

	img_brick_group(brick_color: STRING): KL_PATHNAME
	do
		result := img_path
		result.append_name (brick_color + "_group.png")
	end

	Window_title: STRING = "Blokus"
			-- Title of the main window

	Quit_dialog_message: STRING = "Do you really want to close?"
			-- Message for the quit dialog box

end -- class G09_GUI_CONSTANTS
