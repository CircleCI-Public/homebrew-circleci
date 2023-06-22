cask "circleci-runner" do
  version "3.0.10"
  name "circleci-runner"
  desc "The self-hosted runner agent for CircleCI"
  homepage "https://circleci.com/docs/2.0/runner-overview/"
  
  if Hardware::CPU.intel? 
    sha256 "43ab488229917e8350b2bc6a7a660fb48a44e25d2e42e584fb18707ce49e8528"
    url "https://circleci-binary-releases.s3.amazonaws.com/circleci-runner/#{version}/circleci-runner_darwin_amd64.tar.gz"
    binary "circleci-runner"
  else
    sha256 "01baaa7f66e3683965c80a01d042ba9f7bdbc46cfbcf3e7df3dcbe15c650310f"
    url "https://circleci-binary-releases.s3.amazonaws.com/circleci-runner/#{version}/circleci-runner_darwin_arm64.tar.gz"
    binary "circleci-runner"
  end

  configDir = "#{Dir.home}/Library/Preferences/com.circleci.runner"
  configFile = "#{configDir}/config.yaml"
  workingDir = "#{Dir.home}/Library/com.circleci.runner/workdir"
  launchAgentDir = "#{Dir.home}/Library/LaunchAgents"
  plistFile = "#{launchAgentDir}/com.circleci.runner.plist"
  logDir = "#{Dir.home}/Library/Logs/com.circleci.runner"
  logFile = "#{logDir}/runner.log"


  postflight do

    if not File.exists?(configDir)
    system_command "mkdir", 
      args: ["-p", "#{configDir}"]
    end

    if not File.exists?(configFile)
      conf = "runner:
  name: <<RUNNER_NAME>>
  working_directory: \"#{workingDir}\"
  cleanup_working_directory: true
api:
  auth_token: <<RESOURCE_CLASS_TOKEN>>"

      File.open(configFile, "w"){|f| f.write "#{conf}"}
    end

    if not File.exists?(workingDir)
      system_command "mkdir",
        args: ["-p", workingDir]
    end

    # launchD configuartion
    if not File.exists?(launchAgentDir)
      system_command "mkdir",
        args: ["-p", launchAgentDir]
    end

    if not File.exists?(plistFile)
      plist = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple Computer//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
    <dict>
        <key>Label</key>
        <string>com.circleci.runner</string>

        <key>Program</key>
        <string>/opt/homebrew/bin/circleci-runner</string>

        <key>ProgramArguments</key>
        <array>
            <string>/opt/homebrew/bin/circleci-runner</string>
            <string>machine</string>
            <string>--config</string>
            <string>#{configFile}</string>
        </array>

        <key>RunAtLoad</key>
        <true/>

        <!-- The agent needs to run at all times -->
        <key>KeepAlive</key>
        <true/>

        <!-- This prevents macOS from limiting the resource usage of the agent -->
        <key>ProcessType</key>
        <string>Interactive</string>

        <!-- Increase the frequency of restarting the agent on failure, or post-update -->
        <key>ThrottleInterval</key>
        <integer>3</integer>

        <!-- Wait for 10 minutes for the agent to shut down (the agent itself waits for tasks to complete) -->
        <key>ExitTimeOut</key>
        <integer>600</integer>

        <key>StandardOutPath</key>
        <string>#{logFile}</string>
        <key>StandardErrorPath</key>
        <string>#{logFile}</string>
    </dict>
</plist>"

    File.open(plistFile, "w"){|f|f.write "#{plist}"}
    end

    if not File.exists?(logDir)
      system_command "mkdir",
        args: ["-p", logDir]
    end

  end

  def caveats;  
    "Logs: #{Dir.home}/Library/Logs/com.circleci.runner
Config: #{Dir.home}/Library/Preferences/com.circleci.runner/config.yaml
Documentation: https://circleci.com/docs/runner-overview/
CircleCI Self-Hosted Runner Changelog: https://circleci.com/changelog/self-hosted-runner/
Before Running:
  To check application notarization run `spctl -a -vvv -t install /opt/homebrew/bin/circleci-runner`

  To accept the notarization headlessly run `sudo xattr -r -d com.apple.quarantine /opt/homebrew/bin/circleci-runner`

  Update the configration with your self-hosted runner token and runner name before starting

  Enable and Start LaunchAgent with `launchctl enable #{Dir.home}/Library/LaunchAgents/com.circleci.runner.plist`"
  end

  zap trash:[
    "#{configDir}/*",
    "#{configDir}",
    "#{plistFile}",
    "#{logDir}/*",
    "#{logDir}",
    "#{workingDir}/*",
  ]

  uninstall launchctl: "com.circleci.runner"
    

end
