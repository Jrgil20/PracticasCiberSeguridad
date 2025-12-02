#!/bin/bash
#
# Setup script para instalar Git hooks
# Ejecutar: bash .github/setup-hooks.sh
#

set -e

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🔧 Configurando Git hooks...${NC}"
echo ""

# Obtener la raíz del repositorio
REPO_ROOT=$(git rev-parse --show-toplevel)
HOOKS_SOURCE_DIR="$REPO_ROOT/.github/hooks"
HOOKS_DEST_DIR="$REPO_ROOT/.git/hooks"

# Verificar que existe la carpeta de hooks
if [[ ! -d "$HOOKS_SOURCE_DIR" ]]; then
    echo -e "${RED}❌ Error: No se encontró $HOOKS_SOURCE_DIR${NC}"
    exit 1
fi

# Crear carpeta de hooks si no existe
if [[ ! -d "$HOOKS_DEST_DIR" ]]; then
    mkdir -p "$HOOKS_DEST_DIR"
    echo -e "${YELLOW}📁 Creada carpeta $HOOKS_DEST_DIR${NC}"
fi

# Instalar pre-commit hook
if [[ -f "$HOOKS_SOURCE_DIR/pre-commit" ]]; then
    cp "$HOOKS_SOURCE_DIR/pre-commit" "$HOOKS_DEST_DIR/pre-commit"
    chmod +x "$HOOKS_DEST_DIR/pre-commit"
    echo -e "${GREEN}✓${NC} Hook pre-commit instalado"
else
    echo -e "${YELLOW}⚠${NC} No se encontró pre-commit hook"
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Git hooks configurados correctamente${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "📋 Hooks instalados:"
echo "  • pre-commit: Valida que imágenes estén en Git LFS"
echo ""
echo "💡 Para que los hooks funcionen:"
echo "  1. Git LFS debe estar instalado: git lfs install"
echo "  2. Ejecutar este script cada vez que clones el repo:"
echo "     bash .github/setup-hooks.sh"
echo ""
