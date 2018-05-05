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

    $defaultWorkingDirectory = Get-VstsTaskVariable -Name 'System.DefaultWorkingDirectory'    
    
    Write-Host "Cloning existing GitHub Pages branch"

    git clone https://${githubusername}:$githubaccesstoken@github.com/$githubusername/$repositoryname.git --branch=gh-pages $defaultWorkingDirectory\ghpages --quiet
    $to = "$defaultWorkingDirectory\ghpages"

    Write-Host "Copying new documentation into branch"

    Copy-Item $docPath $to -recurse -Force

    Write-Host "Committing the GitHub Pages Branch"

    cd $defaultWorkingDirectory\ghpages
    git config core.autocrlf false
    git config user.email $githubemail
    git config user.name $githubusername
    git add *
    git commit -m $commitMessage --quiet
    git push --quiet

} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}
