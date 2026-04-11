class RagQuest < Formula
  desc "AI-powered D&D-style text RPG with LightRAG knowledge graph backend"
  homepage "https://github.com/mattwag05/rag-quest"
  url "https://github.com/mattwag05/rag-quest/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "55343729d1a3e92505370f58ddb9d4e4aa8e799758627dd6502eec4a5decb18a"
  license "MIT"
  version "0.3.0"

  depends_on "python@3.11"
  
  on_macos do
    depends_on "portaudio"  # For pyttsx3 TTS support
  end

  def install
    # Use Python 3.11
    python = Formula["python@3.11"].opt_bin/"python3.11"
    system python, "-m", "pip", "install", "--upgrade", "pip"
    system python, "-m", "pip", "install", "--no-cache-dir", "."
    
    # Create a wrapper script for the rag-quest command
    (bin/"rag-quest").write_env_script(
      python,
      "-m rag_quest"
    )
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rag-quest --help")
  end
end
