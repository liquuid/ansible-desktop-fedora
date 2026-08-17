# Lexmark E120 / E120n Ansible Role

Ansible role to install, configure, and manage the **Lexmark E120 / E120n** laser printer on Fedora Linux via CUPS and Gutenprint/PCL.

## Features

- Installs all required CUPS, Gutenprint, Foomatic, and Ghostscript packages.
- Starts and enables the `cups` daemon.
- Configures the printer queue (`lpadmin`) with PCL / Gutenprint driver compatibility.
- Supports both Network (JetDirect/RAW `socket://`, mDNS/Bonjour `dnssd://`) and USB (`usb://`) connections.
- Sets default media format (A4 / Letter).
- Adds the user to the `lp` printer management group.
- Sets the printer as default.

## Role Variables

Defined in `defaults/main.yml`:

| Variable | Default | Description |
|---|---|---|
| `lexmark_e120_printer_name` | `"Lexmark_E120"` | Queue name in CUPS |
| `lexmark_e120_description` | `"Lexmark E120 Laser Printer"` | Human-readable printer name |
| `lexmark_e120_location` | `"Local / Network"` | Location string |
| `lexmark_e120_device_uri` | `"socket://192.168.0.32"` | Device connection URI |
| `lexmark_e120_driver` | `"gutenprint.5.3://lexmark-optra_eplus/expert"` | PPD driver string |
| `lexmark_e120_page_size` | `"A4"` | Default paper size (`A4`, `Letter`) |
| `lexmark_e120_set_default` | `true` | Set as system default printer |
| `lexmark_e120_state` | `"present"` | `"present"` to add/maintain, `"absent"` to remove |
| `lexmark_e120_user` | `"{{ user \| default(ansible_user_id) }}"` | User to add to `lp` group |

### Connection URI Examples

- **Network (Socket/RAW 9100)**: `socket://192.168.0.32` or `socket://<printer-ip>:9100`
- **Network (mDNS/dnssd)**: `dnssd://Lexmark%20E120n._printer._tcp.local/`
- **USB**: `usb://Lexmark/E120` (check via `lpinfo -v`)

### Driver Options

- **Gutenprint Optra E+ (Recommended)**: `gutenprint.5.3://lexmark-optra_eplus/expert`
- **Generic PCL Laser Printer**: `drv:///sample.drv/generpcl.ppd`
- **Gutenprint Optra E220**: `gutenprint.5.3://lexmark-optra_e220/expert`

## Example Playbook

```yaml
- hosts: localhost
  become: true
  roles:
    - role: lexmark-e120
      vars:
        lexmark_e120_device_uri: "socket://192.168.0.32"
        lexmark_e120_page_size: "A4"
```

## Useful CLI Verification Commands

```bash
# Check printer status
lpstat -p -d

# Print a test page
echo "Lexmark E120 test print from Fedora" | lp -d Lexmark_E120

# Open CUPS web interface
xdg-open http://localhost:631/printers/Lexmark_E120
```
