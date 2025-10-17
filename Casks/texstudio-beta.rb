cask "texstudio-beta" do
  # work around https://github.com/Homebrew/homebrew-cask/issues/205491
  # see also https://github.com/orgs/Homebrew/discussions/6008#discussioncomment-12440672
  on_macos do
    arch arm: "-m1"

    version "4.9.0beta3"
    sha256 arm:   "153d3aee1ba21448851bb52b6e7c014b57d14a96dd3224f77e5b6f8dff91b6d7",
           intel: "b7a26f48d69293ce45e4c949608401c43838c583e196692851f8c719e35f1133"

    depends_on macos: ">= :ventura"

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
