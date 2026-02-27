# Homebrew tap `muzimuzhi/beta`

Due to too few downloads, on 5 May 2020, cask `texstudio-beta` (2.12.22beta2) was [removed] from [`homebrew-cask-version`][homebrew-cask-version], the official repo for pre-release casks.

So there is this homebrew tap.

## Quick actions

```bash
# installation
# note that `texstudio-beta` conflicts with `texstudio`
brew install muzimuzhi/beta/texstudio-beta

# formula upgrading
brew bump-formula-pr muzimuzhi/beta/FORMULA --version=VERSION [--write-only]

# cask upgrading
brew bump-cask-pr muzimuzhi/beta/CASK --version=VERSION [--write-only]

# check out latest tap workflows
brew tap-new --github-packages --no-git USER/REPO
```

## Helpful links

- TeXstudio’s release page \
  https://github.com/texstudio-org/texstudio/releases/
- Homebrew commands
  - `brew bump-formula-pr` \
    https://docs.brew.sh/Manpage#bump-formula-pr-options-formula
  - `brew bump-cask-pr` \
    https://docs.brew.sh/Manpage#bump-cask-pr-options-cask
  - `brew tap-new` \
    https://docs.brew.sh/Manpage#tap-new-options-userrepo
- Syncing with upstream
  - Workflow generator in Homebrew/brew \
    `brew tap-new` uses it to generate `.github/workflows/{tests,publish}.yml` \
    https://github.com/Homebrew/brew/blob/master/Library/Homebrew/dev-cmd/tap-new.rb
  - `texstudio.rb` from Homebrew/homebrew-cask \
    https://github.com/Homebrew/homebrew-cask/blob/HEAD/Casks/t/texstudio.rb
- More Homebrew documentation
  - Cask stanzas \
    https://docs.brew.sh/Adding-Software-to-Homebrew#cask-stanzas
  - Commit message rules \
    https://docs.brew.sh/Adding-Software-to-Homebrew#commit-messages
  - How to create and maintain a Tap \
    https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap
  - Homebrew tap with bottles uploaded to GitHub Releases \
    https://brew.sh/2020/11/18/homebrew-tap-with-bottles-uploaded-to-github-releases/

[removed]:
    https://github.com/Homebrew/homebrew-cask-versions/commit/4f03b850c8ca7407b42490a3a53c1c215ebc6d5d
[homebrew-cask-version]:
    https://github.com/Homebrew/homebrew-cask-versions
