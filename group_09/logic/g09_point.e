note
	description: "Represents an X, Y coordinates."
	author: "Mohamed Kamal"
	date: "$Date: 05-11-2013$"
	revision: "$Revision: 1.0$"

class
	G09_POINT

create
make_fromxy

feature{NONE} -- Initlization
	make_fromxy(x_m:INTEGER; y_m:INTEGER)
	do
		x := x_m
		y := y_m
	end

feature -- operators
	plus alias "+" (other:G09_POINT):G09_POINT
	do
		create result.make_fromxy (get_x + other.get_x, get_y + other.get_y)
	end

feature -- Access
	set_x(value:INTEGER)
	do
		x := value
	end

	set_y(value:INTEGER)
	do
		y := value
	end

	get_x() : INTEGER
	do
		result:=x
	end

	get_y() : INTEGER
	do
		result:=y
	end

feature{NONE} -- Implementation
	x:INTEGER
	y:INTEGER

end
