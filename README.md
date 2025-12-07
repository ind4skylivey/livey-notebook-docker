# 📓 Livey Notebook Docker

> **"Your second brain, containerized and stylized."** 🧠✨

[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://kernel.org)
[![Bash](https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

A highly portable, resilient, and aesthetic **Open Notebook** environment designed for Linux power users. Built on the "Pastel Catppuccin" philosophy. 🎨

---

## 🚀 Mission Control

Forget manual container management. We provide a battle-tested CLI utility to manage your second brain.

### ⚡ Quick Start

```bash
# 1. Clone the repo
git clone https://github.com/ind4skylivey/livey-notebook-docker.git
cd livey-notebook-docker

# 2. Ignite the engines
./scripts/open_notebook_docker.sh start
```

*This spins up the Docker stack, waits for the health check, and auto-launches your browser (ZenBrowser preferred) when ready.*

---

## 🛠️ Command Center

The core logic resides in `scripts/open_notebook_docker.sh`.

| Command | Description | Nerd Stats |
| :--- | :--- | :--- |
| `start` | 🟢 Ignites the stack & opens UI | `docker compose up -d` + healthcheck + `xdg-open` |
| `stop` | 🔴 Kills the containers gracefully | `docker compose down` |
| `restart` | 🔄 Reboot sequence | `stop` then `start` |
| `status` | 📊 Report system integrity | `docker compose ps` |
| `logs` | 📜 Stream the matrix code | Tail last 40 lines |

**Usage Example:**
```bash
./scripts/open_notebook_docker.sh logs -f
```

---

## 🐚 Shell Integration (Aliases)

Why type long paths? Add these to your shell config for maximum velocity.

### **Zsh** (`~/.zshrc`)
```zsh
# 🧠 Open Notebook Alias
alias notebook="~/path/to/livey-notebook-docker/scripts/open_notebook_docker.sh"
```

### **Fish** (`~/.config/fish/config.fish`)
```fish
# 🧠 Open Notebook Alias
alias notebook="~/path/to/livey-notebook-docker/scripts/open_notebook_docker.sh"
```

**Now you just type:**
```bash
$ notebook start
```

---

## 🖥️ Desktop Integration

For the click-happy or **Rofi** users, we include a `.desktop` entry.

1. Copy `desktop/open-notebook.desktop` to `~/.local/share/applications/`.
2. Ensure paths in the file match your installation.
3. Launch via your system menu or runner!

---

## 📂 Data Persistence

Your brain dump is safe. Data is persisted to:
- 📁 `notebook_data/` - Your actual markdown notes.
- 📁 `surreal_single_data/` - Database storage.

*Recommended: Keep this on a dedicated partition (e.g., `/media/il1v3y/HD2`) to survive OS nukes.*

---

## 🧩 Architecture

```
livey-notebook-docker/
├── 📂 desktop/          # Linux desktop integration
├── 📂 scripts/          # The brain (Bash automation)
│   ├── open_notebook_docker.sh
│   └── export_docs.py
├── 📂 setup_guide/      # Docker compose & configs
├── 📄 README.md         # You are here
└── 🐳 docker-compose.yml
```

---

*Maintained by [ind4skylivey](https://github.com/ind4skylivey). Happy hacking!* 👾
