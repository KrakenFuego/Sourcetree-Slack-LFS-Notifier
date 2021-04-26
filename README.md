# Setup
1. Grab a copy of the CustomActions Folder and drop in your repo
2. Edit `lfs.ps1` to set the Slack Webhook URI
    - This only needs to be done once per repo as it will get shared with your team!
3. Open Sourcetree Settings -> Custom Actions -> Add Custom Action
4. Setup the action as below:
	- Title: As you wish - Just make sure you know which is lock/unlock
	- Tick 'Show Full Output'
	- Command to run `$ACTION $REPO $FILE SlackUsername`
		- ACTION = lock / unlock
		- SlackUsername = Whatever you want to user to appear as
		
![Setup](https://github.com/KrakenFuego/Sourcetree-Slack-LFS-Notifier/blob/main/lock.png?raw=true "Sourcetree Setup")
		
5. Once both are setup you can access them by right clicking on a file and chosing lock/unlock action.

### Known Features

- Files have to be locked/unlocked inidividually.
