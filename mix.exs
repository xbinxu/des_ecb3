defmodule Mix.Tasks.Compile.Desecb3 do
  @shortdoc "Compiles DesEcb3"

  def run(_) do
    File.mkdir("priv")
    {exec, args} = case :os.type do
      {:win32, _} ->
        {"nmake", ["/F", "Makefile.win", "priv\\desecb3_nif.dll"]}
      {:unix, :freebsd} ->
        {"gmake", ["priv/desecb3_nif.so"]}
      {:unix, :openbsd} ->
        {"gmake", ["priv/desecb3_nif.so"]}
      _ ->
        {"make", ["priv/desecb3_nif.so"]}
    end

    if System.find_executable(exec) do
      build(exec, args)
    else
      nocompiler_error(exec)
    end
  end

  def build(exec, args) do
    {result, error_code} = System.cmd(exec, args, stderr_to_stdout: true)
    if error_code != 0, do: build_error(exec), else: IO.binwrite result
  end

  defp nocompiler_error("nmake") do
    raise Mix.Error, message: nocompiler_message("nmake") <> windows_message
  end
  defp nocompiler_error(exec) do
    raise Mix.Error, message: nocompiler_message(exec) <> nix_message
  end

  defp build_error("nmake") do
    raise Mix.Error, message: build_message <> windows_message
  end
  defp build_error(_) do
    raise Mix.Error, message: build_message <> nix_message
  end

  defp nocompiler_message(exec) do
    """
    Could not find the program `#{exec}`.

    You will need to install the C compiler `#{exec}` to be able to build
    Desecb3.

    """
  end

  defp build_message do
    """
    Could not compile Desecb3.

    Please make sure that you are using Erlang / OTP version 17.0 or later
    and that you have a C compiler installed.

    """
  end

  defp windows_message do
    """
    One option is to install a recent version of Visual Studio (the
    free Community edition will be enough for this task). Then try running
    `mix deps.compile comeonin` from the `Developer Command Prompt`. If
    you are using 64-bit erlang, you might need to run the command
    `vcvarsall.bat amd64` before running `mix deps.compile`. Further
    information can be found at
    (https://msdn.microsoft.com/en-us/library/x4d2c09s.aspx).

    """
  end

  defp nix_message do
    """
    Please follow the directions below for the operating system you are
    using:

    Mac OS X: You need to have gcc and make installed. Try running the
    commands `gcc --version` and / or `make --version`. If these programs
    are not installed, you will be prompted to install them.

    Linux: You need to have gcc and make installed. If you are using
    Ubuntu or any other Debian-based system, install the packages
    `build-essential`. Also install `erlang-dev` package if not
    included in your Erlang/OTP version.

    """
  end
end

defmodule DesEcb3.Mixfile do
  use Mix.Project

  def project do
    [app: :des_ecb3,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     compilers: [:desecb3, :elixir, :app],
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    []
  end

end
