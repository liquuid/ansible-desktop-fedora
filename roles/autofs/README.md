# Autofs Ansible Role for Fedora

Ansible role to install, configure, and manage **autofs** direct NFS mounts on Fedora Linux.

## Features

- Installs `autofs` and `nfs-utils` packages via DNF.
- Configures modular master map drop-ins (`/etc/auto.master.d/direct.autofs`).
- Sets configurable idle timeout (default: `120` seconds).
- Manages direct mount maps (`/etc/auto.direct`) supporting paths with spaces, custom permissions, and mount options.
- Automatically handles directory preparation and service reload/restart via handlers.

## Configured Mount Points

| Local Mount Point | Remote NFS Export | Options | Timeout |
|---|---|---|---|
| `/home/liquuid/.@` | `192.168.0.111:/mnt/storage\ b/notwork/.@` | `-fstype=nfs,rw,soft,intr` | 120s |
| `/home/liquuid/Downloads` | `192.168.0.111:/mnt/storage\ b/hydra-downloads` | `-fstype=nfs,rw,soft,intr` | 120s |
| `/home/liquuid/Music` | `192.168.0.111:/mnt/storage/music` | `-fstype=nfs,rw,soft,intr` | 120s |
| `/mnt/isos` | `192.168.0.111:/mnt/storage\ b/software/ISOS` | `-fstype=nfs,ro,soft,intr` | 120s |

## Role Variables

Defined in `defaults/main.yml`:

| Variable | Default | Description |
|---|---|---|
| `autofs_packages` | `['autofs', 'nfs-utils']` | Packages to install |
| `autofs_service_name` | `"autofs"` | Systemd service name |
| `autofs_service_state` | `"started"` | Desired service state |
| `autofs_service_enabled` | `true` | Enable service at boot |
| `autofs_timeout` | `120` | Inactivity timeout in seconds before unmounting |
| `autofs_master_map_d_path` | `"/etc/auto.master.d"` | Path to auto.master.d directory |
| `autofs_master_map_file` | `"direct.autofs"` | Drop-in master configuration filename |
| `autofs_direct_map_path` | `"/etc/auto.direct"` | Path to the direct map file |
| `autofs_default_options` | `"-fstype=nfs,rw,soft,intr"` | Default NFS mount options |
| `autofs_user` | `"{{ user \| default(ansible_user_id) }}"` | Desktop user |
| `autofs_direct_mounts` | *(list)* | List of mount point definitions |

## Example Usage

### Include in `local.yml`

```yaml
- hosts: localhost
  become: true
  roles:
    - common
    - autofs
```

### Customizing Mounts

```yaml
- hosts: localhost
  become: true
  roles:
    - role: autofs
      vars:
        autofs_timeout: 120
        autofs_direct_mounts:
          - path: "/home/liquuid/Downloads"
            location: '192.168.0.111:/mnt/storage\ b/hydra-downloads'
            options: "-fstype=nfs,rw,soft,intr"
```

## Useful Verification Commands

```bash
# Check autofs service status
systemctl status autofs

# Check active autofs mounts
automount -m

# Trigger mount by listing or cd-ing into the directory
ls -la /home/liquuid/Downloads
ls -la /mnt/isos

# Check current mounts
findmnt -t nfs,nfs4
```
