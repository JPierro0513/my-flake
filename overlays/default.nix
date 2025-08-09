{inputs, ...}: (final: prev: {
  neovim = inputs.neovim-nightly.packages.${final.system}.default;
})
