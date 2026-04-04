# 🏠 Dotfiles com Chezmoi
Este repositório contém toda a minha configuração pessoal gerenciada com **chezmoi**, organizada de forma declarativa, modular e idempotente.
A seguir, está documentada a estrutura **atualizada** do projeto, bem como as convenções adotadas.

---

## 📑 Sumário
- [Estrutura do Repositório](#-estrutura-do-repositório)
- [Filosofia da Estrutura](#-filosofia-da-estrutura)
- [Como Utilizar o Repositório](#️-como-utilizar-o-repositório)
  - [Configurando uma Nova Máquina](#-1-configurando-uma-nova-máquina)
  - [Atualizando Dotfiles](#-2-atualizando-dotfiles-em-uma-máquina-existente)
  - [Como Incluir Novas Configurações](#️-3-como-incluir-novas-configurações-ou-alterar-existentes)
  - [Verificação antes de aplicar](#-4-verificando-o-que-vai-acontecer-antes-de-aplicar)
- [Convenções e Padrões](#-convenções-e-padrões-adotados)
- [Adicionar Novos Arquivos](#-como-adicionar-novos-arquivos)
- [Gerenciamento Declarativo de Pacotes](#-gerenciamento-declarativo-de-pacotes)
- [Ferramentas de Depuração](#-ferramentas-de-depuração)
- [Referências](#-referências)

## 📂 Estrutura do Repositório
A estrutura dentro de `~/.local/share/chezmoi/` é a seguinte:
> `.chezmoiroot` define que o diretório raiz real de trabalho é `dotfiles/`.\
> Isso permite manter os arquivos do repositório organizados e separados da infraestrutura do próprio GitHub.

```text
~/.local/share/chezmoi/
├── dotfiles/
│   ├── .chezmoi.yaml.tmpl        # Template da configuração do próprio chezmoi
│   ├── .chezmoiignore            # Regras de ignorados
│   ├── dot_bashrc
│   ├── dot_bash_profile
│   ├── .chezmoidata/
│   │   └── packages.yaml         # Arquivo declarativo com listas de pacotes
│   ├── .chezmoiscripts/
│   │   └── run_onchange_windows-install-packages.ps1.tmpl    # Script que instala pacotes no Windows (winget, pip, Python, Node)
│   └── dot_config/
│       ├── bash/
│       │   ├── 01_environment.sh.tmpl
│       │   ├── 02_input.sh
│       │   ├── 03_aliases.sh.tmpl
│       │   ├── 04_git_setup.sh
│       │   └── 05_prompt.sh
│       ├── delta/
│       │   └── delta.gitconfig
│       └── git/
│           └── config.tmpl
├── .chezmoiroot
└── README.md
```

---

## 🧱 Filosofia da Estrutura
A estrutura foi pensada para:
- Seguir o padrão interno do chezmoi.
- Ser explícita sobre o que é um template, um script ou um arquivo estático.
- Manter todos os dotfiles dentro de um único diretório: `dotfiles/`.
- Utilizar o diretório `.chezmoidata/` para qualquer dado declarativo.
- Utilizar `.chezmoiscripts/` para automações idempotentes.

### 📁 `dotfiles/`
Contém **todos** os arquivos que o chezmoi gerencia.
Cada arquivo corresponde à sua localização final na máquina do usuário.

### 📁 `dot_config/`
Representa diretamente o conteúdo de `~/.config`.
Por exemplo:
`dot_config/git/config.tmpl  →  ~/.config/git/config`

### 📁 `.chezmoidata/`
Armazena dados usados pelos templates.
Aqui fica o arquivo:
`packages.yaml`

Ele contém listas como:
- pacotes winget
- pacotes pip
- configurações variadas usadas pelos scripts

### 📁 `.chezmoiscripts/`
Scripts executados automaticamente conforme regras do chezmoi.
Por exemplo:
`run_onchange_windows-install-packages.ps1.tmpl`

Este script instala:
- pacotes winget
- Python via PIM
- pacotes pip
- Node LTS via fnm

Ele é idempotente, podendo rodar repetidamente sem efeitos colaterais.

---

## ▶️ Como Utilizar o Repositório
Esta seção explica **como clonar, inicializar e aplicar** os dotfiles em uma nova máquina, além de como manter o repositório atualizado enquanto você altera sua configuração local.

---

### 🚀 1. Configurando uma Nova Máquina

#### **1.1. Instalar o chezmoi**
O método recomendado:

##### **Linux / macOS**
```sh
sh -c "$(curl -fsLS get.chezmoi.io)"
```

##### **Windows (PowerShell)**
```powershell
winget install --id twpayne.chezmoi -e
```

---

#### **1.2. Clonar automaticamente o repositório e aplicar as configurações**
```sh
chezmoi init <seu-repo-git>
chezmoi apply
```

Isso irá:
- clonar o repositório,
- configurar o diretório `~/.local/share/chezmoi`,
- aplicar todos os arquivos,
- executar scripts `run_once` / `run_onchange`,
- instalar pacotes declarados.

---

### 🔄 2. Atualizando Dotfiles em uma Máquina Existente
Obter as alterações mais recentes do repositório:
```sh
chezmoi update
```

Para aplicar qualquer mudança:
```sh
chezmoi apply
```

Isso acionará automaticamente scripts `run_onchange` quando arquivos declarativos forem modificados.

---

### ✏️ 3. Como Incluir Novas Configurações ou Alterar Existentes
O fluxo recomendado:

#### **3.1. Alterar um arquivo já gerenciado**
Edite usando o comando integrado (mantém o controle de permissões e caminhos):
```sh
chezmoi edit ~/.config/bash/01_environment.sh
```

Isso abrirá a versão localizada no repositório.

#### **3.2. Adicionar um novo arquivo**

##### Arquivo dentro de `~/.config`
```sh
chezmoi add ~/.config/minhaapp/config.json
```

Cria:\
`dot_config/minhaapp/config.json`

##### Arquivo fora do `~/.config`
```sh
chezmoi add ~/.zshrc
```

Gera:\
`dot_zshrc`

#### **3.3. Transformar arquivo em template (quando necessário)**
Se quiser torná-lo dinâmico:
```sh
chezmoi edit ~/.config/minhaapp/config.json
```

E renomeie:
```sh
mv dot_config/minhaapp/config.json dot_config/minhaapp/config.json.tmpl
```

#### **3.4. Adicionar novos pacotes ao setup automático**
Edite `dotfiles/.chezmoidata/packages.yaml` e os scripts serão atualizados automaticamente na próxima execução.

---

### 🧪 4. Verificando o que vai acontecer antes de aplicar

#### Mostrar diferenças
```sh
chezmoi diff
```

#### Renderizar templates sem aplicar
```sh
chezmoi cat ~/.config/git/config
```

---

## 🧩 Convenções e Padrões Adotados

### 🔹 1. Arquivos dinâmicos **sempre** usam `.tmpl`
Exemplos:
- `config.tmpl`
- `01_environment.sh.tmpl`
- `run_onchange_windows-install-packages.ps1.tmpl`

### 🔹 2. Nunca adicionar `~/.config/chezmoi`
Esse diretório **não pode** ser gerenciado por segurança.
Use `dotfiles/.chezmoi.yaml.tmpl` para configurá‑lo.

### 🔹 3. Scripts devem ser totalmente idempotentes
Regras:
- nunca rodar algo duas vezes se não necessário
- sempre validar antes de instalar
- verificar erros dos comandos

### 🔹 4. Arquivos declarativos ficam em `.chezmoidata`
Assim o script pode ler algo como:
```yaml
winget:
  - Microsoft.PowerShell
pip:
  - black
```

---

## ➕ Como Adicionar Novos Arquivos

### 🟦 1. Arquivos em `~/.config`
```sh
chezmoi add ~/.config/nome/arquivo
```

ChezMoi criará:\
`dot_config/nome/arquivo`

Se precisar virar template:
```sh
mv arquivo arquivo.tmpl
```

### 🟩 2. Arquivos fora de `~/.config`
```sh
chezmoi add ~/.bashrc
```

Gera:\
`dot_bashrc`

### 🟨 3. Adicionar scripts
Criar em:\

`dotfiles/.chezmoiscripts/`

Exemplos:
```text
run_onchange_<desc>.ps1.tmpl
run_after_<desc>.sh
```

---

## 📦 Gerenciamento Declarativo de Pacotes
As listas ficam em:\
`dotfiles/.chezmoidata/packages.yaml`

E o script PowerShell em:\
`dotfiles/.chezmoiscripts/run_onchange_windows-install-packages.ps1.tmpl`

interpreta automaticamente:
- winget
- pip
- Python via PyManager
- Node via fnm

---

## 🧪 Ferramentas de Depuração

### Ver o que será aplicado no sistema
```sh
chezmoi diff
```

### Ver o arquivo final renderizado
```sh
chezmoi cat <caminho>
```

### Listar tudo que é gerenciado
```sh
chezmoi managed
```

---

## 📚 Referências
- [https://www.chezmoi.io](https://www.chezmoi.io)
- [https://www.chezmoi.io/user-guide/](https://www.chezmoi.io/user-guide/)
