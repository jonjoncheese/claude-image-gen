# Homebrew formula. Install with:
#   brew tap jonjoncheese/claude-image-gen https://github.com/jonjoncheese/claude-image-gen
#   brew install claude-image-gen
class ClaudeImageGen < Formula
  desc "Generate images and videos with Google Flow from the command line"
  homepage "https://github.com/jonjoncheese/claude-image-gen"
  url "https://raw.githubusercontent.com/jonjoncheese/claude-image-gen/v0.2.0/claude-image-gen.js"
  version "0.2.0"
  sha256 "3093d96ee0a71b92803783d87837691b4b920f10b1085fb1f36d072e7ebae520"
  license "MIT"

  depends_on "node"

  def install
    libexec.install "claude-image-gen.js"
    (bin/"claude-image-gen").write <<~SH
      #!/bin/sh
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/claude-image-gen.js" "$@"
    SH
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/claude-image-gen --version").strip
  end
end
