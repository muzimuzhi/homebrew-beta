cask "texstudio-beta" do
  # work around https://github.com/Homebrew/homebrew-cask/issues/205491
  # see also https://github.com/orgs/Homebrew/discussions/6008#discussioncomment-12440672
  on_macos do
    arch arm: "-m1"

    version "4.8.9rc1"
    sha256 arm:   "ffa931cad880abd3d0140ed14f39481851e1411340ac62c114fe28d01d790726",
           intel: "332b017079c1f861a4564f131a18775a32763ac75cde710a3fbb454c2fa8b71f"

    on_arm do
      depends_on macos: ">= :sonoma"
    end
    on_intel do
      depends_on macos: ">= :big_sur"
    end

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

    conflicts_with cask: "texstudio"

    # it's NOT recommended to rename the target only for removing version numbers
    # https://docs.brew.sh/Cask-Cookbook#target-should-only-be-used-in-select-cases
    app "texstudio-#{version}-osx#{arch}.app"

    zap trash: [
      "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/texstudio.sfl*",
      "~/Library/Preferences/texstudio.plist",
      "~/Library/Saved Application State/texstudio.savedState",
    ]
  end
end
