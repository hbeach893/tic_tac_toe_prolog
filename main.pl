/*Standard: I am X's and User is O's*/
:- use_module(library(lists)).

/* -----------------------DRAWS THE BOARD-------------------------------- */
/* prints the game board */

show([H|T]) :-
  fixZero(H, Res),
  write(Res),
  write(' | '),
  show(T, 1).

show([H|T], 1):-
  fixZero(H, Res),
  write(Res),
  write(' | '),
  show(T, 2).

show([H|T], 2):-
  fixZero(H, Res),
  write(Res),
  write(' '),
  show(T, 0).

show([H|T], 0):-
  put(10),
  write('----------'),
  put(10),
  fixZero(H, Res),
  write(Res),
  write(' | '),
  show(T, 1).

show([], _).

fixZero(0, ' ').
fixZero(N, N) :- N \= 0.

/* ^^^^^^^^^^^^^^^^^DRAWS THE BOARD^^^^^^^^^^^^^^^^^*/
/* initializes the game and gives instructions to the user */


startGame():-
  write("Welcome to Tic Tac Toe!"),
  nl,
  write('-----------------------'),
  nl,
  write("To start the game you will be prompted to enter an 'X' or 'O'" ),
  nl,
  nl,
  write("An 'X' means I will go first, and an 'O' means you go first"),
  nl,
  nl,
  write("When it is your turn, you will be asked to enter a number 0-8"),
  nl,
  nl,
  write("Entering a number will represent placing your piece in the corresponding position on the board"),
  nl,
  nl,
  show(['0',1,2,3,4,5,6,7,8]),
  nl,
  nl,
  write("Here is the initial configuration of the board"),
  nl,
  nl,
  show([0,0,0,0,0,0,0,0,0]),
  [H|T]= [0,0,0,0,0,0,0,0,0],
  put(10),
  write("I'm X, you're O, type 'X' or 'O' to tell me who should go!'"),
  nl,
  read(X),
  next_turn(X, [H|T]).


/*------------------next_turn(User, Game)------------------*/
/*processes the next turn. If it's O's turn, it asks for user input. If it's X's turn, it implements the AI. */

next_turn('O', [H|T]) :-
  nl,
  write('Where next? '),
  nl,
  read(X),
  check_move([H|T], X, 'O').

next_turn('X', [H|T]) :-
  make_move([H|T], 'X', Result),
  put(10),
  put(10),
  write("X's Move: "),
  put(10),
  show(Result),
  nextMove('X', Result).
  % read_input('me', Result).


/*------------------check_move(Game, Pos, Result)------------------*/

/* given a user and a position, checks if a particular move is valid
   i.e. that position is empty */

check_move([H|T], X, User):-
  get([H|T], X, Res),
  Res \= 0,
  put(10),
  write('INVALID MOVE. PLEASE TRY AGAIN'),
  put(10),
  next_turn(User, [H|T]), !.

check_move([H|T], X, _):-
  get([H|T], X, Res),
  Res = 0,
  putAt([H|T], 'O', X, Result),
  put(10),
  write(Result),
  put(10),
  put(10),
  put(10),
  write("O's Move: "),
  put(10),
  show(Result),
  nextMove('O', Result).

/*^^^^^^^^^^^^^^^^^putAt(Game, User, Pos, Result) ^^^^^^^^^^^^^^^^^*/

/*------------------putAt(Game, User, Pos, Result)------------------*/
/* given a game board and user and positon, puts a piece at a particular location*/

putAt([H|T], User, Place, Result):-
  putAt([H|T], User, Place, Result, 0).

putAt([_|T], User, 0, Result, 0):-
  Result = [User|T], !.

putAt([H|T], User, N, [H|Result], Count):-
  N \= Count,
  Count1 is Count + 1,
  putAt(T, User, N, Result, Count1).

putAt([_|T], User, N, [User|T], N).

/*^^^^^^^^^^^^^^^^^putAt(Game, User, Pos, Result) ^^^^^^^^^^^^^^^^^*/

/*----------------make_move(Game, Pos, Result)-----------------*/
/* given the game and the user, determines what the next move should be*/

make_move(Game, User, Result):-
  count_pieces_on_board(Game, Amount),
  member(Amount, [0, 1,2]),
  get(Game, 4, 0),
  putAt(Game, User, 4, Result), !.

make_move(Game,User,Result):-
  count_pieces_on_board(Game, Amount),
  member(Amount, [1,2]),
  corner(X),
  get(Game, X, 0),
  putAt(Game, User, 0, Result), !.

make_move(Game, User, Result):-
  check_one_to_win(Game, User, X),
  putAt(Game, User, X, Result).

