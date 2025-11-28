#!/usr/bin/env bash
# Script para crear la estructura de directorios de forma robusta
# No depende de brace expansion y funciona con bash/zsh
set -euo pipefail

BASE="/home/kali/cybersecure-project"
DIRS=(
  "symmetric-encryption/keys"
  "symmetric-encryption/data"
  "symmetric-encryption/encrypted"
  "symmetric-encryption/decrypted"
  "asymmetric-encryption/private-keys"
  "asymmetric-encryption/certificates"
  "asymmetric-encryption/csr"
  "web-security/config"
  "web-security/logs"
  "documentation"
  "backup"
  "scripts"
  "logs"
  "config"
)

for d in "${DIRS[@]}"; do
  mkdir -p "$BASE/$d"
done

printf "Directorio base: %s\n" "$BASE"
printf "Se han creado %d directorios.\n" "${#DIRS[@]}"
