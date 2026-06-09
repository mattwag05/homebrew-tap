class Pippin < Formula
  desc "macOS CLI toolkit for Apple app automation"
  homepage "https://github.com/mattwag05/pippin"
  url "https://github.com/mattwag05/pippin.git",
      tag:      "v0.29.0",
      revision: "c00e52327d135640887dc54b482f289b1e55fa8a"
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
    # Best-effort stable-identity signing so macOS TCC grants persist. NOTE:
    # Homebrew's build sandbox has no login-keychain access, so sign.sh usually
    # finds no Developer ID identity and falls back to ad-hoc here — brew-built
    # pippin is typically ad-hoc, and `~/.local/bin/pippin` (from `make install`)
    # is the signed path that shadows it on PATH. Re-sign the brew copy with
    # `bash scripts/sign.sh "$(brew --prefix)/bin/pippin"` if you need it.
    # Guarded twice (File.exist? for old tags + sign.sh's ad-hoc fallback) so the
    # install never fails. See docs/gotchas/permissions.md (pippin-xzu, pippin-jt9).
    sign_script = buildpath/"scripts/sign.sh"
    system "bash", sign_script, buildpath/".build/release/pippin" if File.exist?(sign_script)
    bin.install buildpath/".build/release/pippin"
  end

  def post_install
    pipx = which("pipx")
    if pipx.nil?
      ohai "pipx not found — skipping mlx-audio install."
      ohai "For \`pippin memos transcribe\`, run:"
      ohai "  brew install pipx && pipx install 'mlx-audio==#{MLX_AUDIO_PINNED}'"
      return
    end
    # --force keeps reinstalls idempotent across pippin upgrades.
    system pipx, "install", "--force", "mlx-audio==#{MLX_AUDIO_PINNED}"
  end

  test do
    assert_match "0.29.0", shell_output("#{bin}/pippin --version")
  end
end
