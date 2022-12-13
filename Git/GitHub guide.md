## How to connect and contribute to The Knowledge Hub

### Setting up your local repository

#### Step 1: Adding the remote origin

For R users, this should be done after creating an R project in your chosen directory, and initiating a Git repository in that project (via tools > version control > project setup).

1.	Create a Personal Access Token (PAT)
    a.	In GitHub, go to profile > settings > developer settings > personal access tokens; add a sensible name in the description, and select "repo" from the options
2.	Within your R git project, run the following command in the terminal, inserting the above in place of “PAT”: 

`git remote add origin https://PAT@github.com/ukhsa-collaboration/statistics-production-knowledge-hub.git`

If you ever need to change the origin, run this command instead:

`git remote set-url origin https://PAT@github.com/ukhsa-collaboration/statistics-production-knowledge-hub.git`


#### Step 2: Pulling the remote repository

Before pulling the repository, you should delete the .gitignore file that might have automatically been created in your R project. This is to avoid conflict issues with the pull. 

Then simply run: 

`git pull`


#### Step 3: Creating a local branch

The GitHub repository is set up to deny any pushes to the main branch. Instead, you should create a different local branch and push from that when ready. This is to allow for a review via a pull request before merging in to the main branch.

Run this command to create a new branch:

`git checkout -b name`

### Making changes and pushing to GitHub

#### Step 1: Keeping your local branch up to date

At relatively regular intervals, such as when you start working on a new major change, you should ensure that your branch is up to date with the main remote branch. This is to help avoid merge issues when you eventually want to push your changes to main. 

These commands will do that:

`git fetch`

`git merge origin/main`

#### Step 2: Adding and committing
Regularly check the status of your Git staging area to check which files are being tracked and which are staged for commits. 
`git status`

Note that any files or filetypes included in the .gitignore file will not show up here. 

To stage a file for a commit, use the add command. You can use asterisks as wildcards so that you don’t need to include the entire filepath.

`git add . 		#Add all tracked files`

`git add *.html		#Add anything that ends in .html`

`git add *Disclosure*	#Add anything with disclosure in the title`

`git add *a*b*		#Use asterisks for filenames with spaces`

Once files have been staged, you can commit them. Please include a descriptive message.

`git commit -m “A useful message of what has been done”`


#### Step 3: Pushing to the GitHub repository

Once you are ready, and all changes have been committed to your local repository, you can push your branch to Github. 

`git push`

You will then need to log on to GitHub, go to create pull request, and fill out the form to request that the changes made in your branch are pulled into the main branch. One of the repository admins will then review and approve your request, or suggest changes as necessary. 

