## About

This is a stand-alone containerized Traefik installation for local development. It allows for working with multiple
containerized projects that need to communicate with each other. This project is inspired
by [Fleet](https://github.com/aschmelyun/fleet) and uses the latest version of Traefik.

## Usage

Just run `docker compose up -d` and you're good to go! If you want HTTPS, follow the instructions below.
There are also `up.sh` and `down.sh` scripts to make it easier to manage the containers, use them as you like.

## Local HTTPS with mkcert

This guide walks you through generating a locally trusted wildcard certificate for `*.localhost`
using [mkcert](https://github.com/FiloSottile/mkcert).

### Prerequisites

#### macOS

```bash
brew install mkcert
```

#### Ubuntu / Debian

```bash
sudo apt install libnss3-tools
sudo apt install mkcert
```

#### Windows

```powershell
choco install mkcert
# or
scoop bucket add extras
scoop install mkcert
```

---

### Step 1: Install the Local CA

This installs mkcert's Certificate Authority into your system's trust store so your browser trusts the generated certs.

```bash
mkcert -install
```

> ⚠️ You may be prompted for your password. This only needs to be done **once** per machine.

---

### Step 2: Generate the Wildcard Certificate

Navigate to the `./certs` directory and generate a wildcard cert for `*.localhost`:

```bash
cd ./certs
mkcert "*.localhost"
```

This generates two files:

* `_wildcard.localhost.pem` — the certificate

* `_wildcard.localhost-key.pem` — the private key

---

### Step 3: Configure Traefik TLS

Make sure your `./config/tls.yml` references the generated files:

```yaml
tls:
  certificates:
    - certFile: /certs/_wildcard.localhost.pem
      keyFile: /certs/_wildcard.localhost-key.pem
```

---

### Step 4: Start Traefik

```bash
docker compose up -d
```

Your services should now be accessible over HTTPS at `https://your-project.localhost` with **no browser warnings**! 🎉

---

### Notes

* `.localhost` subdomains automatically resolve to `127.0.0.1` — no `/etc/hosts` changes needed.

* The wildcard cert covers **all** `*.localhost` subdomains, so you never need to regenerate it when adding new
  projects.

* The local CA is machine-specific — each team member must run `mkcert -install` and generate their own certs locally.