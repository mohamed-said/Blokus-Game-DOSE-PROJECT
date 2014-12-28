note
	description: "[
		Network client used by G09_NETWORK.
		Mainly adapted from the JOIN example.
		See legal notice at end of class.
	]"
	author: "Martin Marcher"
	date: "$Date$"
	revision: "$Revision$"

class
	G09_NETWORK_CLIENT

inherit

	NETWORK_CLIENT
		rename
			send as real_send
		redefine
			received
		end

create
	make_client

feature -- Connection

	make_client (host: STRING; a_port: INTEGER; a_listener: G09_NETWORK)
		local
		do
			create ref_msg.make (0, Void)
			my_id := -1
			create queue.make
			listener := a_listener
			make (a_port, host)
			max_to_poll := in_out.descriptor + 1
			create connection.make (in_out)
			create poll.make_read_only
			poll.put_read_command (connection)
			send (create {G09_INTERNAL_MESSAGE}.make (ref_msg.type_first_connect, Void))
		end

	look_for_updates
			-- Blocking
			-- Look for any updates from the server
		local
			stahp: BOOLEAN
		do
			if not stahp then
				scan_from_server
				scan_queue
			end
		rescue
			stahp := True
			listener.notify_connection_lost
			retry
		end

	send (msg: attached G09_INTERNAL_MESSAGE)
		do
			queue.offer (msg)
		end

	close
		do
			poll.remove_associated_read_command (connection.active_medium)
			connection.active_medium.close
			connection := Void
		end

feature -- Status

	port: INTEGER
		do
			Result := in_out.port
		end

feature {NONE} -- Implementation

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
					real_send (l_msg)
				end
			end
		end

	scan_from_server
			-- Part of the execute loop. Looks for RECEIVED messages
		local
			l_stop: BOOLEAN
		do
			from
				l_stop := False
			until
				l_stop
			loop
				poll.execute (max_to_poll, 100)
				if connection.is_waiting then
					connection.reset_waiting
					receive
					if received /= Void then
						message_received (received)
						received := Void
					end
				else
					l_stop := True
				end
			end
		end

	connection: G09_CONNECTION

	my_id: INTEGER

	message_out: G09_INTERNAL_MESSAGE

	received: detachable G09_INTERNAL_MESSAGE

	queue: G09_MESSAGE_QUEUE [G09_INTERNAL_MESSAGE]

	listener: attached G09_NETWORK

	client_name: STRING

	poll: MEDIUM_POLLER

	max_to_poll: INTEGER

	ref_msg: G09_INTERNAL_MESSAGE

	message_received (msg: like message_out)
			-- When a message has been received
		do
			if msg.message_type = msg.type_your_client_id then
				if attached {INTEGER} msg.message_object as obj then
					my_id := obj
				end
			end
			listener.recieve_internal_message (msg)
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
