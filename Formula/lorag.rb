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
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.9/lorag_0.1.9_darwin_arm64.tar.gz"
      sha256 "0e4a68d56387e88521eedabdb5151c296c4b8ae6a8d716139d87a63730e56eb3"
    end
    on_intel do
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.9/lorag_0.1.9_darwin_amd64.tar.gz"
      sha256 "5ecc3cc98daf89ffa01818c9822e86b4c6d3ee8cfb095e2ee0a6d5301278d6cb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.9/lorag_0.1.9_linux_arm64.tar.gz"
      sha256 "5744e022f9c1504ced29a185777c8d8ac973cd1d9b4c767912797854f0d6a80b"
    end
    on_intel do
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.9/lorag_0.1.9_linux_amd64.tar.gz"
      sha256 "d0bacd9d8881028b324849e106b3a0c140553f71bc93ea6090e45f0063563bfc"
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

      Data is stored in ~/.lorag/data. The Studio is on http://localhost:7411:
        lorag open
    TEXT
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lorag version")
    assert_match version.to_s, shell_output("#{bin}/loragctl version")
  end
end
