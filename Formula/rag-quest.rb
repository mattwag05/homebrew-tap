class RagQuest < Formula
  desc "AI-powered D&D-style text RPG with LightRAG knowledge graph backend"
  homepage "https://github.com/mattwag05/rag-quest"
  url "https://github.com/mattwag05/rag-quest/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "19e1768cb02d97dbf7818feaa9e2b0acfe18d365abd299fa9cb4ac72d4dae0e3"
  license "MIT"

  depends_on "python@3.11"

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
