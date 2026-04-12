class RagQuest < Formula
  desc "AI-powered D&D-style text RPG with LightRAG knowledge graph backend"
  homepage "https://github.com/mattwag05/rag-quest"
  url "https://github.com/mattwag05/rag-quest/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "4a261f83447cec685891887dc8d956dbacae69eecbbfef6b40a050fef8b0d1f5"
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
