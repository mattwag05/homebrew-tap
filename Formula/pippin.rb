class Pippin < Formula
  desc "macOS CLI toolkit for Apple app automation"
  homepage "https://github.com/mattwag05/pippin"
  url "https://github.com/mattwag05/pippin.git",
      tag:      "v0.19.0",
      revision: "212dc5fdf4c54054cc436f79018f6635e7467de8"
  license "Apache-2.0"
  head "https://github.com/mattwag05/pippin.git", branch: "main"

  # Pinned alongside AudioBridge.pinnedMLXAudioVersion — keep in sync.
  MLX_AUDIO_PINNED = "0.4.2"

  depends_on xcode: ["16.0", :build]
  depends_on :macos

  def install
    system "swift", "build",
           "--disable-sandbox",
           "-c", "release",
           "--scratch-path", buildpath/".build"
    bin.install buildpath/".build/release/pippin"
  end

  def post_install
    pipx = which("pipx")
    if pipx.nil?
      ohai "pipx not found — skipping mlx-audio install."
      ohai "For `pippin memos transcribe`, run:"
      ohai "  brew install pipx && pipx install 'mlx-audio==#{MLX_AUDIO_PINNED}'"
      return
    end
    # --force keeps reinstalls idempotent across pippin upgrades.
    system pipx, "install", "--force", "mlx-audio==#{MLX_AUDIO_PINNED}"
  end

  test do
    assert_match "0.19.0", shell_output("#{bin}/pippin --version")
  end
end
