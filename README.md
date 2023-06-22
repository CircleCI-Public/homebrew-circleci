# Homebrew CircleCI

The CircleCI Homebrew Cask Repository for MacOS tools.

## Installation

The cask can be tapped in homebrew by running:

`brew tap circleci-public/circleci-brew`

## Casks

### CircleCI Self-Hosted Machine Runner

The CircleCI Self-Hosted Machine Runner for MacOS is used to run CircleCI Jobs on self managed MacOS installations. 

See the [CircleCI Self-Hosted Runner documentation](https://circleci.com/docs/runner-overview/) for more information on using Self-Hosted Runners

#### Installation

The CircleCI Self-Hosted Runner for MacOS can be installed by runner:

`brew install --cask circleci-public/circleci-brew/circleci-runner`

#### Uninstallation

To uninstall the Self-Hosted CircleCI Runner brew package **without** purging logs and configuration:
`brew uninstall --cask circleci-public/circleci-brew/circleci-runner`

To uninstall the Self-Hosted CircleCI Runner **with** purging logs and configuration:
`brew uninstall --cask --zap circleci-public/circleci-brew/circleci-runner`

## Contributing

Pull requests for CircleCI casks are gladly reviewed. When opening a pull request please ensure the following points are included in the pull request description:

- The nature of the changes made
- The reasoning for the changes
- Testing done for changes
