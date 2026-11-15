#!/usr/bin/env bash
set -euo pipefail
command -v flutter >/dev/null 2>&1 || { echo 'Flutter SDK nao encontrado no PATH.' >&2; exit 1; }
if [[ ! -d android || ! -d ios ]]; then
  flutter create --platforms=android,ios .
fi
manifest='android/app/src/main/AndroidManifest.xml'
if [[ -f "$manifest" ]] && ! grep -q 'android.permission.INTERNET' "$manifest"; then
  python3 - "$manifest" <<'PY'
from pathlib import Path
import sys
path = Path(sys.argv[1])
text = path.read_text(encoding='utf-8')
text = text.replace('<application', '    <uses-permission android:name="android.permission.INTERNET" />\n    <application', 1)
path.write_text(text, encoding='utf-8')
PY
fi
flutter pub get
echo 'Estrutura preparada. Execute: flutter run'
