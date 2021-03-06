using BinaryProvider

# This is where all binaries will get installed
const prefix = Prefix(!isempty(ARGS) ? ARGS[1] : joinpath(@__DIR__,"usr"))

libcalceph = LibraryProduct(prefix, "libcalceph")

products = [libcalceph]


# Download binaries from hosted location
bin_prefix = "https://github.com/JuliaAstro/CALCEPHBuilder/releases/download/v3.0.0"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    BinaryProvider.Linux(:aarch64, :glibc) => ("$bin_prefix/libcalceph.aarch64-linux-gnu.tar.gz", "2810702ed47c83d78024c681e278814e7bcc141a3abf046eaa2fb112e9a6a275"),
    BinaryProvider.Linux(:armv7l, :glibc) => ("$bin_prefix/libcalceph.arm-linux-gnueabihf.tar.gz", "870809fda95aa4dcb340b2be1a6bd71b0cfbd206173af2fd33dfd77d27eb1273"),
    BinaryProvider.Linux(:i686, :glibc) => ("$bin_prefix/libcalceph.i686-linux-gnu.tar.gz", "5725d3e876387b66808b29d926ca0b3fd7910ee2ff1d3f524a369f99dbd6e077"),
    BinaryProvider.Windows(:i686) => ("$bin_prefix/libcalceph.i686-w64-mingw32.tar.gz", "1b17e10280598406c8729b739092d21a3acd32864198c6cce479b85a77c497d1"),
    BinaryProvider.Linux(:powerpc64le, :glibc) => ("$bin_prefix/libcalceph.powerpc64le-linux-gnu.tar.gz", "b67b9216d9a24ad886ad4131d1c49a023335f131695803a4115942fa52859a4c"),
    BinaryProvider.MacOS() => ("$bin_prefix/libcalceph.x86_64-apple-darwin14.tar.gz", "0c5a35dea01f82f3e4c10081676e147a802ef555467901cf7c47170241db7660"),
    BinaryProvider.Linux(:x86_64, :glibc) => ("$bin_prefix/libcalceph.x86_64-linux-gnu.tar.gz", "edc209c16bbbb0b516b98fde33c6f65a5167f2f5cff93e94501dfe8d89ad9225"),
    BinaryProvider.Windows(:x86_64) => ("$bin_prefix/libcalceph.x86_64-w64-mingw32.tar.gz", "aca4e9d109461e4a3d390d737320cf6bcdee38775cbfe189e6efce00828d7b15"),
)
if platform_key() in keys(download_info)
    # First, check to see if we're all satisfied
    if any(!satisfied(p; verbose=true) for p in products)
        # Download and install binaries
        url, tarball_hash = download_info[platform_key()]
        install(url, tarball_hash; prefix=prefix, force=true, verbose=true)
    end

    # Finally, write out a deps.jl file that will contain mappings for each
    # named product here: (there will be a "libfoo" variable and a "fooifier"
    # variable, etc...)
    @write_deps_file libcalceph
    exit(0)
end

info("Could not find a binary for your platform $(Sys.MACHINE). Will attempt a build.")

using BinDeps

@BinDeps.setup

libcalceph = library_dependency("libcalceph")

provides(Sources,URI("https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-3.0.0.tar.gz"), libcalceph)

provides(BuildProcess,Autotools(configure_options =
        ["--enable-shared", "--disable-fortran", "--disable-python"],
        libtarget=joinpath("src", "libcalceph.la")),libcalceph, os = :Unix)

@BinDeps.install Dict(:libcalceph => :libcalceph)
