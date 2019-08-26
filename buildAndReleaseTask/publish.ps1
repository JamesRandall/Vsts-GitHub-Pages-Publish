[CmdletBinding()]
param()

Trace-VstsEnteringInvocation $MyInvocation
try {
    # Get inputs.
    $docPath = Get-VstsInput -Name 'docPath' -Require
    $githubusername = Get-VstsInput -Name 'githubusername' -Require
    $githubemail = Get-VstsInput -Name 'githubemail'
    $githubaccesstoken = Get-VstsInput -Name 'githubaccesstoken' -Require
    $repositoryname = Get-VstsInput -Name 'repositoryname' -Require
    $commitMessage = Get-VstsInput -Name 'commitmessage' -Require
    $branchName = Get-VstsInput -Name 'branchname' -Require
    $cleanRepository = Get-VstsInput -Name 'cleanrepository' -AsBool -Require

    $defaultWorkingDirectory = Get-VstsTaskVariable -Name 'System.DefaultWorkingDirectory'    
    
    Write-Host "Cloning existing GitHub repository"

    git clone https://${githubusername}:$githubaccesstoken@github.com/$githubusername/$repositoryname.git --branch=$branchName $defaultWorkingDirectory\ghpages --quiet
    
    if ($lastexitcode -gt 0)
    {
        Write-Host "##vso[task.logissue type=error;]Unable to clone repository - check username, access token and repository name. Error code $lastexitcode"
        [Environment]::Exit(1)
    }
    
    cd $defaultWorkingDirectory\ghpages
    git config core.autocrlf false
    git config user.email $githubemail
    git config user.name $githubusername

    if ($cleanRepository)
    {
        Write-Host "Cleaning the GitHub repository"
        git rm -r '*'
    }

    $to = "$defaultWorkingDirectory\ghpages"

    Write-Host "Copying new documentation into branch"

    Copy-Item $docPath $to -recurse -Force

    Write-Host "Committing the GitHub repository"

    git add *
    git commit --allow-empty -m $commitMessage

    if ($lastexitcode -gt 0)
    {
        Write-Host "##vso[task.logissue type=error;]Error committing - see earlier log, error code $lastexitcode"
        [Environment]::Exit(1)
    }

    git push --quiet

    if ($lastexitcode -gt 0)
    {
        Write-Host "##vso[task.logissue type=error;]Error pushing to $branchName branch, probably an incorrect Personal Access Token, error code $lastexitcode"
        [Environment]::Exit(1)
    }

} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}
