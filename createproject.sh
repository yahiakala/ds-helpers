# This is meant to create a Data Science project following the
# format here: 
# https://github.com/drivendata/cookiecutter-data-science
# with some minor tweaks and with some automation.

# Some updates in the drivendata repo are expected soon, which will
# require an update from this (Apr 12, 2019).

# -------------------------------------------------------------------
# REQUIREMENTS
# -------------------------------------------------------------------
# conda/miniconda
# conda-forge channel added. (conda config --add channels conda-forge)
# 
# -------------------------------------------------------------------
# HOW TO USE
# -------------------------------------------------------------------
# Go to a parent folder where your repo folder will go in. Then run
# ./path/to/createproject.sh
# -------------------------------------------------------------------

# First we create a conda environment.
echo "First we create a conda environment for our new project."
read -p "Enter the conda env name (recommended same name as repo) : " environment_name
conda create -n $environment_name
# remove is conda remove --name myenv --all
conda activate $environment_name

# Check if this works without adding the conda-forge channel to the base env
echo "Then we install cookiectter."
conda install cookiecutter

# Packages to install from conda
echo "Let's install some conda packages."
read -p "List the packages you want to install from conda : " condapkg_install
if [[ ! -z "$condapkg_install" ]]; then
	conda install $condapkg_install
fi

# echo "Now for pip packages. Only pick packages you can't get from conda."
# echo "I recommend you install dotenv. It keps you manage local environment variables and API keys."
# echo "I also recommend you install kaggle if you want to download a dataset from there."
# read -p "List the packages you want to install from pip : " pippkg_install
# pip install $pippkg_install

# echo "Please name your repo/project the same as the conda env name or else this script will break."
# cookiecutter https://github.com/drivendata/cookiecutter-data-science

# cd $environment_name

# Download data from kaggle
# cd data/raw
# if [[ $pippkg_install == *"kaggle"* ]]; then
# 	echo "You have opted to install kaggle. If you want to download data, make sure"
# 	echo "you have set up your API key as described in https://github.com/kaggle/kaggle-api"
# 	read -p "Do you want to download a dataset? [y/n] : " kag_dwn
# 	if [[ $kag_dwn == "y" ]]; then
# 		echo "Enter the link to the dataset. For example, if "
# 		echo "the link to the dataset is kaggle.com/mlg-ulb/creditcardfraud "
# 	        echo "then enter mlg-ulb/creditcardfraud"
# 		read -p "Enter link : " kag_das
# 		kaggle datasets download -d $kag_das
# 	fi
# fi
# cd ../..

# Replace the data folder with nothing.
# sed -i -e "s_/data/_#Nothing" .gitignore

# Tweak .gitignore file.
# echo "# Include data sub-folders" >> .gitignore
# echo "data/raw/*" >> .gitignore
# echo "data/interim/*" >> .gitignore
# echo "data/processed/*" >> .gitignore
# echo "data/external/*" >> .gitignore
# echo "!.gitkeep" >> .gitignore

# Replace .env with *.env
# sed -i -e 's/.env/*.env' .gitignore

# Rename package from src to something else.
# echo "Your package will be given the same name as your conda env/repo"
# echo "Except any non-letters will be taken out."
# ppkg_name=$(echo $environment_name | sed 's/[^a-zA-Z]*//g')
# mv src $ppkg_name
# sed -i -e "s/src/$ppkg_name/g" setup.py

# Pip install package.
# pip install -e .

# Initialize and push git repo.

# That's it for now!

