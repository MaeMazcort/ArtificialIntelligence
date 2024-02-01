% First we need to set the possible moves for the game, taking into consideration that
% the maximum of people on the boat is 2
% First value: Cannibals, Second value: Missionaries
validMove(0, 1).
validMove(0, 2). 
validMove(1, 0).
validMove(1, 1).
validMove(2, 0). 

% Define the starting and ending state
startingPoint(state(3, 3, 0, 0, 'LeftToRigth')). % There are 3 missionaries and 3 cannibals and they start at the left
expectedResult(state(0, 0, 3, 3, _)). % At the final, all of the missionaries and cannibals must be at the right

% Validate if there is more missionares than cannibals, so they are not eaten
moreMissionariesThanCannibals(State) :- 
    State = state(MissionariesStart, CannibalsStart, MissionariesEnd, CannibalsEnd, _), 
    (MissionariesStart >= CannibalsStart; MissionariesStart == 0), % There are more missionaries at the start
    (MissionariesEnd >= CannibalsEnd; MissionariesEnd == 0). % There are more missionaries at the end

% Set the moves
move(State, NextState) :- 
    (leftToRigth(AmountMissionaries, AmountCannibals, State, NextState); % Move from left to rigth
     rigthToLeft(AmountMissionaries, AmountCannibals, State, NextState)). % Move from rigth to left

% Definition of the starting and ending state, and the total of missionaries and cannibals to move from left to rigth
leftToRigth(AmountMissionaries, AmountCannibals,
            state(MissionariesStart, CannibalsStart, MissionariesEnd, CannibalsEnd, 'LeftToRigth'),
            state(NewMissionariesStart, NewCannibalsStart, NewMissionariesEnd, NewCannibalsEnd, 'RigthToLeft')):- 
    validMove(AmountCannibals, AmountMissionaries), % Use a valid move
    AmountMissionaries =< MissionariesStart, % Check if the amount of missionaries is available
    AmountCannibals =< CannibalsStart, % Check if the amount of cannibals is available
    NewMissionariesStart is MissionariesStart - AmountMissionaries, % Update the new amount of missionaries at the start
    NewCannibalsStart is CannibalsStart - AmountCannibals, % Update the new amount of cannibals at the start
    NewMissionariesEnd is MissionariesEnd + AmountMissionaries, % Update the new amount of missionaries at the end
    NewCannibalsEnd is CannibalsEnd + AmountCannibals, % Update the new amount of cannibals at the end
    moreMissionariesThanCannibals(state(NewMissionariesStart, NewCannibalsStart, NewMissionariesEnd, NewCannibalsEnd, 'RigthToLeft')). % Make sure that the update is correct

% Definition of the starting and ending state, and the total of missionaries and cannibals to move from rigth to left
rigthToLeft(AmountMissionaries, AmountCannibals,
            state(MissionariesStart, CannibalsStart, MissionariesEnd, CannibalsEnd, 'RigthToLeft'),
            state(NewMissionariesStart, NewCannibalsStart, NewMissionariesEnd, NewCannibalsEnd, 'LeftToRigth')):- 
    validMove(AmountCannibals, AmountMissionaries), % Use a valid move
    AmountMissionaries =< MissionariesEnd, % Check if the amount of missionaries is available 
    AmountCannibals =< CannibalsEnd, % Check if the amount of cannibals is available
    NewMissionariesStart is MissionariesStart + AmountMissionaries, % Update the new amount of missionaries at the start 
    NewCannibalsStart is CannibalsStart + AmountCannibals, % Update the new amount of cannibals at the start
    NewMissionariesEnd is MissionariesEnd - AmountMissionaries, % Update the new amount of missionaries at the end
    NewCannibalsEnd is CannibalsEnd - AmountCannibals, % Update the new amount of cannibals at the end 
    moreMissionariesThanCannibals(state(NewMissionariesStart, NewCannibalsStart, NewMissionariesEnd, NewCannibalsEnd, 'LeftToRigth')). % Make sure that the update is correct

% If it is the expected result, just print the movements
findSolution(State, Movements, []) :- 
    expectedResult(State), % Check if it is the expected result
    printMovements(Movements). % Print the movements

% While the solution is not found, keep searching
findSolution(State, Movements, Moves) :- 
    not(expectedResult(State)), % It is not the expected result
    move(State, NextState), % Make a move
    moreMissionariesThanCannibals(NextState), % Validate
    not(member(NextState, Movements)), % Check if the move is already made
    findSolution(NextState, [NextState|Movements], Moves). % Recursive call to keep searching

% Print a list of the movements
printMovements([A|B]) :- 
    write(A), nl, % Print
    printMovements(B). % Keep printing

printMovements([]). % Print the movements

% Find a solution 
solveProblem :- 
    startingPoint(StartingStatus), 
    findSolution(StartingStatus, [StartingStatus], _).


  