{ lib, ... }:

let
  inherit (builtins)
    concatMap
    filter
    isPath
    isString
    readFileType
    ;
in
paths:
filter (path: !isPath path || isString path || lib.strings.hasSuffix ".nix" (toString path)) (
  concatMap (
    path:
    if isPath path || isString path then
      if readFileType path == "directory" then lib.filesystem.listFilesRecursive path else [ path ]
    else
      [ path ]
  ) paths
)
