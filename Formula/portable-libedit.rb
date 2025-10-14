require File.expand_path("../Abstract/portable-formula", __dir__)

class PortableLibedit < PortableFormula
  desc "BSD-style licensed readline alternative"
  homepage "https://thrysoee.dk/editline/"
  url "https://thrysoee.dk/editline/libedit-20221009-3.1.tar.gz"
  version "20221009-3.1"
  sha256 "b7b135a5112ce4344c9ac3dff57cc057b2b0e1b912619a36cf1d13fce8e88626"
  license "BSD-3-Clause"

  on_linux do
    depends_on "portable-ncurses" => :build
  end

  def install
    system "./configure",
      *std_configure_args,
      "--enable-static",
      "--disable-shared",
      "--disable-examples"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <histedit.h>
      int main(int argc, char *argv[]) {
        EditLine *el = el_init(argv[0], stdin, stdout, stderr);
        return (el == NULL);
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ledit", "-I#{include}"
    system "./test"
  end
end
