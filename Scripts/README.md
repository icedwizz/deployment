# Introduction 
Supporter Master Data Management (SMDM) is a master data initiative at National Trust that aims to get a single source of truth for the Trust's supporter records.  Furthermore, it increases scope to cover reference data management elements as well, some of which integrate with SMDM directly.  This solution is based on the Semarchy xDM product and this repository's main purpose is to store and manage the xDM models that drive that solution.

# Getting Started
Follow these steps to get started
1. Download and install [GIT for windows](https://git-scm.com/download/win)
2. Create a folder in your file system where you want your local GIT repository(s) to live
3. Open a command prompt and navigate to the location from the previous step (e.g. `cd C:\temp`)
4. Download the code to your local environment by using `git clone https://NationalTrust-Hosting@dev.azure.com/NationalTrust-Hosting/Supporter%20Master%20Data%20Management/_git/Supporter%20Master%20Data%20Management` 
5. Make sure you checkout the dev branch with the command `git checkout dev`
6. Step 4 should ask you for your National Trust credentials
7. Import version 0.1 of the SMDM and Reference Hubs into your Semarchy environment.  These can be found under the `models` folder in your local GIT repository

# Build and Test
Once your have finished your code, there is a process to ensuring we manage that code effectively and that it does not conflict with anything from anyone else.  This process is:
1. All code must be commited into a feature branch to avoid conflicts as much as possible.  To do this open the command prompt and go to your GIT repository
2. Create the local branch by using the command `git checkout -b new_branch dev` where *new_branch* is the name of the branch you want to create
3. Export the model from Semarchy to a file.  This **must** be version 0.1.  It is assumed that this has been worked on between the Getting Started steps and now
4. Overwrite the model in your local GIT repository.  This just means copying it on the file system
5. Within GIT you now need to tell the repository you've updated the file.  Use the command `git add -A` to add all changes to the staging list
6. Again from GIT commit your changes.  Use the command `git commit -m "my message goes here"`.  Note that the ticket number for the feature must appear in the commit, otherwise the feature will be rejected
7. Push the changes you've made so they are available to everyone.  You can do this with the command `git push`
    1. Note that the first time you push your branch there will only be a local copy of it, not a copy on the server.  Therefore on this first time you must add additional parameters to the command `git push -u origin new_branch` where *new_branch* is the name of the branch you are working in
8. You may repeat steps 3, 4, 5, 6 and 7 as many times as you need to until you are happy that the task has been completed.
9. Now you must do a pull request to merge your code into the development branch.  This is only available from the devops web console.  There is an online wizard to help with this
10. Always do the pull request from your branch into the *dev* branch.
11. For pull requests into DEV anyone can approve them (at this stage) so please complete the pull request once it has been made
12. Ensure that the *Delete new_branch after merging* (where *new_branch* is the name of the feature branch) is ticked to keep our branches clean
13. This will kick start a build and release into the DEV server
14. To clean up your local GIT repository.  You should prune the now deleted branch with the command `git remote prune origin`
15. You should also delete the local version of this branch but first you will likely need to switch away from it, as it is probably still checked out.  Do this with the command `git checkout dev`
16. Run `git pull` to get the latest version of code
17. Now you should be able to delete the local feature branch with the command `git branch -D new_branch` where *new_branch* is the name of the now deleted feeature branch

# Releases
To move a model into the TEST (and later PROD) environments, the models must be closed, so that they are not edited while being tested.  To do this there is manually-triggered but automated process which has a number of gates of approval.  The automation, though, reduces any human error in producing the release:
1. Ensure the code that you want to deploy is in the model version 0.1 in the `dev` branch in the repository
2. Trigger the **Initialize Release** build pipeline.  This process does a number of steps:
    1. Exports the current 0.1 model,  re-imports it to version 1.X, closes that model and then exports the closed version
	2. Commits the new, closed model back into the `dev` branch
	3. Creates a pull-request from the `dev` branch to the `test` branch
3. Approve the pull request into the `test` branch.  This release should be verified to contain the new, closed version of the model that you wish to release
4. Once the pull request is approved, the **Test Build** build pipeline will run, effectively creating a set of release artefacts from the `test` branch of the repository
5. When the build pipeline completes, this triggers the **TEST Release** release pipeline.  This pipeline automatically finds the release to deploy and will import and deploy it to the test environment	

Note that there is not yet an automated process for deploying to PROD.  However, it will be based heavily on steps 4 and 5 from the test release pipeline here, as the closed model will already exist and merely only need to be imported and deployed.  However, the release pipeline will be unlikely to be automatically triggered, and most likely rely on an manual trigger with approval.
	

# Useful Tips
Here are a few tips that you may find helpful:
1. Since most of the commands above you will be doing many times, you may want to script them.  Steps 2, 3, 4, 5, 6, and 7 would form a good example of a script with limited inputs (such as a commit message)
2. To look at GIT from the command line you can use `git branch -a` to see all your local branches.  This can be very helpful to know where your repository is pointing to
3. To check the status of your local repository use `git status`.  This can be helpful if you get lost and don't know what to do next
4. Check the web-based console to see what is happening.  If you can't see your commit or branch there, then it probably didn't work
