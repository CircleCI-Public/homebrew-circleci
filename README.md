# Homebrew CircleCI

The CircleCI Homebrew Cask Repository for macOS tools.

## Installation

The cask can be tapped in homebrew by running:

```shell
$ brew tap circleci-public/homebrew-circleci
```

## Casks

### CircleCI Self-Hosted Machine Runner

The CircleCI Self-Hosted Machine Runner for MacOS is used to run CircleCI Jobs on self managed MacOS installations. 

See the [CircleCI Self-Hosted Runner documentation](https://circleci.com/docs/runner-overview/) for more information on using Self-Hosted Runners

#### Installation

The CircleCI Self-Hosted Runner for MacOS can be installed from the CircleCI homebrew Cask. 

Add the cask to brew

```shell
$ brew tap circleci-public/circleci
```

Install the circleci-runner package

```shell
$ brew install circleci-runner
```

##### Configuration

The CircleCI Self-Hosted runner for MacOS is configured in the Library of the user who installed the runner. It can be found at `$HOME/Library/Preferences/com.circleci.runner/config.yaml`. The configuration file will need to be updated with a runner token before the self-hosted runner will be able to start.

A token and resource class can be created by using the [CircleCI CLI](https://circleci.com/docs/local-cli/); run `circleci runner resource-class --help` and `circleci runner token --help` for details.


##### Reviewing and Accepting the Apple Signature Notarization

Because the self-hosted runner is not compiled from source during installation the binary must be approved to run on your mac. This can be done via the UI by accepting the macOS pop-up asking if you wish to run the binary from the internet or programmatically.

To programmatically check and authorize the self-hosted runner use the following steps:

Verify the signature and notarization of the binary

```shell
$ spctl -a -vvv -t install "$(brew --prefix)/bin/circleci-runner"
```

Accept the Apple notarization ticket

```shell
$ sudo xattr -r -d com.apple.quarantine "$(brew --prefix)/bin/circleci-runner"
```

#### Starting and Stopping the Self-Hosted Runner

To start the self-hosted runner for the first time after it has been installed and configured, you can bootstrap the service using the commands below:
```shell
$ launchctl bootstrap gui/$(id -u) $HOME/Library/LaunchAgents/com.circleci.runner.plist
$ launchctl enable gui/$(id -u)/com.circleci.runner
$ launchctl kickstart -k gui/$(id -u)/com.circleci.runner
```

##### Running in a non-GUI session
If you wish to run the self-hosted runner in a headless or non-GUI session, copy or move the `.plist` file to `/Library/LaunchAgents`. This location is for per-user agents configured by the administrator, which ensures the service loads after a reboot:
```shell
$ sudo mv $HOME/Library/LaunchAgents/com.circleci.runner.plist /Library/LaunchAgents/
```

Next, use the user domain in the `launchctl` bootstrap command:
```shell
$ launchctl bootstrap user/$(id -u) /Library/LaunchAgents/com.circleci.runner.plist
$ launchctl enable user/$(id -u)/com.circleci.runner
$ launchctl kickstart -k user/$(id -u)/com.circleci.runner
```

To verify that the service is running, execute the following command:
```shell
$ launchctl print user/$(id -u)/com.circleci.runner
```

The runner automatically starts as a macOS Launch Agent upon login for the user who installed the runner. This is managed by the [launchd](https://en.wikipedia.org/wiki/Launchd) service manager  and is configured in the Library of the installing user at `$HOME/Library/LaunchAgents/com.circleci.runner.plist`. When using a non-GUI session, it is configured within the system services. It is controlled using the [launchctl](https://ss64.com/mac/launchctl.html) command.

In order to stop the runner agent, prevent the service from starting automatically at boot by executing:
```shell
$ launchctl disable user/$(id -u)/com.circleci.runner
```

To stop the currently running service:
```shell
$ launchctl bootout user/$(id -u)/com.circleci.runner
```

#### Uninstallation

To uninstall the Self-Hosted CircleCI Runner brew package **without** purging logs and configuration:
```shell
$ brew uninstall --cask circleci-public/homebrew-circleci/circleci-runner
```

To uninstall the Self-Hosted CircleCI Runner **with** purging logs and configuration:
```shell
$ brew uninstall --cask --zap circleci-public/homebrew-circleci/circleci-runner
```

## Logs

Logs for the self-hosted runner can be found at `$HOME/Library/Logs/com.circleci.runner/runner.log`

## Contributing

Pull requests for CircleCI casks are gladly reviewed. When opening a pull request please ensure the following points are included in the pull request description:

- The nature of the changes made
- The reasoning for the changes
- Testing done for changes
