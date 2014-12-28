note
	description: "[
		Thread safe queue used as an outbox to queue messages for sending.
		Main GUI thread only puts messages in queue, while the network thread only polls the queue.
	]"
	author: "Martin Marcher"
	date: "$Date$"
	revision: "$Revision$"

class
	G09_MESSAGE_QUEUE [T]

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create message_list.make
			create monitor.make
		end

	message_list: LINKED_QUEUE [T]

	monitor: MUTEX

feature {ANY}

	is_empty: BOOLEAN
		do
			Result := message_list.is_empty
		end

	count: INTEGER_32
		do
			Result := message_list.count
		ensure
			Result >= 0
		end

	remove: T
		require
			not is_empty
		do
			monitor.lock
			Result := message_list.item
			message_list.remove
			monitor.unlock
		ensure
				--count = old count - 1 -- Cannot ensure, because it could be removed again just before feature termination
		end

	offer (item: T)
		do
			monitor.lock
			message_list.put (item)
			monitor.unlock
		ensure
				--count = old count + 1 -- Same problem as above
		end

end
