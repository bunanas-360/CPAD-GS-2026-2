# Execute no PowerShell, dentro da pasta citysense.
$ErrorActionPreference = 'Stop'
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  throw 'Flutter nao encontrado no PATH. Instale o Flutter SDK e configure o PATH.'
}
if (-not (Test-Path 'android') -or -not (Test-Path 'ios')) {
  flutter create --platforms=android,ios .
}
$manifestPath = 'android\app\src\main\AndroidManifest.xml'
if (Test-Path $manifestPath) {
  $manifest = Get-Content $manifestPath -Raw
  if ($manifest -notmatch 'android.permission.INTERNET') {
    $manifest = [regex]::Replace($manifest, '(<application\b)', '    <uses-permission android:name="android.permission.INTERNET" />' + "`r`n" + '$1', 1)
    Set-Content -Path $manifestPath -Value $manifest -Encoding UTF8
  }
}
flutter pub get
Write-Host 'Estrutura preparada. Execute: flutter run'
