cask "texstudio@all" do
  arch arm: "-m1"

  version "4.9.7"
  sha256 arm:   "5ac66e53c7cfab83621e50db3287edc7f977b2e5259806949a3915090f1898b1",
         intel: "13ef12b15c44d3cd44b58a24a5ba8ef1b5dd1304d7b67e2a0e8ba3ec0868db07"

  url "https://github.com/texstudio-org/texstudio/releases/download/#{version}/texstudio-#{version}-osx#{arch}.zip",
      verified: "github.com/texstudio-org/texstudio/"
  name "TeXstudio"
  desc "Fully featured LaTeX editor, both stable and beta versions"
  homepage "https://texstudio.org/"

  livecheck do
    url :url
    regex(/
      ^v?(\d+(?:\.\d+)+            # version number
      (?:(?:alpha|beta|rc)\d+)?)$  # optional pre-release identifier
    /ix)
    strategy :github_releases do |json, regex|
      json.map do |release|
        # accept both pre-releases and stable releases
        next if release["draft"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  conflicts_with cask: "texstudio"
  conflicts_with cask: "texstudio@beta"
  depends_on macos: :ventura

  app "texstudio-#{version}-osx#{arch}.app"

  postflight do
    system_command "xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/texstudio-#{version}-osx#{arch}.app"]
  end

  uninstall quit: "texstudio"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/texstudio.sfl*",
    "~/Library/Preferences/texstudio.plist",
    "~/Library/Saved Application State/texstudio.savedState",
  ]
end
