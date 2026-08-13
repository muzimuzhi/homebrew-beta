# texstudio cask: https://github.com/Homebrew/homebrew-cask/blob/HEAD/Casks/t/texstudio.rb

cask "texstudio-beta" do
  arch arm: "-m1"

  version "4.9.7rc1"
  sha256 arm:   "cf015fbb57feb7043779c249e0a2724ea1bc5c01a350b5e3d78907bad47dc3fa",
         intel: "7f155d7e81f5af43d6eefc4ed223d4245d9967c62ac07146647bf71816d2d6d4"

  url "https://github.com/texstudio-org/texstudio/releases/download/#{version}/texstudio-#{version}-osx#{arch}.zip",
      verified: "github.com/texstudio-org/texstudio/"
  name "TeXstudio"
  desc "Fully featured LaTeX editor, beta version"
  homepage "https://texstudio.org/"

  livecheck do
    # based on https://docs.brew.sh/Brew-Livecheck#githubreleases-strategy-block
    url :url
    regex(/^v?(\d+(?:\.\d+)+(?:(?:alpha|beta|rc)\d+)?)$/i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
    # :page_match can just list pre-releases
    # learnt from https://github.com/Homebrew/homebrew-cask-versions/blob/948fe36253038658716087daac8c4b1f0ae0f7c3/Casks/utm-beta.rb#L11-L15
    #   url "https://github.com/texstudio-org/texstudio/releases?q=prerelease%3Atrue&expanded=true"
    #   regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+[^"' >]*)["' >]}i)
    #   strategy :page_match
  end

  # "texstudio-beta" does not conflict with cask "texstudio" due to different
  # version string in the app name, so no `conflicts_with` stanza is needed.
  depends_on macos: :ventura

  # It's NOT recommended to rename the target only for removing version numbers.
  # https://docs.brew.sh/Cask-Cookbook#target-should-only-be-used-in-select-cases
  app "texstudio-#{version}-osx#{arch}.app"

  # learnt from https://github.com/Homebrew/homebrew-cask/blob/03a0edb4616198f6f64b285dbf842bc3b73a7f31/Casks/p/parallels.rb#L36-L41
  postflight do
    system_command "xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/texstudio-#{version}-osx#{arch}.app"]
  end

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/texstudio.sfl*",
    "~/Library/Preferences/texstudio.plist",
    "~/Library/Saved Application State/texstudio.savedState",
  ]
end
