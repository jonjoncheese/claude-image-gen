# Homebrew formula. Install with:
#   brew tap jonjoncheese/claude-image-gen https://github.com/jonjoncheese/claude-image-gen
#   brew trust jonjoncheese/claude-image-gen
#   brew install claude-image-gen
class ClaudeImageGen < Formula
  desc "Generate images and videos with Google Flow from the command-line"
  homepage "https://github.com/jonjoncheese/claude-image-gen"
  url "https://raw.githubusercontent.com/jonjoncheese/claude-image-gen/v0.2.1/claude-image-gen.js"
  sha256 "d292407e909427278aa9137e528777603db3762943a9cac8e4da93016258c8af"
  license "MIT"

  depends_on "node"

  def install
    libexec.install "claude-image-gen.js"
    (bin/"claude-image-gen").write <<~SH
      #!/bin/sh
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/claude-image-gen.js" "$@"
    SH
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/claude-image-gen --version").strip
  end
end
