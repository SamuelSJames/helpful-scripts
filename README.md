Here is the updated `README.md` with Rocky Linux and Debian:

---

# Helpful Scripts

Welcome to the **Helpful Scripts** repository! This repo contains a collection of bash scripts designed to simplify common installation and maintenance tasks on three popular Linux distributions: Ubuntu, Fedora, and Debian.

## Features

- Easy-to-use bash scripts
- Support for Ubuntu, Fedora, Debian, and Rocky Linux
- Scripts for common installation and maintenance tasks
- Organized and structured for quick access

## File Structure

```
helpful-scripts/
├── README.md
├── Ubuntu/
│   ├── install/
│   │   ├── install-docker.sh
│   │   ├── install-nginx.sh
│   │   └── install-nodejs.sh
│   └── maintenance/
│       ├── update-system.sh
│       ├── clean-cache.sh
│       └── backup-home.sh
├── Fedora/
│   ├── install/
│   │   ├── install-docker.sh
│   │   ├── install-nginx.sh
│   │   └── install-nodejs.sh
│   └── maintenance/
│       ├── update-system.sh
│       ├── clean-cache.sh
│       └── backup-home.sh
├── Debian/
│   ├── install/
│   │   ├── install-docker.sh
│   │   ├── install-nginx.sh
│   │   └── install-nodejs.sh
│   └── maintenance/
│       ├── update-system.sh
│       ├── clean-cache.sh
│       └── backup-home.sh
├── RockyLinux/
│   ├── install/
│   │   ├── install-docker.sh
│   │   ├── install-nginx.sh
│   │   └── install-nodejs.sh
│   └── maintenance/
│       ├── update-system.sh
│       ├── clean-cache.sh
│       └── backup-home.sh
└── common/
    ├── functions.sh
    └── README.md
```

## Getting Started

To use any of the scripts in this repository, follow the instructions below:

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/helpful-scripts.git
    cd helpful-scripts
    ```

2. Navigate to the appropriate directory for your Linux distribution:
    ```bash
    cd Ubuntu/install
    ```

3. Make the script executable:
    ```bash
    chmod +x install-docker.sh
    ```

4. Run the script:
    ```bash
    ./install-docker.sh
    ```

## Contributing

We welcome contributions! If you have a script that you'd like to add or an improvement to an existing script, please follow these steps:

1. Fork the repository
2. Create a new branch (`git checkout -b feature-branch`)
3. Make your changes
4. Commit your changes (`git commit -m 'Add some feature'`)
5. Push to the branch (`git push origin feature-branch`)
6. Open a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
