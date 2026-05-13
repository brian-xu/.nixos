# taken from https://github.com/taj-ny/nix-config/blob/main/lib/default.nix
{
  lib,
  ...
}:
{
  allExceptThisDefault =
    dir:
    (builtins.readDir dir)
    |> (attrs: builtins.removeAttrs attrs [ "default.nix" ])
    |> builtins.attrNames
    |> map (entry: "${toString dir}/${entry}");
}
