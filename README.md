# Site institucional SIMM Services — protótipo v1

Site estático responsivo, com Início, Soluções (Nexora e SIMM Imob), Serviços, Sobre e Contato.

## Como visualizar

Abra `index.html` no navegador ou execute `python -m http.server 8080` nesta pasta e abra `http://localhost:8080`.

## Configuração para produção

Edite `config.js`:
- `nexoraLoginUrl`: URL HTTPS **oficial** do fluxo de autenticação do Nexora. O botão “Acessar Nexora” faz redirecionamento direto ao destino configurado. **Não** colete senhas no site institucional.
- `commercialEmail`: e-mail comercial de destino. O formulário abre o aplicativo de e-mail do visitante via `mailto:`; não há backend ou persistência. Em produção, substituir por formulário seguro com validação, proteção antiabuso e política de privacidade.

## Marca

A imagem `assets/logo-referencia-opcao02.png` foi recortada da prancha de apresentação aprovada (Opção 02) e serve como **referência raster**, não como logotipo vetorial final. Substituir pelo ativo original oficial quando estiver disponível.

Cores oficiais: `#0A2540`, `#1E88E5`, `#00C2A8`, `#E9EEF4`.

## Hospedagem

O site pode ser servido diretamente pelo Nginx, copiando `index.html`,
`config.js` e `assets/` para `/var/www/simmservices`. Um exemplo de virtual
host está em `deploy/nginx.conf.example`; substitua os domínios de exemplo
antes de ativá-lo. Segredos e chaves nunca devem ser versionados.

## Pendente antes da publicação pública

Confirmar URL de login Nexora, e-mail/WhatsApp comercial, política de privacidade e texto institucional definitivo, formato vetorial do logo e termos de serviços/SLAs.
