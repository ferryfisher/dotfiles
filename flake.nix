{
  description = "ferry nix config";

  outputs = { self, ... }: import ./. ((import ./.tack) // { inherit self; });
}
