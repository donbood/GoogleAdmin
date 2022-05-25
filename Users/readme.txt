Read this first:
https://developers.google.com/admin-sdk/directory/v1/quickstart/python

ReadMe:
None of this code writes any data to your tenant. It fetches all user objects and writes them to a csv on your machine in your CWD called "GoogleUsersOutput.csv"

It is recommended that you run this in the shell because after you run it, you have access to the $outputarray variable which holds all of the users in Powershell object form.

"Get-users.ps1" is the controller.

"fetchusers.py" connects to the Google Admin Directory api and returns a json string that is used to convert user objects to Powershell Objects. It is run automatically as part of "Get-Users.ps1"

To use, run:
> .\Get-Users.ps1

Or, just open the repo in VSCode and click the Play button on Get-Users.ps1.

=========================================================================================================================================================================
The "PythonOnly" repo is an attempt to do everything in only Python and nothing in Powershell.
