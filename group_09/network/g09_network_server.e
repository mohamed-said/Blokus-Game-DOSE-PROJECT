note
	description: "[
		Network server used by G09_NETWORK.
		Mainly adapted from the CHAT example. 
		See legal notice at end of class.
	]"
	author: "Martin Marcher"
	date: "$Date$"
	revision: "$Revision$"

class
	G09_NETWORK_SERVER

inherit

	NETWORK_SERVER
		rename
			close as close_server
		redefine
			receive,
			received
		end

	STORABLE

create
	make_server

feature -- Instantiation

	make_server (a_port: INTEGER; a_listener: G09_NETWORK)
		do
			create ref_msg.make (0, Void)
			listener := a_listener
			make (a_port)
			in.set_non_blocking
			reset_game
		ensure
			right_port: port = a_port
		rescue
		end

feature -- Connection

	look_for_updates
			-- Blocking
			-- Look for any updates from server/other clients
		do
			receive;
			process_message;
			respond;
		end

	send (msg: attached like message_out)
		do
			queue.offer (msg)
		end

	close
		do
			running := False
			close_server
		end

feature -- Status

	port: INTEGER
		do
			Result := in.port
		end

feature {NONE} -- Implementation

	ref_msg: G09_INTERNAL_MESSAGE

	running: BOOLEAN

	listener: G09_NETWORK

	queue: G09_MESSAGE_QUEUE [G09_INTERNAL_MESSAGE]

	poller: MEDIUM_POLLER

	max_to_poll: INTEGER

	connections: HASH_TABLE [G09_CONNECTION, INTEGER]

	message_out: G09_INTERNAL_MESSAGE

	turn_time: INTEGER

	server_name: STRING

	scan_queue
			-- Part of execute loop. Looks for messages to be SENT
		local
			l_msg: detachable like message_out
		do
			from
			until
				queue.is_empty
			loop
				l_msg := queue.remove
				if l_msg /= Void then
					broadcast (l_msg)
				end
			end
		end

feature {NONE} --Internal helper methods

	reset_game
		do
			print ("%N------------------------------------------------%NStarting new game%N")
			queue := Void
			poller := Void
			connections := Void
			create queue.make
			max_to_poll := 1
			turn_time := -1 --Meaning it hasn't been changed yet.
			create connections.make (4)
			create poller.make_read_only
		end

	current_connection_id: INTEGER
		do
			Result := connections.key_for_iteration
		end

	next_free_seat: INTEGER
		local
			i: INTEGER
			stop: BOOLEAN
		do
			from
				stop := False
				i := 1
			until
				stop or i > 4
			loop
				if not connections.has (i) then
					Result := i
					stop := True
				end
				i := i + 1
			end
			if not stop then
				Result := -1
			end
		end

	send_connected_clients(medium: IO_MEDIUM)
		local
			l_clients: HASH_TABLE [STRING, INTEGER]
			l_conn: HASH_TABLE [G09_CONNECTION, INTEGER]
		do
			create l_clients.make (4)
			from
				l_conn := connections.deep_twin
				l_conn.start
			until
				l_conn.after
			loop
				l_clients.put (l_conn.item_for_iteration.name, l_conn.key_for_iteration)
				l_conn.forth
			end
			medium.independent_store (create {G09_INTERNAL_MESSAGE}.make (ref_msg.type_connected_clients, l_clients))
		end

	disconnect_client (id: INTEGER)
		do
			poller.remove_associated_read_command (connections.at (id).active_medium)
			connections.at (id).active_medium.close
			connections.remove (id)
			broadcast (create {G09_INTERNAL_MESSAGE}.make (ref_msg.type_client_disconnected, id))
			if id = 1 then
				from
					connections.start
				until
					connections.after
				loop
					if not connections.item_for_iteration.is_ai then
						poller.remove_associated_read_command (connections.item_for_iteration.active_medium)
						connections.item_for_iteration.active_medium.close
					end
					connections.forth
				end
				reset_game
			end
		end

feature {NONE} -- Exception handling

	remove_lost_connections
		local
			current_key: INTEGER
		do
			from
				connections.start
			until
				connections.after
			loop
				current_key := connections.key_for_iteration
				connections.item_for_iteration.active_medium.independent_store (create {G09_INTERNAL_MESSAGE}.make (ref_msg.type_try_connection, Void))
				connections.forth
			end
		rescue
			print ("Number " + current_key.out + " is closed%N")
			disconnect_client (current_key)
			retry
		end

