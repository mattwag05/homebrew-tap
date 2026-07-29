class Pippin < Formula
  desc "macOS CLI toolkit for Apple app automation"
  homepage "https://github.com/mattwag05/pippin"
  # Stable installs use the PRE-SIGNED release tarball (Developer ID, signed at
  # release time by `make tarball`), NOT a from-source build. Homebrew's build
  # sandbox has no login-keychain access, so it cannot Developer-ID-sign — a
  # source build would land ad-hoc. The pre-signed binary gives a stable code
  # identity (Gatekeeper + a deterministic TCC client). (pippin-jt9)
  #
  # NOTE (pippin-6sf, corrects the earlier "grants persist" claim): macOS keys a
  # bare-CLI TCC grant on the binary's RESOLVED PATH, and this formula's bin is a
  # symlink into the VERSIONED Cellar path — so brew TCC grants are re-prompted on
  # every `brew upgrade`. Signing only gives cdhash-independent persistence at a
  # STABLE path. For durable Reminders/Calendar/Mail access (agents, scheduled
  # tasks), use `~/.local/bin/pippin` (stable copied path via `make install`).
  # pippin v0.31.0+ also re-execs disclaimed so the grant keys on its own identity
  # regardless of launcher (pippin-0vr).
  url "https://github.com/mattwag05/pippin/releases/download/v0.36.1/pippin-0.36.1-arm64-macos.tar.gz"
  version "0.36.1"
  sha256 "9fd651a10b8494dd7e38fc53f86ef443d1459088d7b1471c5c01a73615dfa71d"
  license "Apache-2.0"

  # `--HEAD` builds from source (for development). That path is ad-hoc/best-effort
  # signed (the sandbox keychain limitation above), so `brew install --HEAD`
  # binaries won't have persistent TCC grants — use a tagged release for that.
  head do
    url "https://github.com/mattwag05/pippin.git", branch: "main"
    depends_on xcode: ["16.0", :build]
  end

  # Pinned alongside AudioBridge.pinnedMLXAudioVersion — keep in sync.
  MLX_AUDIO_PINNED = "0.4.2".freeze

  depends_on arch: :arm64
  depends_on :macos

  def install
    if build.head?
      system "swift", "build",
             "--disable-sandbox",
             "-c", "release",
             "--scratch-path", buildpath/".build"
      sign_script = buildpath/"scripts/sign.sh"
      system "bash", sign_script, buildpath/".build/release/pippin" if File.exist?(sign_script)
      bin.install buildpath/".build/release/pippin"
    else
      bin.install "pippin-#{version}-arm64-macos" => "pippin"
    end
    # Belt-and-suspenders: brew downloads aren't quarantined, but strip the attr
    # if present so the signed binary never trips Gatekeeper on first run.
    quiet_system "/usr/bin/xattr", "-d", "com.apple.quarantine", bin/"pippin"
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
    assert_match version.to_s, shell_output("#{bin}/pippin --version")
    # The published binary must carry a stable (non-ad-hoc) Developer ID
    # signature — required for a deterministic TCC client identity + Gatekeeper.
    # (Grant persistence across upgrades needs a stable PATH, not just signing —
    # see the header note / pippin-6sf.)
    assert_match "Developer ID Application",
                 shell_output("/usr/bin/codesign -dvv #{bin}/pippin 2>&1")
  end
end
