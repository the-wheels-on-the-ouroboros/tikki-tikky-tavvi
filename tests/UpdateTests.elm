module UpdateTests where

import ElmTest exposing (..)

import Model exposing (
    GameState,
    Coordinates,
    Move,
    Player (X, O),
    Status (InProgress, Tied, Won)
  )
import Update exposing (makeMove)

all : Test
all =
  suite "Updating the game model" <|
    [
      suite "Making a move" <|
        let
          player = X
          targetCoordinates = (Coordinates 0 0)
        in
          [
            suite "When a move has not been made at target coordinates" <|
              let
                gameState = GameState 3 player [] InProgress
              in
                [
                  test "Records the move made in a new game state" <|
                    assertEqual
                      [ Move targetCoordinates player ]
                      (makeMove targetCoordinates gameState).movesSoFar,

                  test "Returns a game state in which the other player is now the current player" <|
                    assertEqual
                      (Model.other player)
                      (makeMove targetCoordinates gameState).currentPlayer
                ],
            suite "When a move has already been made at target coordinates" <|
              let
                preexistingMove = Move targetCoordinates player
                gameState = GameState 3 (Model.other player) [ preexistingMove ] InProgress
              in
                [
                  test "Returns an unchanged game state" <|
                    assertEqual gameState <| makeMove targetCoordinates gameState
                ]
          ]
    ]
