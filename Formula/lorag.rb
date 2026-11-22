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
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.8/lorag_0.1.8_darwin_arm64.tar.gz"
      sha256 "011568d3cc1255f9a0e156fa7a5ece30f1092c0635aecc928cf3316d6699f67c"
    end
    on_intel do
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.8/lorag_0.1.8_darwin_amd64.tar.gz"
      sha256 "f2175cc0140ca818abed9eca2e577de883e75e405155832601a8f366c34c743f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.8/lorag_0.1.8_linux_arm64.tar.gz"
      sha256 "09817370f9362e7dd28ef26cc535505ff333120184373e4e36ce25a846883f52"
    end
    on_intel do
      url "https://github.com/raucheacho/lorag/releases/download/v0.1.8/lorag_0.1.8_linux_amd64.tar.gz"
      sha256 "cd42e3d191c07957ce3b21d387374e1ba2df8ee515a2df586a8a465519b36413"
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
