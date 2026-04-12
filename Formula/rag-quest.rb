class RagQuest < Formula
  desc "AI-powered D&D-style text RPG with LightRAG knowledge graph backend"
  homepage "https://github.com/mattwag05/rag-quest"
  url "https://github.com/mattwag05/rag-quest/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "f6ef6f86ac90a911b26a498a5c09a4c8ff88a24dcebbdf396499695d8239cfe0"
  license "MIT"
  version "0.5.4"

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