feature {NONE} -- From NETWORK_SERVER

	received: G09_INTERNAL_MESSAGE

	receive
			--Part of the execute loop
		local
			l_conn: G09_CONNECTION
			l_new_id: INTEGER
			l_tuple: TUPLE [id: INTEGER; name: STRING]
			r_nb_conn: INTEGER
		do
			in.accept
			if attached {like outflow} in.accepted as l_outflow then
				if connections.count < 4 then
					if max_to_poll <= l_outflow.descriptor then
						max_to_poll := l_outflow.descriptor + 1
					end
					print ("SERVER: Address: " + l_outflow.peer_address.host_address.host_address + ":")
					print (l_outflow.peer_address.port)
					print ("%N")
					l_new_id := next_free_seat
					check
						no_free_seat: l_new_id /= -1
					end
					create l_conn.make (l_outflow)
					l_conn.reset_waiting
					connections.put (l_conn, l_new_id)
					l_outflow.independent_store (create {G09_INTERNAL_MESSAGE}.make (ref_msg.type_your_client_id, l_new_id))
					poller.put_read_command (l_conn)
					create l_tuple.default_create
					l_tuple.id := l_new_id
					l_tuple.name := l_conn.name
					broadcast (create {G09_INTERNAL_MESSAGE}.make (ref_msg.type_client_connected, l_tuple))
				else -- It's filled with players
					l_outflow.close
				end
			end
			poller.execute (max_to_poll, 100)
			scan_queue
		rescue
			print ("IN RESCUE (receive)%N")
			r_nb_conn := connections.count
			remove_lost_connections
			if connections.count < r_nb_conn then
				retry
			end
		end

	process_message
			--Part of the execute loop
		local
			r_nb_conn: INTEGER
		do
			from
				connections.start
			until
				connections.after
			loop
				if connections.item_for_iteration.is_waiting then
					connections.item_for_iteration.reset_waiting
					if attached {like message_out} retrieved (connections.item_for_iteration.active_medium) as l_message_in then
						message_received (l_message_in)
					end
				end
				connections.forth
			end
		rescue
			print ("IN RESCUE (process_message)%N")
			r_nb_conn := connections.count
			remove_lost_connections
			if connections.count < r_nb_conn then
				retry
			end
		end

	broadcast (msg: like message_out)
		local
			l_conn: HASH_TABLE [G09_CONNECTION, INTEGER]
			r_nb_conn: INTEGER
		do
			l_conn := connections.deep_twin
			from
				l_conn.start
			until
				l_conn.after
			loop
				if not l_conn.item_for_iteration.is_ai then
					msg.independent_store (l_conn.item_for_iteration.active_medium)
				end
				l_conn.forth
			end
			listener.recieve_internal_message (msg)
		rescue
			print ("IN RESCUE (broadcast)%N")
			r_nb_conn := connections.count
			remove_lost_connections
			if connections.count < r_nb_conn then
				retry
			end
		end

	message_received (msg: like message_out)
			-- When a message is received from a client
		local
			l_tuple: TUPLE [id: INTEGER; name: STRING]
			l_AI_conn: G09_CONNECTION
		do
			print ("SERVER: Message received! It was ")
			if msg.message_type = msg.type_first_connect then
				print ("First Connect!")
				send_connected_clients(connections.item_for_iteration.active_medium)
				if (turn_time > 0) then
					broadcast (create {G09_INTERNAL_MESSAGE}.make (msg.type_turn_time_changed, turn_time))
				end
			elseif msg.message_type = msg.type_my_client_name then
				print ("My client name from id: ")
				print (current_connection_id)
				if attached {STRING} msg.message_object as obj then
					connections.at (current_connection_id).set_name (obj)
					create l_tuple.default_create
					l_tuple.id := current_connection_id
					l_tuple.name := obj
					broadcast (create {G09_INTERNAL_MESSAGE}.make (msg.type_client_name_changed, l_tuple))
				else
					check
						Wrong_object_structure: False
					end
				end
			elseif msg.message_type = msg.type_start_game then
				print ("Game starting")
				broadcast (msg)
			elseif msg.message_type = msg.type_client_name_changed then
				print ("Client name changed")
				if attached {TUPLE [id: INTEGER; name: STRING]} msg.message_object as obj then
					connections.at (obj.id).set_name (obj.name)
					broadcast (msg)
				else
					check
						Wrong_object_structure: False
					end
				end
			elseif msg.message_type = msg.type_turn_time_changed then
				print ("Turn time changed")
				if attached {INTEGER} msg.message_object as obj then
					turn_time := obj
					broadcast (msg)
				else
					check
						Wrong_object_structure: False
					end
				end
			elseif msg.message_type = msg.type_connect_ai then
				print ("Connect AI")
				if attached {TUPLE [seat: INTEGER; level: INTEGER]} msg.message_object as obj then
					if connections.has (obj.seat) then
						-- Seat is already taken : ignore this
					else
						create l_ai_conn.make_for_ai (obj.level)
						connections.put (l_ai_conn, obj.seat)
						--broadcast_connected_clients
						create l_tuple.default_create
						l_tuple.id := obj.seat
						l_tuple.name := l_ai_conn.name
						broadcast (create {G09_INTERNAL_MESSAGE}.make (ref_msg.type_client_connected, l_tuple))
					end
				else
					check
						Wrong_object_structure: False
					end
				end
			elseif msg.message_type = msg.type_chat_message then
				print ("Chat message")
				if attached {TUPLE [INTEGER, STRING]} msg.message_object as obj then
					broadcast (msg)
				else
					check
						Wrong_object_structure: False
					end
				end
			elseif msg.message_type = msg.type_game_update then
				print ("Game update")
				if attached {TUPLE [INTEGER, ANY]} msg.message_object as obj then
					broadcast (msg)
				else
					check
						Wrong_object_structure: False
					end
				end
			else
				check
					Unknown_type: False
				end
			end
			print ("%N")
		end

note
	copyright: "Copyright (c) 1984-2006, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
		Eiffel Software
		356 Storke Road, Goleta, CA 93117 USA
		Telephone 805-685-1006, Fax 805-685-6869
		Website http://www.eiffel.com
		Customer support http://support.eiffel.com
	]"

end
