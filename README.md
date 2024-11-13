# VU Advanced Statistics (Students)

This repository contains student files for the UIBK course "VU Advanced Statistics."

See the [course web page](https://ltalluto.github.io/vu_advanced_statistics) and the [Github repository](https://github.com/ltalluto/vu_advanced_statistics) for information on getting set up for the course.

## Cloning this repository in RStudio

Assuming you have already installed RStudio and `rstan`, you can proceed to save this repository as an RStudio project.

### 1. Install git
Before installing git, you should check RStudio to see if it is already installed and recognised. The easiest way to do this is:

1. Choose the `Tools` menu, then `Global Options`, then the `Git/SVN` tab. 
2. Make sure the box **Enable version control interface for RStudio projects** is checked
3. Check that there is a valid file path under **Git executable**. 

If there is no file path, quit RStudio and follow the instructions for your operating system below.

#### Windows
1. Install git using the [official installer](http://git-scm.com/downloads).
2. Restart RStudio and follow the instructions above to make sure that your git executable is found.
3. If RStudio still can't find git, you can click **Browse** to find `git.exe` yourself.

#### Mac & Linux

If you have already followed the [course setup instructions](https://github.com/ltalluto/vu_advanced_statistics/#r-developer-tools) then you will have the R developer tools, and should already have git. Normally, RStudio will find this automatically. If not:

1. Open a new Terminal window (Mac: run `Terminal.app` in the `/Applications/Utilities` folder.
2. Type `which git` in the Terminal
3. In RStudio, set this to the location for the git executable.

### 2. Get the repository

1. In RStudio, choose `File -> New Project`
2. Select `Version Control` then `Git`
3. For **Repository URL** enter `https://github.com/ltalluto/vu_advstats_students.git`
4. **Project directory name** will be filled in by default
5. For **Create project as a subdirectory of**, you can browse to a location on your computer where you want to keep the course files.

### 3. Start working
You will now have a folder named `vu_advstats_students`. Inside you will find all the files for the course. Additionally, there will be a file named `vu_advstats_students.Rproj`. You can open this file whenever you start working to open RStudio and correctly set your working directory.