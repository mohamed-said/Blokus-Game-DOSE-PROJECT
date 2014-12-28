note
	description: "Summary description for {G09_AI_MINI_MAX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	G09_AI_MINI_MAX

create
	make

feature
	make
	do

	end

	    --Pseudo-code of mini-max algorithm for n players.
    --mini_max(board: BOARD; player: INTEGER): MOVEMENT
    --do
    --    if (board.GetWinner() /= 0 || board.IsTie() then
    --        Movement mov = new Movement();
    --        mov.Value = board.GetWinner();
    --        Result:= mov;
    --    else
    --        int[] successors = board.GetAllowedMovements(true);
    --        Movement best = null;
    --        foreach (int successor in successors)
    --            Board successorBoard = (Board)board.Clone();
    --            successorBoard.SetMove(successor, player);
    --            Movement tmp = MiniMaxBasic(successorBoard, -player);
    --            if (best == null || (player == -1 && tmp.Value < best.Value) || (player == 1 && tmp.Value > best.Value)) then
    --                tmp.Position = successor;
    --                best = tmp;
    --            end
    --        end
    --        Result:= best;
    --    end
    --end
    
end
