cask "circleci-launch-agent" do
  name "circleci-launch-agent"
  version "1.0.21908-c8e0213"
  desc "The launch agent to run CircleCI jobs"
  homepage "https://circleci.com/docs/2.0/runner-overview/"
  
  if Hardware::CPU.intel? 
    sha256 "ae097dd3ec9367438e306a6c0c8e6046a41448ff05a4da7fad52245fb54aabff"
    url "https://circleci-binary-releases.s3.amazonaws.com/circleci-launch-agent/#{version}/darwin/amd64/circleci-launch-agent.tar.gz"
    binary "darwin/amd64/circleci-launch-agent"
  else
    sha256 "cae50ae092fc37b6f8ae73be593eddee85fad0945c7ab47f1c1cbefd448eaf7b"
    url "https://circleci-binary-releases.s3.amazonaws.com/circleci-launch-agent/#{version}/darwin/arm64/circleci-launch-agent.tar.gz"
    binary "darwin/arm64/circleci-launch-agent"
  end

end
