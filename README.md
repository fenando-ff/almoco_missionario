# Calendário de Almoço

Pequeno app Django para agendar o almoço de cada dia. Interface mobile-first (principal alvo: celular).

**Funcionalidades principais**
- Mostra um calendário mensal com blocos para cada dia (largura: 90% da tela).
- Ao tocar em um dia abre modal para inserir `nome` e `telefone`.
- Dados salvos no banco e exibidos no bloco do dia.
- API POST: `/api/save/` (JSON: `{ dia: "YYYY-MM-DD", nome: "...", telefone: "..." }`).

**Requisitos**
- Python 3.10+ (ou versão compatível com Django do projeto)
- MySQL (ou ajuste `DATABASES` em `projeto_almoco/settings.py`)
- Pacotes Python: `Django`, `mysqlclient` (ou outro conector usado no projeto)

Instalação e execução (Windows - PowerShell)

1. Crie e ative um ambiente virtual (opcional, recomendado):

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

2. Instale dependências (ajuste conforme o ambiente):

```powershell
pip install django mysqlclient
```

3. Configure o banco de dados em `projeto_almoco/settings.py` (nome, usuário, senha, host, porta). Se preferir, importe `db/db_almoco_missionario.sql` no MySQL para criar o esquema inicial.

4. Rode migrações e crie usuário admin:

```powershell
python manage.py makemigrations
```

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1   # PowerShell
# ou 
.\.venv\Scripts\activate  # CMD
```

2. Instalar dependências:

```powershell
pip install -r requirements.txt
```

3. Ajustar `projeto_almoco/settings.py` com a configuração do DB.

4. Observação sobre migrations:
- Como as tabelas principais do app já existem e as models estão com `managed = False`, você não precisa (nem deve) rodar `makemigrations`/`migrate` para o `app_almoco`.
- Se adicionar modelos gerenciáveis em outras apps, rode migrations normalmente para essas apps.

5. (Opcional) criar superuser:

```powershell
python manage.py createsuperuser
```

6. Rodar servidor:

```powershell
python manage.py runserver
```

Funcionalidades e endpoints
- Página principal: calendário com navegação entre meses.
- `GET /api/reservations/?year=&month=` — retorna reservas do mês. Retorna também `owned: true` quando a reserva pertence ao usuário da sessão.
- `POST /api/save/` — cria reserva (respeita se o dia já está reservado por outro usuário).
- `POST /api/delete/` — apaga a reserva (apenas o proprietário pode apagar).

Frontend
- `static/app_almoco/app.js` — lógica do calendário, modal e chamadas às APIs.
- `static/app_almoco/phone.js` — máscara de telefone.
- Exportar PDF: usa `html2pdf.js` via CDN (requer disponibilidade de internet no cliente para download do bundle).

Testes rápidos
- Logue como A e reserve um dia; confirme que A consegue desmarcar.
- Logue como B e abra o mesmo dia; B deve ver os dados do dono, mas sem botão de desmarcar.

Precisa de mais?
- Posso adicionar instruções de deploy (Docker / Gunicorn + Nginx), exemplos de `DATABASES` no `settings.py`, ou gerar um `requirements.txt` se preferir. Diga qual opção prefere e eu adiciono.

## Deploy: PythonAnywhere + Supabase (Postgres)

Resumo: hospede o banco no Supabase (Postgres) e faça o deploy do Django no PythonAnywhere. O projeto já foi ajustado para ler `DATABASE_URL` (padrão Supabase) e para coletar arquivos estáticos em `STATIC_ROOT`.

### 1) Supabase (Postgres)
- Crie um projeto no Supabase (https://supabase.com/).
- No painel do projeto vá em Settings → Database → Connection string (ou em "API"). Copie a `DATABASE_URL` (ex: `postgresql://user:pass@host:5432/dbname`).
- No Supabase, certifique-se de habilitar SSL/require se necessário (o código já define `sslmode=require` quando usa `DATABASE_URL`).

### 2) Preparar o projeto para PythonAnywhere
- Dependências: `requirements.txt` já inclui `dj-database-url` e `psycopg2-binary` para Postgres.
- `projeto_almoco/settings.py` foi atualizado para:
	- Usar `DATABASE_URL` se estiver definido (via `dj-database-url`).
	- Ler `SECRET_KEY`, `DJANGO_DEBUG` e `ALLOWED_HOSTS` via variáveis de ambiente.
	- Definir `STATIC_ROOT = BASE_DIR / 'staticfiles'` para `collectstatic`.

### 3) Passos no PythonAnywhere
- Crie uma conta e faça login em https://www.pythonanywhere.com/
- No Dashboard crie um "Bash console".
- No console, clone ou envie seu projeto para `/home/yourusername/` (por SCP, git, ou upload). Ex.: `/home/yourusername/calendario_almoco`
- Crie e ative um virtualenv (Python 3.10/3.11 conforme suporte):

```bash
python3.10 -m venv ~/venv-calendario
source ~/venv-calendario/bin/activate
pip install -r ~/calendario_almoco/requirements.txt
```

- Defina variáveis de ambiente no painel Web → "Environment variables":
	- `DJANGO_SECRET_KEY` = sua chave secreta (ou deixe a padrão em desenvolvimento)
	- `DATABASE_URL` = a connection string do Supabase (copiada antes)
	- `DJANGO_DEBUG` = `False`
	- `ALLOWED_HOSTS` = `yourusername.pythonanywhere.com`

- No painel Web → Files configure o mapeamento de arquivos estáticos:
	- URL `/static/` → caminho do destino `/home/yourusername/calendario_almoco/staticfiles`

- No console do PythonAnywhere, rode:

```bash
cd ~/calendario_almoco
source ~/venv-calendario/bin/activate
python manage.py collectstatic --noinput
# Se tiver migrations em outras apps gerenciáveis:
python manage.py migrate
```

- Edite o arquivo WSGI (aba Web → WSGI configuration file) e aponte para o settings do projeto. Um snippet típico dentro do WSGI file:

```python
import os, sys
project_home = '/home/yourusername/calendario_almoco'
if project_home not in sys.path:
		sys.path.insert(0, project_home)
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'projeto_almoco.settings')
from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()
```

- Volte ao painel Web e pressione "Reload" para aplicar as mudanças.

### Notas importantes
- As models `Pessoa` e `DiaAlmoco` estão marcadas `managed = False` porque o projeto usa tabelas existentes. Não rode migrações que criem essas tabelas a menos que queira migrar o esquema do banco.
- Se a sua conta PythonAnywhere não permitir instalação binária de `psycopg2-binary`, use a opção do painel ou peça suporte; em geral `psycopg2-binary` funciona em virtualenv.
- Caso prefira, posso gerar um `fab`/script de deploy ou Dockerfile para deploy em outros provedores.

Se quiser, faço um checklist passo-a-passo adaptado ao seu nome de usuário e forneço o snippet pronto para colar no WSGI e as variáveis exatas a configurar no painel do PythonAnywhere. Deseja que eu gere isso para você (me passe seu `yourusername` no PythonAnywhere)?
