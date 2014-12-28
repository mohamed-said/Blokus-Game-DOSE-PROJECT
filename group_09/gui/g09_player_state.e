note
	description: "Updates the state of the player (score and who's turn it is)"
	author: ""
	date: "$Date: 2013/12/2$"
	revision: "0.1"

class
	G09_PLAYER_STATE

inherit
	EV_FIXED

	G09_GUI_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy, is_equal
		end

create
	make
feature {NONE} -- Implementation

	score_1, score_2, score_3, score_4: G09_LABEL_SMALL
	name_1, name_2, name_3, name_4: G09_LABEL_SMALL
	main_window : G09_MAIN_WINDOW
	score1, score2, score3, score4 : INTEGER

	make(player_name1, player_name2, player_name3, player_name4 : STRING )
	local
	l_pixmap : EV_PIXMAP
	do
		default_create
		create l_pixmap
		l_pixmap.set_with_named_file (file_system.pathname_to_string (player_background))
     	extend (l_pixmap)

		create score_1.make_with_text_and_width  ("0",30)
		create score_2.make_with_text_and_width  ("0",30)
		create score_3.make_with_text_and_width  ("0",30)
		create score_4.make_with_text_and_width  ("0",30)
		create name_1.make_with_text_and_width (player_name1,155)
		create name_2.make_with_text_and_width (player_name2,155)
		create name_3.make_with_text_and_width (player_name3,155)
		create name_4.make_with_text_and_width (player_name4,155)

		current.extend_with_position_and_size (name_1, 0, 0, 130, 20)
		current.extend_with_position_and_size (name_2, 0, 27, 130, 20)
		current.extend_with_position_and_size (name_3, 0, 54, 130, 20)
		current.extend_with_position_and_size (name_4, 0, 81, 130, 20)

		current.extend_with_position_and_size (score_1, 165, 0, 15, 20)
		current.extend_with_position_and_size (score_2, 165, 27, 15, 20)
		current.extend_with_position_and_size (score_3, 165, 54, 15, 20)
		current.extend_with_position_and_size (score_4, 165, 81, 15, 20)
	end

	feature

	update_score(playerNumber: INTEGER; score: INTEGER)
		local
		do
			if playerNumber.is_equal (1)
			then
				 score_1.set_text(score.out)
				 score1 := score

			elseif playerNumber.is_equal (2)
			then
				 score_2.set_text(score.out)
				 score2 := score

			elseif playerNumber.is_equal (3)
			then
				 score_3.set_text(score.out)
				 score3 := score

			elseif playerNumber.is_equal (4)
			then
				 score_4.set_text(score.out)
				 score4 := score
			end
		end

	set_next_player(playerNumber: INTEGER)
	do

		score_1.set_label_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
		name_1.set_label_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
		score_2.set_label_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
		name_2.set_label_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
		score_3.set_label_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
		name_3.set_label_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
		score_4.set_label_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
		name_4.set_label_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))

		if playerNumber.is_equal (1)
				then
					 score_1.set_label_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (200, 0, 0))
					 name_1.set_label_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (200, 0, 0))
				elseif playerNumber.is_equal (2)
				then
					 	 score_2.set_label_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (200, 0, 0))
					 	 name_2.set_label_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (200, 0, 0))
				elseif playerNumber.is_equal (3)
				then
					 	 score_3.set_label_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (200, 0, 0))
					 	 name_3.set_label_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (200, 0, 0))
				elseif playerNumber.is_equal (4)
				then
					 	 score_4.set_label_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (200, 0, 0))
					 	 name_4.set_label_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (200, 0, 0))
				end
	end

feature -- access

	get_score_evaluation : ARRAY[TUPLE[name: STRING; score: INTEGER]]
	local
		score_evaluation : ARRAY[TUPLE[name: STRING; score: INTEGER]]
		l_i, hole_pos : INTEGER
		value_to_insert : INTEGER
		name_to_insert : STRING
		scores : ARRAY[INTEGER]
		players : ARRAY[STRING]
		done : BOOLEAN
	do
		create score_evaluation.make_filled (void, 0, 3)

		create scores.make_filled (0, 0, 3)
		scores.put (score1, 0)
		scores.put (score2, 1)
		scores.put (score3, 2)
		scores.put (score4, 3)

		create players.make_filled ("", 0, 3)
		players.put (name_1.get_text, 0)
		players.put (name_2.get_text, 1)
		players.put (name_3.get_text, 2)
		players.put (name_4.get_text, 3)

		from
			l_i := 1
		until
			l_i = 4
		loop
			value_to_insert := scores[l_i]
			name_to_insert := players[l_i]
			done := false
			from
				hole_pos := l_i
			until
				done
			loop
				if hole_pos > 0 and value_to_insert < scores[hole_pos - 1] then
					scores[hole_pos] := scores[hole_pos - 1]
					players[hole_pos] := players[hole_pos - 1]
        			hole_pos := hole_pos - 1
				else
					done := true
				end
			end

			l_i := l_i + 1
			scores[hole_pos] := value_to_insert
			players[hole_pos] := name_to_insert
		end

		score_evaluation.put ([players[0], scores[0]], 0)
		score_evaluation.put ([players[1], scores[1]], 1)
		score_evaluation.put ([players[2], scores[2]], 2)
		score_evaluation.put ([players[3], scores[3]], 3)

		result := score_evaluation

	end
end
