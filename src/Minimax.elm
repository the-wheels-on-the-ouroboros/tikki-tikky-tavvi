module Minimax where

import Model exposing (Coordinates, GameState, Status(InProgress, Tied, Won))
import Update
import Utilities


bestMove : GameState -> Maybe Coordinates
bestMove gameState =
    let
        bestNextGameState =
            Utilities.maximumBy (\state -> -1 * (score state)) (nextGameStates gameState)
    in
        case bestNextGameState of
            Just nextState -> Maybe.map .coordinates (List.head nextState.movesSoFar)
            Nothing -> Nothing


score : GameState -> Int
score gameState =
    let
        numberOfAvailableMoves = (gameState.boardSize^2) - (List.length gameState.movesSoFar)
    in
        case gameState.status of
            Tied -> 0
            Won player ->
                if player == gameState.currentPlayer
                    then numberOfAvailableMoves
                    else -1 * numberOfAvailableMoves
            InProgress ->
                Maybe.withDefault 0
                    <| List.maximum
                    <| List.map (\state -> -1 * (score state))
                    <| nextGameStates gameState


nextGameStates : GameState -> List GameState
nextGameStates gameState =
    let
        makeMove = \coordinates -> Update.makeMove coordinates gameState
    in
        case gameState.status of
            InProgress -> List.map makeMove (availableCoordinates gameState)
            _ -> []


availableCoordinates : GameState -> List Coordinates
availableCoordinates gameState =
    let
        isMoveTaken = \coordinates -> (Model.playerWhoMovedAt coordinates gameState) == Nothing
    in
        List.filter isMoveTaken (Model.boardCoordinates gameState)
