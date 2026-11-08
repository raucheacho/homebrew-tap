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
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.4/lorag_0.1.4_darwin_arm64.tar.gz"
      sha256 "13a83e7f387d962cfe93e1a0f7f7788f68e44f92d26c936483df3b2fcafb0f83"
    end
    on_intel do
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.4/lorag_0.1.4_darwin_amd64.tar.gz"
      sha256 "c213a61e89e35b5d3174b55338a8ea8671265b5329cb4570f7e956f928c5333e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.4/lorag_0.1.4_linux_arm64.tar.gz"
      sha256 "7b1c13f04d655db36baf157cda20078f9d4b4a10e8b8f9e5caadfb9bc2904b4c"
    end
    on_intel do
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.4/lorag_0.1.4_linux_amd64.tar.gz"
      sha256 "5ec42d09e8759f015a5ddd970e74a507f1049f6ebb49f235746c373520a1ef37"
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
