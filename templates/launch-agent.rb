cask "circleci-launch-agent" do
  name "circleci-launch-agent"
  version "VERSION"
  desc "The launch agent to run CircleCI jobs"
  homepage "https://circleci.com/docs/2.0/runner-overview/"
  
  if Hardware::CPU.intel? 
    sha256 "AMD64SHA"
    url "https://circleci-binary-releases.s3.amazonaws.com/circleci-launch-agent/#{version}/darwin/amd64/circleci-launch-agent.tar.gz"
    binary "darwin/amd64/circleci-launch-agent"
  else
    sha256 "ARM64SHA"
    url "https://circleci-binary-releases.s3.amazonaws.com/circleci-launch-agent/#{version}/darwin/arm64/circleci-launch-agent.tar.gz"
    binary "darwin/arm64/circleci-launch-agent"
  end

end

