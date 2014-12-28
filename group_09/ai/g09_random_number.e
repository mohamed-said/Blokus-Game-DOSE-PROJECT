note
    description : "This class provide a random number."
    author: "Bruno, Gasparrini, Gaumet, Marchisio, Ocejo."
    date: "12/01/2013"
    revision: "0.1"

class
    G09_RANDOM_NUMBER

create
make

feature -- Initialization
    make
    local
        l_time : TIME
        l_seed : INTEGER
    do
        create l_time.make_now
        l_seed := l_time.hour
        l_seed := l_seed * 60 + l_time.minute
        l_seed := l_seed * 60 + l_time.second
        l_seed := l_seed * 1000 + l_time.milli_second
        create random_sequence.set_seed (l_seed)
    end

feature -- Access
    random_integer(random_limit: INTEGER) : INTEGER
    local
        random_number: INTEGER
    do
        from
            random_sequence.forth
            random_number:= random_sequence.item \\ random_limit + 1
        until
            random_number > 0 and random_number <= random_limit
        loop
            random_sequence.forth
            random_number:= random_sequence.item \\ random_limit + 1
        end
        Result := random_number
    end
    
feature --Implementation
    random_sequence : RANDOM
    
invariant
    random_obtained: random_sequence /= Void
end
