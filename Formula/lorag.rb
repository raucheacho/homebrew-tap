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
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.7/lorag_0.1.7_darwin_arm64.tar.gz"
      sha256 "f4a14ffa1fb0ba9852ed7370d141152aafe760f47620021c6d7d05c8c3b5c889"
    end
    on_intel do
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.7/lorag_0.1.7_darwin_amd64.tar.gz"
      sha256 "55bd220b95675db665e43447e28b024378240218bf1e0f21d846052915fd0ea7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.7/lorag_0.1.7_linux_arm64.tar.gz"
      sha256 "fba279f02186b3c3f443fef0ebfeb8c1ce0f9e4aef2e4aa574e828599024390c"
    end
    on_intel do
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.7/lorag_0.1.7_linux_amd64.tar.gz"
      sha256 "9d9f3ae55c3ad90c5a5635c042eb59225ba1a4977ee58db6d0bbfdbfad672266"
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
