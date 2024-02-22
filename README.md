<br/>
<p align="center">
  <h3 align="center">Rebase Util</h3>

  <p align="center">
    Optimize your Git workflow effortlessly with our streamlined branch rebasing script
    <br/>
    <br/>
  </p>
</p>



## Table Of Contents

* [About the Project](#about-the-project)
* [Built With](#built-with)
* [Usage](#usage)

## About The Project


Addressing common challenges encountered during branch rebasing, I have developed a script to enhance the reliability of the process. Here are key advantages of utilizing this script over the conventional ` git rebase -i command`:

 * Ensure both the source and target branches are updated before initiating a rebase, mitigating the risk of inadvertently missing crucial updates.
* Detect and highlight any conflicts that arise during the rebase, offering clear guidance on conflict resolution.

##### Script Wokflow:
 * The script verifies if the current directory is a valid Git directory before proceeding.
* If the directory is a Git repository, the script performs pulls for both the source and target branches, diligently checking for any merge conflicts during the pull operations.
* Initiates the interactive rebase with the command `git rebase -i <target_branch>`.
* Identifies if any merge conflicts are present during the rebase. In case of conflicts, prompts the user to resolve them.
* After conflict resolution, the script verifies that all merge conflicts are appropriately resolved before proceeding.
* Once all conflicts are resolved, the script continues the rebase using the `git rebase --continue` command, iteratively repeating steps 4, 5 and 6 until the rebase is successfully completed.

Enhance your rebase process by incorporating this script, ensuring a smoother and conflict-resilient workflow.

##### Note:
* Currently this script is only supported for linux users

## Built With

Bash and git

## Usage

* Clone the repository
* Move to the git repository where you want to perform rebase and run the following command:
```sh
bash <path_to_file>/rebase.sh <target_branch>
```

To make this easier, you can add a alias for this script and make it a command:
* Move to the repository and make script executable by running the following command:
```sh
chmod +x rebase.sh
```
* Move to the home directory by the command `cd ~`
* Edit .bash_aliases file by using the command `nano .bash_aliases`
* Add the following line at the end
```sh
alias <command_name>='<absolute_path_to_repository>/rebase.sh'
```
* Save the file and run the following command:
```sh
source .bashrc
```
Now, you can directly run the following in the repository you want to perform rebase:
```sh
<comand_name> <target_branch>
```
