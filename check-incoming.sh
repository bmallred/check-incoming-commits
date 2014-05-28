#!/usr/bin/zsh

# Setup our variables.
pwd=$( pwd )
home=$( getent passwd "$USER" | cut -d: -f6 )
message=""

# Search for Git repositories.
for repository in $( find $home -name ".git" | awk -F "/.git" '{print$1}' | awk -F "$home/" '{print$2}' )
do
    cd $home/$repository
    
    if [ $( git remote | wc -l ) -gt 0 ]
    then
        count=$( git remote update -p > /dev/null; git log ..@{u} 2> /dev/null | grep -c ^commit )
        if [ $count -gt 0 ]
        then
            message="$message($count) $repository\n"
        fi
    fi
done

# Search for Mercurial repositories.
for repository in $( find $home -name ".hg" | awk -F "/.hg" '{print$1}' | awk -F "$home/" '{print$2}' )
do
    cd $home/$repository

    if [ $( hg paths 2> /dev/null | wc -l ) -gt 0 ]
    then
        count=$( hg incoming 2> /dev/null | grep -c ^changeset )
        if [ $count -gt 0 ]
        then
            message="$message($count) $repository\n"
        fi
    fi
done

# Search for Bazaar repositories.
for repository in $( find $home -name ".bzr" | awk -F "/.bzr" '{print$1}' | awk -F "$home/" '{print$2}' )
do
    cd $home/$repository

    if [ $( bzr missing 2> /dev/null | wc -l ) -gt 0 ]
    then
        count=$( bzr missing 2> /dev/null | grep -c ^revno )
        if [ $count -gt 0 ]
        then
            message="$message($count) $repository\n"
        fi
    fi
done

# Return to the original working directory.
cd $pwd 

if [ $( echo "$message" | wc -c ) -gt 1 ]
then
    # Send notification display.
    notify-send -u low "Incoming Changesets" "$message"
fi
