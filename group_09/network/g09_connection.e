note
	description: "[
		Holds information about a connection to the server.
		Used by G09_NETWORK_SERVER.
	]"
	author: "Martin Marcher"
	date: "$Date$"
	revision: "$Revision$"

class
	G09_CONNECTION

inherit

	POLL_COMMAND
		redefine
			make
		end

create
	make, make_for_AI

feature

	make (s: IO_MEDIUM)
		do
			Precursor (s)
			is_AI := False
			set_random_name (0)
		end

	make_for_AI (level: INTEGER)
		do
			is_AI := True
			set_random_name (level)
		end

	is_waiting: BOOLEAN

	is_AI: BOOLEAN

	name: STRING

	set_name (a_name: STRING)
		do
			name := a_name
		end

	set_random_name (level: INTEGER)
		local
			random: G09_NAME_GENERATOR
		do
			create random.make
			name := random.get_name (is_AI, level)
		end

	reset_waiting
		do
			is_waiting := False
		end

	execute (arg: detachable ANY)
		do
			is_waiting := True
		end

end
