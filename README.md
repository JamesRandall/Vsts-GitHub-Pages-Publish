# GitHub Pages Publish

A build and release task to update GitHub Pages as part of a VSTS build or release. Ideal for publishing package documentation in conjunction with [DocFX](https://dotnet.github.io/docfx/) and something I use as part of my automated package and release pipeline for [AzureFromTheTrenches.Commanding](https://commanding.azurefromthetrenches.com).

## Prerequisites

To use the plugin you need to:

1. Have configured GitHub Pages to be hosted within the gh-pages branch of your repository. Setup instructions can be found [here](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/).
2. Obtain a Personal Access Token that the build task can use to commit to your gh-pages branch. Instructions for doing that can be found [here](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/). 

## Installation

You can find the plugin in the VSTS marketplace - just search for _Publish to GitHub Pages_, you will probably see it in the list after typing Publish then just add the task to your build or release pipeline.

In general I recommend having a build that compiles your documentation (and if you are using DocFX their are extensions in the marketplace for doing that easily) and a release that takes the artifacts from that and publishes them to GitHub Pages.

## Parameters

You'll then need to set the required parameters for the publishing process:

|Parameter|Description|
|---------|-----------|
|Documentation Source|File path (folder) in which the documentation is located - typically a build artifact folder e.g. $(System.DefaultWorkingDirectory)\Documentation\site\\*
|GitHub Username|Your GitHub username e.g. JamesRandall (mine).|
|GitHub Personal Access Token|The personal access token you obtained earlier. I recommend storing this in a secure VSTS build and release variable.|
|GitHub Email Address|The email address you want associated with the commit to the gh-pages branch|
|Repository Name|The name of the GitHub repository that you want to publish pages to|
|Commit Mmessage|The message you want associated with the commit - this defaults to "Automated Release $(Release.ReleaseId)"

## Bits and Pieces

It's really just a wrapper over some Git commands which you can see in the PowerShell script if you want to take a look or use this as a baseline for something slightly different.

Any issues log them in the Issues area for this GitHub repository or [https://twitter.com/AzureTrenches](message me on Twitter).
