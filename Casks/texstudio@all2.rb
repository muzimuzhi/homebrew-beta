cask "texstudio@all2" do
  arch arm: "-m1"

  version "4.9.8rc2"
  sha256 arm:   "aab12c8b8b4068ced6cda0ac715c2cff75112256f91173fbe752c0162eb2df41",
         intel: "596b3316598ec92c940dd485d16f3b51bfcba8f4ca08b44c93d0c9fe8dfc2ecf"

  url "https://github.com/texstudio-org/texstudio/releases/download/#{version}/texstudio-#{version}-osx#{arch}.zip"
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

  conflicts_with cask: [
    "Homebrew/cask/texstudio",
    "texstudio-org/texstudio/texstudio",
    "texstudio-org/texstudio/texstudio@all",
    "texstudio-org/texstudio/texstudio@beta",
  ]
  depends_on macos: :ventura

  app "texstudio-#{version}-osx#{arch}.app"

  postflight_steps do
    run "xattr",
        args: ["-dr", "com.apple.quarantine", "{{appdir}}/texstudio-{{version}}-osx{{arch}}.app"]
  end

  uninstall quit: "texstudio"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/texstudio.sfl*",
    "~/Library/Preferences/texstudio.plist",
    "~/Library/Saved Application State/texstudio.savedState",
  ]
end
