class Pippin < Formula
  desc "macOS CLI toolkit for Apple app automation"
  homepage "https://github.com/mattwag05/pippin"
  url "https://github.com/mattwag05/pippin.git",
      tag:      "v0.3.1",
      revision: "bdd4a9cd194423a836e1c96b2d6927dcd99c67dd"
  license "Apache-2.0"
  head "https://github.com/mattwag05/pippin.git", branch: "main"

  depends_on xcode: ["16.0", :build]
  depends_on :macos

  def install
    system "swift", "build",
           "--disable-sandbox",
           "-c", "release",
           "--scratch-path", buildpath/".build"
    bin.install buildpath/".build/release/pippin"
  end

  test do
    assert_match "0.3.1", shell_output("#{bin}/pippin --version")
  end
end
