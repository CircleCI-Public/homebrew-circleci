# Homebrew CircleCI

The CircleCI Homebrew Cask Repository for macOS tools.

## Installation

The cask can be tapped in homebrew by running:

`brew tap circleci-public/homebrew-circleci`

## Casks

### CircleCI Self-Hosted Machine Runner

The CircleCI Self-Hosted Machine Runner for MacOS is used to run CircleCI Jobs on self managed MacOS installations. 

See the [CircleCI Self-Hosted Runner documentation](https://circleci.com/docs/runner-overview/) for more information on using Self-Hosted Runners

#### Installation

The CircleCI Self-Hosted Runner for MacOS can be installed from the CircleCI homebrew Cask. 

Add the cask to brew

`brew tap circleci-public/circleci`

Install the circleci-runner package

`brew install circleci-runner`

##### Configuration

The CircleCI Self-Hosted runner for MacOS is configured in the Library of the user who installed the runner. It can be found at `$HOME/Library/Preferences/com.circleci.runner/config.yaml`. The configuration file will need to be updated with a runner token before the self-hosted runner will be able to start.

A token and resource class can be created by using the [CircleCI CLI](https://circleci.com/docs/local-cli/); run `circleci runner resource-class --help` and `circleci runner token --help` for details.


##### Reviewing and Accepting the Apple Signature Notarization

Because the self-hosted runner is not compiled from source during installation the binary must be approved to run on your mac. This can be done via the UI by accepting the macOS pop-up asking if you wish to run the binary from the internet or programmatically.

To programmatically check and authorize the self-hosted runner use the following steps:

Verify the signature and notarization of the binary

`$ spctl -a -vvv -t install "$(brew --prefix)/bin/circleci-runner"`

Accept the Apple notarization ticket

`$ sudo xattr -r -d com.apple.quarantine "$(brew --prefix)/bin/circleci-runner"`

#### Stopping and Restarting the Self-Hosted Runner

To start the self-hosted runner the first time after it has been installed and configured run to enable the service:

```$ launchctl bootstrap gui/`stat -f %u` $HOME/Library/LaunchAgents/com.circleci.runner.plist```

Then start the service with: 

`$ launchctl load $HOME/Library/LaunchAgents/com.circleci.runner.plist`

To stop the self-hosted runner:

`$ launchctl unload $HOME/Library/LaunchAgents/com.circleci.runner.plist`

The runner is automatically started as a MacOS Launch Agent on login for the user who installed the runner. This is managed via [launchd](https://en.wikipedia.org/wiki/Launchd) service manager. This is configured in the Library of the installing user at `$HOME/Library/LaunchAgents/com.circleci.runner.plist`. It is managed via the `launchctl` command.

#### Uninstallation

To uninstall the Self-Hosted CircleCI Runner brew package **without** purging logs and configuration:
`brew uninstall --cask circleci-public/homebrew-circleci/circleci-runner`

To uninstall the Self-Hosted CircleCI Runner **with** purging logs and configuration:
`brew uninstall --cask --zap circleci-public/homebrew-circleci/circleci-runner`

## Logs

Logs for the self-hosted runner can be found at `$HOME/Library/Logs/com.circleci.runner/runner.log`

## Contributing

Pull requests for CircleCI casks are gladly reviewed. When opening a pull request please ensure the following points are included in the pull request description:

- The nature of the changes made
- The reasoning for the changes
- Testing done for changes
