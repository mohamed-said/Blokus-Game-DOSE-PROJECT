note
	description: "Launcher for the Blokus main window."
	author: "Mikael Hardø"
	date: "30.10.2013"
	revision: "0.1"

class
	G09_LAUNCHER

inherit
	LAUNCHER

feature	-- Implementation

	launch (main_ui_window: MAIN_WINDOW)
			-- lunch the application
		local
			window: G09_START_WINDOW
		do
			-- creates the start window
			-- gives the main_ui as argument so we can restore when blokus closes
			create window.make (main_ui_window)
			window.show

				-- we inform the Main-UI about the game window; otherwise, the game window might get garbage collected
			main_ui_window.add_reference_to_game (window)
		end

end
