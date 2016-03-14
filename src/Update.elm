module Update where

import Model exposing (..)

makeMove : Coordinates -> GameState -> GameState
makeMove coordinates state =
  { state |
    currentPlayer = other state.currentPlayer,
    movesSoFar = Move coordinates state.currentPlayer :: state.movesSoFar
  }