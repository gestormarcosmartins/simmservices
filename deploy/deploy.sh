#!/usr/bin/env bash
# Deploy do site SIMM Services num servidor Debian/Ubuntu com Caddy.
# Uso (na raiz do repositório clonado no servidor): sudo ./deploy/deploy.sh
set -euo pipefail

SITE_DIR=/var/www/simmservices
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

if [ "$(id -u)" -ne 0 ]; then
  echo "Execute como root: sudo $0" >&2
  exit 1
fi

if ! command -v caddy >/dev/null 2>&1; then
  echo ">> Instalando Caddy"
  apt-get update
  apt-get install -y debian-keyring debian-archive-keyring apt-transport-https curl gpg
  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' > /etc/apt/sources.list.d/caddy-stable.list
  apt-get update
  apt-get install -y caddy
fi

echo ">> Copiando arquivos do site para $SITE_DIR"
mkdir -p "$SITE_DIR"
cp "$REPO_DIR/index.html" "$REPO_DIR/config.js" "$SITE_DIR/"
rm -rf "$SITE_DIR/assets"
cp -r "$REPO_DIR/assets" "$SITE_DIR/assets"
chown -R caddy:caddy "$SITE_DIR"

echo ">> Instalando Caddyfile"
mkdir -p /var/log/caddy && chown caddy:caddy /var/log/caddy
[ -f /etc/caddy/Caddyfile ] && cp /etc/caddy/Caddyfile "/etc/caddy/Caddyfile.bak.$(date +%s)"
cp "$REPO_DIR/deploy/Caddyfile" /etc/caddy/Caddyfile
caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile

if command -v ufw >/dev/null 2>&1; then
  echo ">> Liberando portas no ufw"
  ufw allow 80/tcp
  ufw allow 443/tcp
  ufw allow 443/udp
fi

systemctl enable caddy
systemctl reload caddy || systemctl restart caddy

echo ">> Pronto. Acompanhe a emissão do certificado:"
echo "   journalctl -u caddy -n 50 --no-pager"
echo "   curl -I https://simmservices.com.br"
