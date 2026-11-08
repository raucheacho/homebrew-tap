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
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.3/lorag_0.1.3_darwin_arm64.tar.gz"
      sha256 "97894814424e3d348765b29355fe6dac48f18f1e669ae2f73918b50b14b9ef61"
    end
    on_intel do
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.3/lorag_0.1.3_darwin_amd64.tar.gz"
      sha256 "6e5ca5509b49129cbc20c53d8aa560731fd2b93af8c178d20641849b84116d38"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.3/lorag_0.1.3_linux_arm64.tar.gz"
      sha256 "7e927d9138f65b0c4c4875470626e16e416ef574c5a6d63a12a57f8b6debe017"
    end
    on_intel do
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.3/lorag_0.1.3_linux_amd64.tar.gz"
      sha256 "d78f91e7bc432a57b090e3a131ab0580f5a9b7449bc108fa2e961c5dd7042c13"
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
