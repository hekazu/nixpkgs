{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libGL,
  libxkbcommon,
  wayland,
  libx11,
  libxcursor,
  libxi,
  vulkan-loader,
  makeBinaryWrapper,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "raphael-xiv";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "KonaeAkira";
    repo = "raphael-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-icCCSHZqQEYCIpcqB5iTOHYL0pzRN+0x/r/nauPiFZ0=";
  };

  cargoHash = "sha256-mua7YKU5Ujj8u3ZLI3y073JGRRN6dAUct+9YA4M8Ngk=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  buildInputs = [
    libGL
    libxkbcommon
    libx11
    libxcursor
    libxi
    vulkan-loader
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland
  ];

  runtimeDependencies = [
    libxkbcommon
    libx11
    libxcursor
    libxi
    vulkan-loader
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland
  ];

  cargoBuildFlags = [
    "--package"
    "raphael-xiv"
    "--package"
    "raphael-cli"
  ];

  postFixup = ''
    wrapProgram "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.runtimeDependencies}"
  '';

  meta = {
    description = "Crafting macro solver for Final Fantasy XIV";
    homepage = "https://github.com/KonaeAkira/raphael-rs";
    changelog = "https://github.com/KonaeAkira/raphael-rs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hekazu ];
    mainProgram = "raphael-xiv";
    platforms = lib.platforms.all;
  };
})
