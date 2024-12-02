# Setup

Install zig from https://ziglang.org/download/ or via your package manager of choice.

If you want to edit the code, use ZLS as an LSP: https://zigtools.org/zls/install/

# Executing solutions

There's no need to build executables, just run the zig files directly:

For tests run: `zig test src/day_xx.zig`

For the solution: `zig run src/day_xx.zig`

## Notes

Docs: https://ziglang.org/documentation/master/

Complementary docs: https://zig.guide/

Some thoughts are borrowed from: https://kristoff.it/blog/advent-of-code-zig/ - 
like embedding the input data into the application, as opposed to reading it from stdin

The folder structure is also simple, with no intention to improve it - 
please accept my most sincere apologies for that.
