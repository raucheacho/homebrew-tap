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
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.6/lorag_0.1.6_darwin_arm64.tar.gz"
      sha256 "bc00a7dea7c430109282f336a202cc5616753156ac1f544b931c4dca77773137"
    end
    on_intel do
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.6/lorag_0.1.6_darwin_amd64.tar.gz"
      sha256 "591bbb309b67cc00243470b9b2ac192809d7bb913fff7764f3877b640671ee14"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.6/lorag_0.1.6_linux_arm64.tar.gz"
      sha256 "4755983b08e748f55d446f7ed6e7bebef5861c66fac99d3235ae88947a2dbdad"
    end
    on_intel do
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.6/lorag_0.1.6_linux_amd64.tar.gz"
      sha256 "2121cff795a1c6bcc9af8463f28de459605fb8d9841d4acdc2b0583215ff1e48"
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
