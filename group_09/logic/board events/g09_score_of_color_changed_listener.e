note
	description: "Listener for 'Score Of Color Changed' event"
	author: "Mohamed Kamal"
	date: "$Date: 07-11-2013$"
	revision: "$Revision: 1.0$"

deferred class
	G09_SCORE_OF_COLOR_CHANGED_LISTENER

feature -- notified functions
	notify_score_of_color_changed(color_id:INTEGER; new_score:INTEGER)
	-- notify that the score of a certain color has changed
	deferred
	end

end
