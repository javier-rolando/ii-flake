{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname   = "illogical-impulse-oneui4-icons";
  version = "unstable-2024-05-07";

  src = fetchFromGitHub {
    owner = "end-4";
    repo  = "OneUI4-Icons";
    rev   = "693095d45c67e6b48a9873e36af6283f05080e66";
    sha256 = "sha256-VWgITEJQFbPqIbiGDfDeD0R74y9tCKEfjO/M/tcO94M=";
  };

  patchPhase = ''
    # Eliminar symlinks rotos
    find . -xtype l -delete

    # Eliminar caches de iconos obsoletos
    rm -f */icon-theme.cache

    for theme_dir in OneUI OneUI-dark OneUI-light; do
      if [ -f "$theme_dir/index.theme" ]; then
        # Herencia robusta
        if [[ "$theme_dir" == *"dark"* ]]; then
          sed -i 's/^Inherits=.*/Inherits=Papirus-Dark,Adwaita,hicolor/' "$theme_dir/index.theme"
        elif [[ "$theme_dir" == *"light"* ]]; then
          sed -i 's/^Inherits=.*/Inherits=Papirus-Light,Adwaita,hicolor/' "$theme_dir/index.theme"
        else
          sed -i 's/^Inherits=.*/Inherits=Papirus,Adwaita,hicolor/' "$theme_dir/index.theme"
        fi

        # Corregir sección duplicada [16@2x/devices]
        sed -i '285,289s/\[16@2x\/devices\]/[22@2x\/devices]/' "$theme_dir/index.theme"

        # Añadir secciones faltantes
        cat >> "$theme_dir/index.theme" <<'EOF'

[256/applets]
Context=Status
Size=256
Type=Fixed

[16@2x/emblems]
Context=Emblems
Scale=2
Size=16
Type=Fixed

[22@2x/emblems]
Context=Emblems
Scale=2
Size=22
Type=Fixed

[256@2x/applets]
Context=Status
Scale=2
Size=256
Type=Fixed
EOF
      fi
    done
  '';

  installPhase = ''
    install -d $out/share/icons
    cp -dr --no-preserve=mode OneUI{,-dark,-light} $out/share/icons/
  '';

  meta = {
    description = "Fork personalizado de OneUI4-Icons para illogical-impulse";
    homepage    = "https://github.com/end-4/OneUI4-Icons";
    license     = lib.licenses.gpl3;
  };
}
