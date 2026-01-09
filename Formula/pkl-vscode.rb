class PklVscode < Formula
  desc "VS Code extension for pkl language support"
  homepage "https://github.com/apple/pkl-vscode"
  url "https://github.com/apple/pkl-vscode/releases/download/0.21.0/pkl-vscode-0.21.0.vsix", using: :nounzip
  sha256 "e9444b3f91bb53d57ba78e9b8761286941f1e43a7b0fd43e863b344c69d7eb49"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/pkl-vscode[._-]v?(\d+(?:\.\d+)+)\.vsix}i)
  end

  def install
    prefix.install Dir["*"]

    system "/usr/local/bin/code", "--install-extension", "#{prefix}/pkl-vscode-0.21.0.vsix"
  end

  def uninstall
    system "/usr/local/bin/code", "--uninstall-extension", "Pkl.pkl-vscode"
  end
end
