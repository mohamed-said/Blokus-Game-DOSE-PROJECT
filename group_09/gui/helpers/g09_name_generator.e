note
	description: "Summary description for {G09_NAME_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	G09_NAME_GENERATOR

create
	make

feature {NONE}

	make
	local
		l_time: TIME
		l_seed: INTEGER
	do
		create l_time.make_now
        l_seed := l_time.hour
	    l_seed := l_seed * 60 + l_time.minute
        l_seed := l_seed * 60 + l_time.second
        l_seed := l_seed * 1000 + l_time.milli_second
		create random.set_seed (l_seed)

		create name_array.make_filled ("", 0, 24)
		name_array.put ("Douglass H.", 0)
		name_array.put ("Vince T.", 1)
		name_array.put ("Danl H.", 2)
		name_array.put ("Bartlama R.", 3)
		name_array.put ("Zardus E.", 4)
		name_array.put ("Rolandus I.", 5)
		name_array.put ("Haxm", 6)
		name_array.put ("Charle", 7)
		name_array.put ("Smith A.", 8)
		name_array.put ("Emilio M.", 9)
		name_array.put ("Whitten", 10)
		name_array.put ("Worley L.", 11)
		name_array.put ("Claud", 12)
		name_array.put ("Marvin", 13)
		name_array.put ("Emzi B.", 14)
		name_array.put ("Gustav A.", 15)
		name_array.put ("Tandy", 16)
		name_array.put ("Hanson", 17)
		name_array.put ("Zollie", 18)
		name_array.put ("Woodie", 19)
		name_array.put ("Alcana", 20)
		name_array.put ("Hampton W.", 21)
		name_array.put ("Lemuel", 22)
		name_array.put ("Parker", 23)
		name_array.put ("Birt", 24)
	end

feature
	name_array : ARRAY[STRING]
	random : RANDOM

	get_name(is_ai: BOOLEAN; ai_level: INTEGER) : STRING
	local
		name: STRING
		number : INTEGER
		modulo : INTEGER
	do

		modulo := name_array.count
		random.forth
		number := random.item
		number := number \\ modulo

		if is_ai then
			Result := "[ai_" + ai_level.out + "] " + name_array[number]
		else
			Result := name_array[number]
		end

	end

end
