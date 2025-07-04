{
  inputs,
  system,
  ...
}:
import ./torch.nix {
  inherit inputs system;
  cudaSupport = false;
}
