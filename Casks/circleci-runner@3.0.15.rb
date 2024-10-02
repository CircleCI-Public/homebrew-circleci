cask "circleci-runner@3.0.15" do
  version "3.0.15"
  name "circleci-runner"
  desc "The self-hosted runner agent for CircleCI"
  homepage "https://circleci.com/docs/2.0/runner-overview/"

  intelSHA = "51d952491d74d8ca735b8886a553b1d6dd4600539ea09fb8d72238c7dedb0384"
  armSHA = "00768920f6830ef6dec00eb50f744892c683d1549d4ad7927433d8b5737007a6"
  
  if Hardware::CPU.intel? 
    sha256 "#{intelSHA}"
    url "https://circleci-binary-releases.s3.amazonaws.com/circleci-runner/#{version}/circleci-runner_darwin_amd64.tar.gz"
    binary "circleci-runner"
  else
    sha256 "#{armSHA}"
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

  prefix = ENV["HOMEBREW_PREFIX"]
  service "#{Dir.home}/Library/LaunchAgents/com.circleci.runner.plist"

  preflight do
    if not File.exist?(plistFile)
      plist = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple Computer//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
    <dict>
        <key>Label</key>
        <string>com.circleci.runner</string>

        <key>Program</key>
        <string>#{prefix}/bin/circleci-runner</string>

        <key>ProgramArguments</key>
        <array>
            <string>#{prefix}/bin/circleci-runner</string>
            <string>machine</string>
            <string>--config</string>
            <string>#{configFile}</string>
        </array>

        <key>RunAtLoad</key>
        <true/>

        	<key>LimitLoadToSessionType</key>
	       <array>
            <!-- start agent during GUI sessions -->
	         <string>Aqua</string>
            <!-- start agent during ssh sessions -->
	         <string>StandardIO</string>
	         <string>Background</string>
	       </array>

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
  end


  postflight do
    if not File.exist?(configDir)
    system_command "mkdir", 
      args: ["-p", "#{configDir}"]
    end

    if not File.exist?(configFile)
      conf = "runner:
  name: [[RUNNER_NAME]]
  working_directory: \"#{workingDir}\"
  cleanup_working_directory: true
api:
  auth_token: [[RESOURCE_CLASS_TOKEN]]"

      File.open(configFile, "w"){|f| f.write "#{conf}"}
    end

    if not File.exist?(workingDir)
      system_command "mkdir",
        args: ["-p", workingDir]
    end

    # launchD configuartion
    if not File.exist?(launchAgentDir)
      system_command "mkdir",
        args: ["-p", launchAgentDir]
    end


    if not File.exist?(logDir)
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
  To check application notarization run `$ spctl -a -vvv -t install \"$(brew --prefix)/bin/circleci-runner\"`

  To accept the notarization headlessly run `$ sudo xattr -r -d com.apple.quarantine \"$(brew --prefix)/bin/circleci-runner\"`

  Update the configration with your self-hosted runner token and runner name before starting

  Enable and Start the CircleCI Runner LaunchAgent with `$ launchctl load #{Dir.home}/Library/LaunchAgents/com.circleci.runner.plist`
  Start CircleCI Runner manually with `$ circleci-runner machine --config #{Dir.home}/Library/Preferences/com.circleci.runner/config.yaml`
  View the CircleCI Runner logs at #{Dir.home}/Library/Logs/com.circleci.runner/runner.log"
  
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
