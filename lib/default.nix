# taken from https://github.com/taj-ny/nix-config/blob/main/lib/default.nix
{
  lib,
  ...
}:
{
  allExceptThisDefault =
    dir:
    map (entry: "${toString dir}/${entry}") (
      builtins.attrNames (builtins.removeAttrs (builtins.readDir dir) [ "default.nix" ])
    );
}
