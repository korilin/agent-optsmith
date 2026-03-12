class Optsmith < Formula
  include Language::Python::Virtualenv

  desc "CLI for Agent Optsmith project skill installation and optimization workflow"
  homepage "https://github.com/korilin/agent-optsmith"
  url "https://github.com/korilin/agent-optsmith.git",
      branch: "main"
  version "0.2.1"
  license "MIT"

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "optsmith", shell_output("#{bin}/optsmith help")
  end
end
