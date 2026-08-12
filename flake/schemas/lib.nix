{
  version = 1;
  doc = "Custom library provided by this flake.";
  inventory = output: {
    children = {
      mkSystem = {
        what = "system builders";

        evalChecks.isAttrs = builtins.isAttrs output.mkSystem;

        children = builtins.mapAttrs (_name: value: {
          what = "system/platform builder";
          evalChecks.isFunction = builtins.isFunction value;
        }) output.mkSystem;
      };
    };
  };
}
