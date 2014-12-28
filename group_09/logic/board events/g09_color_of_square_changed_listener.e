note
	description: "Listener for 'Color of Square Changed' event"
	author: "Mohamed Kamal"
	date: "$Date: 07-11-2013$"
	revision: "$Revision: 1.0$"

deferred class
	G09_COLOR_OF_SQUARE_CHANGED_LISTENER

feature -- notified functions
	notify_color_of_square_changed(X:INTEGER; Y:INTEGER; new_color_id:INTEGER)
	-- notify that the color of square with X,Y coordinates on the board has been changed
	deferred
	end

end
