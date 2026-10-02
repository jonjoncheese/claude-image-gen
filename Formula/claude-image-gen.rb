# Homebrew formula. Install with:
#   brew tap jonjoncheese/claude-image-gen https://github.com/jonjoncheese/claude-image-gen
#   brew trust jonjoncheese/claude-image-gen
#   brew install claude-image-gen
class ClaudeImageGen < Formula
  desc "Generate images and videos with Google Flow from the command-line"
  homepage "https://github.com/jonjoncheese/claude-image-gen"
  url "https://raw.githubusercontent.com/jonjoncheese/claude-image-gen/v0.2.2/claude-image-gen.js"
  sha256 "f6970ddc92d1bbfd6620c44f7d108f123138cb2178efcdc3fb49464e1f9db3d6"
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
