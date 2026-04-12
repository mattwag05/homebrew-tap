class RagQuest < Formula
  desc "AI-powered D&D-style text RPG with LightRAG knowledge graph backend"
  homepage "https://github.com/mattwag05/rag-quest"
  url "https://github.com/mattwag05/rag-quest/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "e2602ecf1808395c461e45b41e8b2a5f2d64bda6abf46230f83457246423b531"
  license "MIT"
  version "0.6.0"

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
