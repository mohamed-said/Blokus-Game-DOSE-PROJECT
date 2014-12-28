note
	description: "Represents a player that play the blockus game."
	author: "Mohamed Kamal  -  Sherif Khaled"
	date: "$Date: 05-11-2013$"
	revision: "$Revision: 1.1$"

class
	G09_PLAYER

create
	make,
	make_with_color

feature{NONE} -- Initlization
	make()
	-- Deperacted: will be deleted
	do

	end

	make_with_color(color_id_m:INTEGER ; name_m:STRING)
	--create a player with a color id and name
	do
		create piece_removed_listeners.make
		create name_changed_listeners.make
		create score_updated_listeners.make
		create pieces_ids.make

		color_id:=color_id_m;
		name:=name_m;
		score:=0;

		initial_pieces()
	end

	initial_pieces()
	local
		i:INTEGER
	do
		from i:=1 until i > 21
		loop
			pieces_ids.extend(i)
			i := i + 1
		end
	end

feature -- Open API
	get_name():STRING
	-- get the name of the player
	do
		Result:=name;
	end

	get_color_id():INTEGER
	-- get the color the this player plays with
	do
		Result:=color_id;
	end

	get_score():INTEGER
	-- get the score of this player
	do
		Result:=score;
	end

	get_pieces_count():INTEGER
	-- get the number of pieces that the player has
	do
		result := pieces_ids.count;
	end

	get_piece(index: INTEGER):G09_PIECE
	-- get piece at the given index
	do
		create result.make_with_id(pieces_ids.i_th(index))
	end

feature{G09_LOGIC} -- update features available to LOGIC only
	set_name(n:STRING)
	do
		name:=n;
		raise_name_changed (name)
	end

feature{G09_GAME} -- update features available to GAME only
	update_score(new_score:INTEGER)
	do
		score := new_score;
		raise_score_updated (score)
	end

	remove_piece(removed_piece_id:INTEGER)
	do
		-- gives an exception because of precondition writable when move is recived from NET
		pieces_ids.start
		pieces_ids.search (removed_piece_id)
		pieces_ids.remove

		raise_piece_removed (removed_piece_id)
	end

feature{NONE} -- raise events features
	raise_name_changed(new_name:STRING)
	--create an event if the player name is chaneged
	do
		from name_changed_listeners.start until name_changed_listeners.after
		loop
			name_changed_listeners.item.notify_name_changed(new_name)
			name_changed_listeners.forth
		end
	end

	raise_piece_removed(removed_piece_id:INTEGER)
	--create an event if the player played a piece
	do
		from piece_removed_listeners.start until piece_removed_listeners.after
		loop
			piece_removed_listeners.item.notify_piece_removed(removed_piece_id)
			piece_removed_listeners.forth
		end
	end

	raise_score_updated(new_score:INTEGER)
	--
	do
		from score_updated_listeners.start until score_updated_listeners.after
		loop
			score_updated_listeners.item.notify_score_updated(new_score)
			score_updated_listeners.forth
		end
	end


feature -- Events
	name_changed_listeners:LINKED_LIST[G09_NAME_CHANGED_LISTENER]
	piece_removed_listeners:LINKED_LIST[G09_PIECE_REMOVED_LISTENER]
	score_updated_listeners:LINKED_LIST[G09_SCORE_UPDATED_LISTENER]

feature{NONE} -- internal representation
	Name:STRING;
	color_ID:INTEGER;
	score : INTEGER;

	pieces_ids: LINKED_LIST[INTEGER];
end
