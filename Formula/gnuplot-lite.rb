class GnuplotLite < Formula
  desc "GnuPlot without Qt terminal support"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/6.0.4/gnuplot-6.0.4.tar.gz"
  sha256 "458d94769625e73d5f6232500f49cbadcb2b183380d43d2266a0f9701aeb9c5b"
  license "gnuplot"

  livecheck do
    url :stable
    regex(%r{url=.*?/gnuplot[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/muzimuzhi/beta"
    sha256 arm64_tahoe:  "91393d0bf082c4ddbbd49d8f61af0c3e4b9cf507046adbf5b07110c6a6cc6d2a"
    sha256 x86_64_linux: "2578d9a937c77b68c3d0f924d60a4785aeaa70d798b4358a346916ef5580b0dc"
  end

  head do
    url "https://git.code.sf.net/p/gnuplot/gnuplot-main.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gd"
  depends_on "glib"
  depends_on "libcerf"
  depends_on "lua"
  depends_on "pango"
  depends_on "readline"
  depends_on "webp"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  # https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/g/gnuplot.rb
  conflicts_with "gnuplot", because: "both install the same-named executables"

  def install
    # https://sourceforge.net/p/gnuplot/gnuplot-main/ci/master/tree/configure.ac
    args = %W[
      --disable-silent-rules
      --with-readline=#{Formula["readline"].opt_prefix}
      --disable-wxwidgets
      --with-qt=no
      --without-x
      --without-latex
    ]

    ENV.append "CXXFLAGS", "-std=c++17" # needed for Qt 6
    system "./prepare" if build.head?
    system "./configure", *args, *std_configure_args.reject { |s| s["--disable-debug"] }
    ENV.deparallelize # or else emacs tries to edit the same file with two threads
    system "make"
    system "make", "install"
  end

  test do
    system bin/"gnuplot", "-e", <<~EOS
      set terminal dumb;
      set output "#{testpath}/graph.txt";
      plot sin(x);
    EOS
    assert_path_exists testpath/"graph.txt"
  end
end
