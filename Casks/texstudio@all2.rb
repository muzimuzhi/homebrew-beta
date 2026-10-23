cask "texstudio@all2" do
  arch arm: "-m1"

  version "4.9.9"
  sha256 arm:   "6e1814b234fc6a018fcca62f847f95badd2437bfb2baddcffab3d430ac861f46",
         intel: "485e79c6d7ceb588002ba33ea1bbc9513352fcdd22f27a75704bb54a344de176"

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
