# -------------------------------------------------------------------
# CREATEPROJECT
# -------------------------------------------------------------------
# This Bash script is meant to create a Data Science project
# following the format here: 
# https://github.com/drivendata/cookiecutter-data-science
# with some minor tweaks and with some automation.
#
# Some updates in the drivendata repo are expected soon, which will
# require an update from this (Apr 12, 2019).
#
# -------------------------------------------------------------------
# FEATURES
# -------------------------------------------------------------------
# Project name, conda environment given same name
#
# Package name is the project name but only a-z characters
#
# Creates a fresh conda environment with packages of your choice
# 
# Installs additional packages of your choice from pip
#
# If you install kaggle from pip, you can specify a dataset to
# 	download and unzip into the project/data/raw folder.
#
# Option to create a local git repo
#
# Option to create a GitHub repo and push your local repo.
#
# Option to push your local git repo to an existing GitHub repo.
#
# -------------------------------------------------------------------
# REQUIREMENTS
# -------------------------------------------------------------------
# I only use this on ubuntu. Adapt as you wish for other distros.
#
# conda/miniconda.
# conda-forge channel. (conda config --add channels conda-forge)
# cookiecutter. (install via conda or via pip - see link at top).
# unzip. (sudo apt-get install unzip)
#
# -------------------------------------------------------------------
# HOW TO USE
# -------------------------------------------------------------------
# Go to a parent folder where your repo folder will go in. Then run
# ./path/to/createproject.sh
# Then follow the prompts.
# -------------------------------------------------------------------

# Cookiecutter download here. 
cookiecutter https://github.com/drivendata/cookiecutter-data-science

# Find the latest created folder, that is the project name.
environment_name=$(ls -t | head -1)

# First we create a conda environment.
echo "First we create a conda environment for our new project."
conda create -n $environment_name
conda activate $environment_name

# Packages to install from conda
echo "Let's install some conda packages."
read -p "List the packages you want to install from conda : " condapkg_install
if [[ ! -z "$condapkg_install" ]]; then
	conda install $condapkg_install
else
	conda install numpy pandas matplotlib  # The holy trinity.
fi

echo "Now for pip packages. Only pick packages you can't get from conda."
echo "I recommend you install dotenv. It keps you manage local environment variables and API keys."
echo "I also recommend you install kaggle if you want to download a dataset from there."
read -p "List the packages you want to install from pip : " pippkg_install

if [[ ! -z "pippkg_install" ]]; then
	pip install $pippkg_install
fi

cd $environment_name

# Download data from kaggle
cd data/raw
if [[ $pippkg_install == *"kaggle"* ]]; then
	echo "You have opted to install kaggle. If you want to download data, make sure"
	echo "you have set up your API key as described in https://github.com/kaggle/kaggle-api"
	read -p "Do you want to download a dataset? [y/n] : " kag_dwn
	if [[ $kag_dwn == "y" ]]; then
		echo "Enter the link to the dataset. For example, if "
		echo "the link to the dataset is kaggle.com/mlg-ulb/creditcardfraud "
	        echo "then enter mlg-ulb/creditcardfraud"
		read -p "Enter link : " kag_das
		kaggle datasets download -d $kag_das
		newfile_name=$(ls -t | head -n1)
		echo "Can only handle zip files right now. Can change later."
		unzip $newfile_name
	fi
fi
cd ../..

# Replace the data folder with nothing in the .gitignore file.
sed -i -e "s_/data/_#Nothing_g" .gitignore

# Tweak .gitignore file.
echo "# Include data sub-folders" >> .gitignore
echo "data/raw/*" >> .gitignore
echo "data/interim/*" >> .gitignore
echo "data/processed/*" >> .gitignore
echo "data/external/*" >> .gitignore
echo "!.gitkeep" >> .gitignore

# Replace .env with *.env
sed -i -e 's/.env/*.env/g' .gitignore

# Rename package from src to something else.
echo "Your package will be given the same name as your conda env/repo"
echo "Except any non-letters will be taken out."
ppkg_name=$(echo $environment_name | sed 's/[^a-zA-Z]*//g')
mv src $ppkg_name
sed -i -e "s/src/$ppkg_name/g" setup.py

# Pip install package.
pip install -e .

# Initialize and push git repo.
read -p "Do you want to create a git repo? [y/n] : " create_git

if [[ $create_git == "y" ]]; then
	git init
	git add .
	git commit -m "First commit."
	read -p "Do you want to create a new github repo? [y/n] : " create_github
	if [[ $create_github == "y" ]]; then
		read -p "Provide your GitHub username. " github_username
		curl -u $github_username https://api.github.com/user/repos -d '{"name":"'"$environment_name"'"}'
		git remote add origin https://github.com/$github_username/$environment_name.git
		git push origin master
	else
		read -p "Do you want to push this to an existing github repo? [y/n] : " add_github
		if [[ $add_github == "y" ]]; then
			read -p "Provide the URL to your repository. " github_remote_url
			git remote add origin $github_remote_url
			git push origin master
		fi
	fi
fi

echo ""
echo "Okay we're all set!"
echo ""

# That's it for now!

