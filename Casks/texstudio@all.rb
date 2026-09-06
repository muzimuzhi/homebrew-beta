cask "texstudio@all" do
  arch arm: "-m1"

  version "4.9.8beta2"
  sha256 arm:   "a405c998ec2d121a46c3edb9aa344187c5466d90ac341d8cbe401a87ac9f0534",
         intel: "5e0c2effd3c12ae2aee266349deb082ff98d8d5b16de84621a850f3367330135"

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
