class Lorag < Formula
  desc "Local memory and search for AI agents, over MCP"
  homepage "https://github.com/raucheacho/lorag"
  license "MIT"

  # Local extraction: PDF pages, audio and video transcription, OCR.
  depends_on "ffmpeg"
  depends_on "poppler"
  depends_on "tesseract"
  depends_on "whisper.cpp"

  on_macos do
    on_arm do
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.5/lorag_0.1.5_darwin_arm64.tar.gz"
      sha256 "92b8e78584dce179af6dad37a928850cbdfb6335ee0aa00d93d99bc4ff24e3c7"
    end
    on_intel do
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.5/lorag_0.1.5_darwin_amd64.tar.gz"
      sha256 "e36b57215054adce69dc1eeebb30e4e6e99b1a9a3437e49562d5e300631292dc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.5/lorag_0.1.5_linux_arm64.tar.gz"
      sha256 "2edf167a04183d97aac5766e4c77a10ef34fedc020685fc88fa3a72fdc903f30"
    end
    on_intel do
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.5/lorag_0.1.5_linux_amd64.tar.gz"
      sha256 "ebc6c0000dae66ff0592fabf3bf43ff8e6137954ad93909c47011fa94932099c"
    end
  end

  def install
    bin.install "lorag", "loragctl"
    prefix.install_metafiles
    # install_metafiles already took LICENSE.vectixdb; NOTICE.vectixdb is left.
    prefix.install Dir["*.vectixdb"]
  end

  service do
    run [opt_bin/"lorag", "server"]
    keep_alive true
    # pdftotext, ffmpeg, whisper-cli and tesseract are found on this PATH.
    environment_variables PATH: std_service_path_env
    log_path var/"log/lorag.log"
    error_log_path var/"log/lorag.log"
  end

  def caveats
    <<~TEXT
      Lorag needs Ollama for embeddings (https://ollama.com):
        ollama pull bge-m3

      Data is stored in ~/.lorag/data. The Studio is on http://localhost:8080:
        lorag open
    TEXT
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lorag version")
    assert_match version.to_s, shell_output("#{bin}/loragctl version")
  end
end
