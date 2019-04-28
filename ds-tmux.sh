#!/bin/sh
# ---------------------------------------------------------
# tmux sessions
# ---------------------------------------------------------
# tmux a -t datascience # will attach to session
# tmux ls  # will list current sessions
# <prefix> d  # will detach from current session

# ---------------------------------------------------------
# tmux new-session -d 'dsproj'
tmux new -s datascience
tmux split-window -h 'testing'
tmux new-window 'notebooks'
tmux -2 attach-session -d
