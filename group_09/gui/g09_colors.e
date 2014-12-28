note
	description: "Dialog constants. Standard strings displayed on "
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date: 2013-01-11 10:28:37 -0800 (Fri, 11 Jan 2013) $"
	revision: "$Revision: 90517 $"

class
	G09_COLORS

-- Colors (Internal)
-- We will use the Logic implementation and delete this later
-- For the moment, we'll keep it here, because it's used in the code
feature

	blue: INTEGER
		do
			Result := 0
		end

	yellow: INTEGER
		do
			Result := 1
		end

	red: INTEGER
		do
			Result := 2
		end

	green: INTEGER
		do
			Result := 3
		end
end
