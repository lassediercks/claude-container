# Claude Container

> A portable, containerized environment for running [Claude Code](https://github.com/anthropics/claude-code) from anywhere on your system

<video src="intro.mov" autoplay loop muted playsinline></video>

## Why?

Becase you shouldn't trust an AI agent with your entire system just to run some code generation tasks!

## Features

- 🐳 **Fully containerized** - No local installation required (except Docker)
- 📁 **Directory mounting** - Automatically mounts your current working directory
- ⚙️ **Config preservation** - Uses your existing `~/.claude.json` configuration
- 🛠️ **Pre-configured** - Includes Node.js, pnpm, git, bash, and vim
- 🚀 **Portable** - Run from any directory with a single command

## Quick Start

```bash
# Clone the repository
git clone <your-repo-url>
cd claude-container

# Run the installer
./install.sh

# Start using it from any directory
cd ~/my-project
claude-container
```

## Installation

### Prerequisites

- Docker Desktop (or Docker Engine)
- A configured `~/.claude.json` file with your Claude Code API key

### Automated Installation (Recommended)

Run the installer script which will handle everything for you:

```bash
./install.sh
```

The installer will:

- Check if Docker is running
- Build the Docker image if needed
- Install the wrapper script (system-wide or user-local)
- Set up permissions automatically

### Manual Installation

<details>
<summary>Click to expand manual installation steps</summary>

#### 1. Build the Docker Image

```bash
docker build -f Dockerfile.utility -t claude-container:latest .
```

#### 2. Install the Wrapper Script

**System-wide** (requires sudo):

```bash
sudo cp claude-container /usr/local/bin/
sudo chmod +x /usr/local/bin/claude-container
```

**User-local** (no sudo):

```bash
mkdir -p ~/bin
cp claude-container ~/bin/
chmod +x ~/bin/claude-container
export PATH="$HOME/bin:$PATH"  # Add to ~/.bashrc or ~/.zshrc
```

</details>

### Verify Installation

```bash
claude-container version
```

## Usage

Navigate to any project directory and run:

```bash
claude-container
```

This launches a Docker container with:

- Your current directory mounted at `/workspace`
- Your `~/.claude.json` configuration loaded
- Claude Code CLI automatically started

Claude Code will start immediately, allowing you to interact with the AI agent. When you're done, exit Claude Code and the container will be automatically removed.

## Customization

### Adding Tools

Edit `Dockerfile.utility` to add more packages:

```dockerfile
RUN apk add --no-cache \
    bash \
    vim \
    jq \
    python3 \
    your-tool-here
```

Then rebuild:

```bash
docker build -f Dockerfile.utility -t claude-container:latest .
```

### Mounting Additional Directories

Edit the `claude-container` script to add volume mounts:

```bash
# Example: Mount SSH keys and Git config
-v "$HOME/.ssh:/root/.ssh:ro" \
-v "$HOME/.gitconfig:/root/.gitconfig:ro" \
```

## Troubleshooting

<details>
<summary><b>Image not found error</b></summary>

Build the Docker image:

```bash
docker build -f Dockerfile.utility -t claude-container:latest .
```

</details>

<details>
<summary><b>Docker is not running</b></summary>

Start Docker Desktop or your Docker daemon before running the container.

</details>

<details>
<summary><b>Shell crashes after trust prompt</b></summary>

Try rebuilding with the latest version:

```bash
docker build --no-cache -f Dockerfile.utility -t claude-container:latest .
```

Or check your config file permissions:

```bash
chmod 644 ~/.claude.json
```

</details>

<details>
<summary><b>Changes don't persist</b></summary>

This is expected. Only files in the mounted `/workspace` directory (your current directory) persist. The container itself is ephemeral.

</details>

<details>
<summary><b>Permission issues with files</b></summary>

Ensure your Docker daemon is configured to map your user ID correctly. This is usually automatic on Docker Desktop.

</details>

## Uninstallation

Run the automated uninstaller:

```bash
./uninstall.sh
```

Or manually:

```bash
# Remove the script
sudo rm /usr/local/bin/claude-container
# or
rm ~/bin/claude-container

# Remove the Docker image
docker rmi claude-container:latest
```

## Development

### Creating a Release

Use the release script to create new versions:

```bash
./release.sh 1.0.1
```

This will:

1. Validate the version format (semantic versioning)
2. Update the version in `claude-container`
3. Create a git commit and tag
4. Prompt you to push changes

Push the release:

```bash
git push origin main --tags
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - See LICENSE file for details

## Acknowledgments

Built for use with [Claude Code](https://github.com/anthropics/claude-code) by Anthropic.
