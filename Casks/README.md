# CircleCI Casks

| Cask | Description |
|------|-------------|
| [`circleci-runner`](#circleci-runner) | CircleCI Self-Hosted Machine Runner for macOS |

---

## circleci-runner

The CircleCI Self-Hosted Machine Runner for macOS runs CircleCI jobs on self-managed macOS installations.

See the [CircleCI Self-Hosted Runner documentation](https://circleci.com/docs/runner-overview/) for more information.

### Installation

```shell
$ brew install circleci-runner
```

### Configuration

The configuration file is created at `$HOME/Library/Preferences/com.circleci.runner/config.yaml` and must be updated with a runner token before the runner can start. A token and resource class can be created using the [CircleCI CLI](https://circleci.com/docs/local-cli/); run `circleci runner resource-class --help` and `circleci runner token --help` for details.

### Apple Signature Notarization

Because the runner binary is not compiled from source, it must be approved to run on macOS. To do this programmatically:

```shell
$ spctl -a -vvv -t install "$(brew --prefix)/bin/circleci-runner"
$ sudo xattr -r -d com.apple.quarantine "$(brew --prefix)/bin/circleci-runner"
```

### Starting and Stopping

The runner starts automatically as a macOS Launch Agent on login. It is managed via [launchctl](https://ss64.com/mac/launchctl.html).

**GUI session:**
```shell
# Start
$ launchctl bootstrap gui/$(id -u) $HOME/Library/LaunchAgents/com.circleci.runner.plist
$ launchctl enable gui/$(id -u)/com.circleci.runner
$ launchctl kickstart -k gui/$(id -u)/com.circleci.runner

# Stop
$ launchctl disable gui/$(id -u)/com.circleci.runner
$ launchctl bootout gui/$(id -u)/com.circleci.runner
```

**Non-GUI (headless) session:** move the `.plist` to `/Library/LaunchAgents/` first, then use `user/$(id -u)` in place of `gui/$(id -u)`.

```shell
$ sudo mv $HOME/Library/LaunchAgents/com.circleci.runner.plist /Library/LaunchAgents/
$ launchctl bootstrap user/$(id -u) /Library/LaunchAgents/com.circleci.runner.plist
$ launchctl enable user/$(id -u)/com.circleci.runner
$ launchctl kickstart -k user/$(id -u)/com.circleci.runner
```

### Uninstallation

```shell
# Without purging logs and configuration
$ brew uninstall --cask circleci-public/homebrew-circleci/circleci-runner

# With purging logs and configuration
$ brew uninstall --cask --zap circleci-public/homebrew-circleci/circleci-runner
```

### Logs

`$HOME/Library/Logs/com.circleci.runner/runner.log`
