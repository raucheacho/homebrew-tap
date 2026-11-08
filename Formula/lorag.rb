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
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.2/lorag_0.1.2_darwin_arm64.tar.gz"
      sha256 "346d8a36c3a0113cbd246009ceb270abaed580d07520fb9d1bdb4a507b9efa2a"
    end
    on_intel do
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.2/lorag_0.1.2_darwin_amd64.tar.gz"
      sha256 "e388087e53d74201162ed15089a5359214ac2f5208006fa36f630acc1d26e9f4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.2/lorag_0.1.2_linux_arm64.tar.gz"
      sha256 "a485bdf109da7772eb75c1d5eda20ee2064aeb06d25c1fea415514ee900caec3"
    end
    on_intel do
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.2/lorag_0.1.2_linux_amd64.tar.gz"
      sha256 "1256c5e5016bd70474153254689cb7bc4fd9cdc94ea03280615b6b9691eebb84"
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
