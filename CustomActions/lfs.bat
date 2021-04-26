@ECHO ON

set GIT_REDIRECT_STDERR=2>&1
set GIT_LFS_REDIRECT_STDERR=2>&1

echo | powershell.exe -ExecutionPolicy Unrestricted -Command  "& '%~dpn0.ps1'" -UserExcluded %1 %2 %3 %4
