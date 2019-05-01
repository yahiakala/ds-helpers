# --------------------------------------------------------- 
# TMUX DATA SCIENCE
# ---------------------------------------------------------
# Create a tmux session as an IDE for Data Science Projects
# Created with Python in mind.
# ---------------------------------------------------------
# REQUIREMENTS
# ---------------------------------------------------------
# tmux > 2
# conda
# vim
# current directory should be a data science project
#   from the cookiecutter-data-science template.
#   See github.com/drivendata for more info.
# You should have a 'tests' folder in your working dir.
# ---------------------------------------------------------
# USAGE
# ---------------------------------------------------------
# sh ~/path/to/tmux_datascience.sh <a> <b> <c>
#  <a> : session name
#  <b> : main module/pkg name
#  <c> : conda environment name
# ---------------------------------------------------------

SESSIONNAME=$1  # tmux session name.
PKGNAME=$2  # package (main module/folder) name.
CONDANAME=$3 # conda env name.

# first arg is the name of session, second is name of first window
tmux new-session -s $SESSIONNAME -n bashwindow -d
# tmux send-keys "cd ~/" ENTER
# tmux send-keys "clear" ENTER

# Add new window
tmux new-window -n TDD

# Main code editor
tmux send-keys "cd $PKGNAME" ENTER
tmux send-keys "clear" ENTER

# Test code editor
tmux split-window -h
tmux send-keys "cd tests" ENTER
tmux send-keys "clear" ENTER

# Console
tmux split-window -v
tmux send-keys "cd tests" ENTER
tmux send-keys "conda activate $CONDANAME" ENTER
tmux send-keys "clear" ENTER

# Create a third window for notebooks
tmux new-window -n notebook
tmux send-keys "conda activate $CONDANAME" ENTER
tmux send-keys "clear" ENTER

# Go back to TDD
tmux select-window -t TDD

# Attach to session.
tmux attach-session -t $SESSIONNAME
