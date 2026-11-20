cask "texstudio@all2" do
  arch arm: "-m1"

  version "4.9.10"
  sha256 arm:   "9a780ba055b0e2296aa1ca45dd4e733bdd5ae4b28c7c000623777a2af9037a03",
         intel: "9449bad280c5ba45c81f3f0dbef330b00eb20b1e92dad00fd1ef29f36e2fdc1c"

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
  # more specifically, macOS 14.4 or higher, required by Qt 6.12.0
  # https://doc.qt.io/qt-6/macos.html
  # texstudio-org/texstudio@853b847 (update qt/poppler, 2026-10-09)
  depends_on macos: :sonoma

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
