#!/bin/bash

function usage()
{
	echo "Utility command to help rebasing a branch"
	echo
	echo "Syntax: rebase.sh [branch_to_be_rebased_with | -h | --help]"
	echo
	echo "Options:"
	echo "	-h, --help	Opens the help and exit"
}

if [[ $# -eq 0 ]];
then
	echo "Enter the branch name to be rebased with: "
	read targetBranch
else
	if [ $1 == '-h' -o $1 == '--help' ];
	then
		usage
		exit 0
	else
		targetBranch=$1
	fi
fi

if ! git ls-files >& /dev/null; then
	echo "Current directory is not a Git Repository!"
	exit 1
fi

sourceBranch=$(git rev-parse --abbrev-ref HEAD)

function close()
{
	echo
	echo "Aborting rebase...."
	if ls `git rev-parse --git-dir` | grep rebase; then
		git rebase --abort
	elif [ -f "$(git rev-parse --git-dir)/MERGE_HEAD" ]; then
		git merge --abort
	fi

	currentBranch=$(git rev-parse --abbrev-ref HEAD)

	if [[ $currentBranch != $sourceBranch ]];
	then
		eval "git checkout $sourceBranch"
	fi

	exit 2
}

trap 'close' INT

function checkMergeConflictStatus()
{
	areUnresolvedConflicts=1;
	conflictFiles=$(git diff --name-only --diff-filter=U)

	if [ -n "$conflictFiles" ]; then
    	echo "Merge conflicts found. Checking resolution status..."

    	for file in $conflictFiles; do
        	if grep -q '<<<<<<<' "$file"; then
            	echo "Unresolved merge conflict in $file"
				areUnresolvedConflicts=0
        	fi
    	done
	fi

	return $areUnresolvedConflicts
}

function checkMergeConflicts()
{
	mergeConflicts=$(git ls-files -u | wc -l)
	areMergeConflictsResolved=0

	while checkMergeConflictStatus $1;
	do
		echo "Are all merge conflicts resolved?"
		read areMergeConflictsResolved

		if ! [ "$areMergeConflictsResolved" == 'y' -o -z "$areMergeConflictsResolved" ];
		then
			echo "Please Merge all the conflicts and continue"
			close
		else
			areMergeConflictsResolved=1
		fi

		mergeConflicts=$(git ls-files -u | wc -l)
	done

	return $areMergeConflictsResolved
}

if ! ls `git rev-parse --git-dir` | grep rebase; then
	eval "git pull origin $sourceBranch"

	if ! checkMergeConflicts $1;
	then
		git merge --continue || close
	fi

	eval "git checkout $targetBranch" || exit 1
	eval "git pull origin $targetBranch" || exit 1

	if ! checkMergeConflicts $1;
	then
		git merge --continue || close
	fi

	eval "git checkout $sourceBranch" || exit 1
	eval "git rebase -i origin/$targetBranch"

	while ls `git rev-parse --git-dir` | grep rebase;
	do
		conflicts=$(git ls-files -u | wc -l)
		checkMergeConflicts
		git add .
		git rebase --continue
	done
else
	echo "Cannot progress rebase | Git is already under another rebase!"
fi

trap 'echo -e CTRL-C will not terminate; exit 1' SIGINT
