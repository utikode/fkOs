# fkOs System Layout

## Directories
- /boot: kernel + initrd
- /usr: system binaries, libs, apps
- /etc: config
- /var: logs, caches, state
- /home: user data
- /opt/fkai: AI runtime
- /snapshots: A/B update snapshots

## Services
- fk-init (systemd)
- fk-network
- fk-audio (PipeWire)
- fk-display (Wayland compositor)
- fk-ai (local LLM service)
- fk-update (atomic updater)
