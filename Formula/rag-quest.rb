class RagQuest < Formula
  desc "AI-powered D&D-style text RPG with LightRAG knowledge graph backend"
  homepage "https://github.com/mattwag05/rag-quest"
  url "https://github.com/mattwag05/rag-quest/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "05fe40588e30d0dc53f594bd6d6583060145eef85f857de90d2045bdc33e1607"
  license "MIT"
  version "0.5.6"

  depends_on "python@3.11"

  on_macos do
    depends_on "portaudio" # For pyttsx3 TTS support
  end

  def install
    python = Formula["python@3.11"].opt_bin/"python3.11"

    # Create isolated venv in libexec so dependencies don't pollute system Python
    system python, "-m", "venv", libexec
    system libexec/"bin/pip", "install", "--no-cache-dir", "."

    # The package defines a console_script entry point "rag-quest" — link it
    bin.install_symlink libexec/"bin/rag-quest"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rag-quest --help")
  end
end
