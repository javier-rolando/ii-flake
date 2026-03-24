# hm-modules/python-env.nix
# Entorno Python equivalente al venv creado por uv en Arch Linux
# Paquetes extraídos de sdata/uv/requirements.in

{ pkgs }:

pkgs.python3.withPackages (ps: [
  # ── Requeridos por requirements.in ──────────────────────────────────────
  ps.build
  ps.pillow
  ps.setuptools-scm
  ps.wheel
  ps.pywayland
  ps.psutil
  ps."kde-material-you-colors"
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

  # ── Deps adicionales necesarios en tiempo de ejecución ──────────────────
  ps.cffi
  ps."dbus-python"
  ps.pyproject-hooks
])
