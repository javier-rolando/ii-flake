# hm-modules/python-env.nix
# Entorno Python equivalente al venv creado por uv en Arch Linux
# Paquetes extraídos de sdata/uv/requirements.in + requirements.txt (versiones fijadas)

{ pkgs }:

let
  # kde-material-you-colors se fija a 1.10.1 para coincidir con requirements.txt de ii-vynx.
  # v2+ introduce cambios de API que podrían romper los scripts de QuickShell.
  kdeMaterialYouColors = pkgs.python3Packages.kde-material-you-colors.overridePythonAttrs (old: rec {
    version = "1.10.1";
    src = pkgs.fetchPypi {
      pname   = "kde_material_you_colors";
      inherit version;
      hash    = "sha256-74rD8jX8x4D35rvZ0ILRIN+wtQz5SJGI1jQ9xvmynQE=";
    };
    # v1.x no requiere python-magic
    dependencies = builtins.filter (d: d.pname or "" != "python-magic") (old.dependencies or []);
  });
in
pkgs.python3.withPackages (ps: [
  # ── Requeridos por requirements.in ──────────────────────────────────────
  ps.build
  ps.pillow
  ps.setuptools-scm
  ps.wheel
  ps.pywayland
  ps.psutil
  # kde-material-you-colors se inyecta como kdeMaterialYouColors (v1.10.1 fijada, ver arriba)
  ps.materialyoucolor
  ps.libsass
  # material-color-utilities: normalmente incluido via materialyoucolor
  ps.setproctitle
  ps.click
  ps.loguru
  ps.pycairo
  ps.pygobject3
  ps.tqdm
  ps.numpy
  ps.opencv4           # opencv-contrib-python (mejor disponible en nixpkgs)

  # kde-material-you-colors fijado a 1.10.1 (ver comentario arriba)
  kdeMaterialYouColors

  # ── Deps adicionales necesarios en tiempo de ejecución ──────────────────
  ps.cffi
  ps."dbus-python"
  ps.pyproject-hooks
])