make_move(Game, User, Result):-
  check_one_to_win(Game, 'O', X),
  putAt(Game, User, X, Result), !.

make_move(Game, User, Result):-
  make_move(Game, User, Result, 0), !.

make_move(Game, User, Result, N):-
  get(Game, N, 0),
  putAt(Game, User, N, Result), !.

make_move(Game, User, Result, N):-
  get(Game, N, Val),
  Val \= 0,
  N1 is N + 1,
  make_move(Game, User, Result, N1), !.


/*^^^^^^^^^^^^^^^^^Get(Game, Pos, Result)^^^^^^^^^^^^^^^^^*/




/*----------------get(Game, Pos, Result)-----------------*/
/*get determines the piece at a particular location on the board*/

get([H|_], 0, H).

get([_|T], P, Res):-
  P > 0,
  get(T, P, 1, Res).

get([_|T], P, C, Res):-
  C1 is C + 1,
  C < P,
  get(T, P, C1, Res).

get([H|_], P, P, H).
/*^^^^^^^^^^^^^^^^^get(Game, Pos, Result)^^^^^^^^^^^^^^^^^*/

/*-----------count_pieces_on_board(Game, Result)--------*/
/*given a game board, detemines the number of pieces on the board*/

count_pieces_on_board([H|T], Result):-
  count_pieces_on_board([H|T], 0, Result).

count_pieces_on_board([H|T], N, Result):-
  H = 0,
  count_pieces_on_board(T, N, Result).

count_pieces_on_board([H|T], N, Result):-
  H \= 0,
  N1 is N + 1,
  count_pieces_on_board(T, N1, Result).

count_pieces_on_board(X, N, N):-
  X = [].

/*^^^^^^^^^^^^count_pieces_on_board(Game, Result)^^^^^^^^^^^^*/
corner(0).
corner(2).
corner(6).
corner(8).

middle(4).

middle(1).
middle(3).
middle(5).
middle(7).

/*------------------ check_one_to_win(Game, User, Result) ------------------*/
/*check_one_to_win determines, give a Game & User, detemines where 'X' should move to either win
  or stop a win */

check_one_to_win([H|T], User, Result):-
  check_one_to_win([H|T], User, 0, Result).


% found a place where there could be a win
check_one_to_win([H|T], User, N, N):-
  get([H|T], N, Val),
  Val = 0,
  putAt([H|T], User, N, NewBoard),
  checkwin(User, NewBoard).


check_one_to_win([H|T], User, N, Result):-
  get([H|T], N, Val),
  Val \= 0,
  N1 is N + 1,
  check_one_to_win([H|T], User, N1, Result).

check_one_to_win([H|T], User, N, Result):-
  get([H|T], N, Val),
  Val = 0,
  putAt([H|T], User, N, NewBoard),
  not(checkwin(User, NewBoard)),
  N1 is N + 1,
  check_one_to_win([H|T], User, N1, Result).



/*^^^^^^^^^^^^^^^^^check_one_to_win(Game, User, Result) ^^^^^^^^^^^^^^^^^*/


/*------------------ nextMove(User, Game) ------------------*/
/* nextMove takes in a user and a game and decides if the game is over (someone lost or it is a tie)
 if the game is NOT over, it detemines whose turn is next*/

nextMove(User, Game):-
  checkwin(User, Game),
  put(10),
  write("Congrats! " +  User + " won!"), !.

nextMove(_, Game):-
  count_pieces_on_board(Game, Amount),
  Amount = 9,
  put(10),
  nl,
  write('No winner. GAME OVER!'), !.

nextMove(User, Game):-
  User = 'X',
  next_turn('O', Game), !.

nextMove(User, Game):-
  User = 'O',
  next_turn('X', Game), !.
/*^^^^^^^^^^^^^^^^^ nextMove(User, Game) ^^^^^^^^^^^^^^^^^*/

/*------------------ checkwin(User, Game) ------------------*/
/* given a user and the game board, checks if the user has won the game!*/
checkwin(User,[User, User, User, _, _, _, _, _, _]).
checkwin(User,[ _, _, _,User, User, User, _, _, _]).
checkwin(User,[ _, _, _, _, _, _,User, User, User]).
checkwin(User, [User, _, _, User, _, _, User, _, _]).
checkwin(User, [_, User, _, _, User, _, _, User, _]).
checkwin(User, [_, _, User, _, _, User, _, _, User]).
checkwin(User, [User, _, _, _, User, _, _, _, User]).
checkwin(User, [_, _, User,_, User, _, User, _, _ ]).

/*^^^^^^^^^^^^^^^^^checkwin(User, Game)^^^^^^^^^^^^^^^^^*/
