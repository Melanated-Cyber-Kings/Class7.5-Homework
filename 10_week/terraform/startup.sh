#!/bin/bash
set -euo pipefail

#Chewbacca: The node awakens. And it will speak in HTML, plain text, and JSON.

#Thanks for Aaron!
sleep 5
apt update -y
apt install -y nginx curl jq

METADATA="http://metadata.google.internal/computeMetadata/v1"
HDR="Metadata-Flavor: Google"
md() { curl -fsS -H "$HDR" "${METADATA}/$1" || echo "unknown"; }

INSTANCE_NAME="$(md instance/name)"
HOSTNAME="$(hostname)"
PROJECT_ID="$(md project/project-id)"
ZONE_FULL="$(md instance/zone)"                  # projects/<id>/zones/us-central1-a
ZONE="${ZONE_FULL##*/}"
REGION="${ZONE%-*}"
MACHINE_TYPE_FULL="$(md instance/machine-type)"
MACHINE_TYPE="${MACHINE_TYPE_FULL##*/}"

INTERNAL_IP="$(md instance/network-interfaces/0/ip)"
EXTERNAL_IP="$(md instance/network-interfaces/0/access-configs/0/external-ip)"
VPC_FULL="$(md instance/network-interfaces/0/network)"
SUBNET_FULL="$(md instance/network-interfaces/0/subnetwork)"
VPC="${VPC_FULL##*/}"
SUBNET="${SUBNET_FULL##*/}"

START_TIME_UTC="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

# --- Student banner ---
# Students set this when creating the VM by adding a metadata key:
#   student_name = Darth Malgus Jr
STUDENT_NAME="$(md instance/attributes/student_name)"
[[ -z "$STUDENT_NAME" || "$STUDENT_NAME" == "unknown" ]] && STUDENT_NAME="Anonymous Padawan (temporarily)"

# --- Basic system stats ---
UPTIME="$(uptime -p || true)"
LOADAVG="$(awk '{print $1" "$2" "$3}' /proc/loadavg 2>/dev/null || echo "unknown")"

MEM_TOTAL_MB="$(free -m | awk '/Mem:/ {print $2}')"
MEM_USED_MB="$(free -m | awk '/Mem:/ {print $3}')"
MEM_FREE_MB="$(free -m | awk '/Mem:/ {print $4}')"

DISK_LINE="$(df -h / | tail -n 1)"
DISK_SIZE="$(echo "$DISK_LINE" | awk '{print $2}')"
DISK_USED="$(echo "$DISK_LINE" | awk '{print $3}')"
DISK_AVAIL="$(echo "$DISK_LINE" | awk '{print $4}')"
DISK_USEP="$(echo "$DISK_LINE" | awk '{print $5}')"

# --- Nginx config: add endpoints /healthz and /metadata ---
cat > /etc/nginx/sites-available/default <<'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html;

    #Chewbacca: The homepage is for humans.
    location = / {
        try_files /index.html =404;
    }

    #Chewbacca: Health checks are for machines. Keep it boring.
    location = /healthz {
        default_type text/plain;
        return 200 "ok\n";
    }

    #Chewbacca: Metadata is for engineers and scripts.
    location = /metadata {
        default_type application/json;
        try_files /metadata.json =404;
    }
}
EOF

# --- Write JSON endpoint file ---
cat > /var/www/html/metadata.json <<EOF
{
  "service": "seir-i-node",
  "student_name": "$(echo "$STUDENT_NAME" | sed 's/"/\\"/g')",
  "project_id": "$PROJECT_ID",
  "instance_name": "$INSTANCE_NAME",
  "hostname": "$HOSTNAME",
  "region": "$REGION",
  "zone": "$ZONE",
  "machine_type": "$MACHINE_TYPE",
  "network": {
    "vpc": "$VPC",
    "subnet": "$SUBNET",
    "internal_ip": "$INTERNAL_IP",
    "external_ip": "$EXTERNAL_IP"
  },
  "health": {
    "uptime": "$UPTIME",
    "load_avg": "$LOADAVG",
    "ram_mb": {"used": $MEM_USED_MB, "free": $MEM_FREE_MB, "total": $MEM_TOTAL_MB},
    "disk_root": {"size": "$DISK_SIZE", "used": "$DISK_USED", "avail": "$DISK_AVAIL", "use_pct": "$DISK_USEP"}
  },
  "startup_utc": "$START_TIME_UTC"
}
EOF

# --- Write the main HTML dashboard ---
cat > /var/www/html/index.html <<EOF
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>SEIR-NetRunner</title>
        <meta http-equiv="refresh" content="10" />
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link
            href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=DM+Mono:wght@400;500&display=swap"
            rel="stylesheet"
        />
        <style>
            :root {
                --bg: #0d0f14;
                --surface: #161820;
                --border: #2a2d3a;
                --gold: #f5c842;
                --coral: #ff6b6b;
                --teal: #43d9ad;
                --lavender: #a78bfa;
                --sky: #60c8f5;
                --text: #e8eaf0;
                --muted: #6b7080;
                --font-head: 'Playfair Display', Georgia, serif;
                --font-mono: 'DM Mono', 'Courier New', monospace;
            }

            *,
            *::before,
            *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                background: var(--bg);
                color: var(--text);
                font-family: var(--font-mono);
                font-size: 13px;
                min-height: 100vh;
                overflow-x: hidden;
            }

            /* Subtle gradient orbs in the background */
            body::before {
                content: '';
                position: fixed;
                top: -200px;
                left: -200px;
                width: 600px;
                height: 600px;
                background: radial-gradient(
                    circle,
                    rgba(167, 139, 250, 0.08) 0%,
                    transparent 70%
                );
                pointer-events: none;
                z-index: 0;
            }
            body::after {
                content: '';
                position: fixed;
                bottom: -200px;
                right: -200px;
                width: 600px;
                height: 600px;
                background: radial-gradient(
                    circle,
                    rgba(67, 217, 173, 0.07) 0%,
                    transparent 70%
                );
                pointer-events: none;
                z-index: 0;
            }

            .wrap {
                position: relative;
                z-index: 1;
                max-width: 1000px;
                margin: 0 auto;
                padding: 40px 24px 60px;
            }

            /* ── Header ── */
            .header {
                margin-bottom: 32px;
            }
            .header-eyebrow {
                font-family: var(--font-mono);
                font-size: 11px;
                letter-spacing: 0.18em;
                text-transform: uppercase;
                color: var(--gold);
                margin-bottom: 8px;
            }
            .header h1 {
                font-family: var(--font-head);
                font-size: clamp(26px, 4vw, 42px);
                font-weight: 900;
                line-height: 1.1;
                background: linear-gradient(
                    135deg,
                    var(--gold) 0%,
                    var(--coral) 50%,
                    var(--lavender) 100%
                );
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                margin-bottom: 10px;
            }
            .header-sub {
                color: var(--muted);
                font-size: 12px;
                letter-spacing: 0.04em;
            }

            /* ── Status banner ── */
            .banner {
                display: flex;
                flex-wrap: wrap;
                align-items: center;
                gap: 8px 20px;
                background: var(--surface);
                border: 1px solid var(--border);
                border-left: 3px solid var(--gold);
                border-radius: 8px;
                padding: 12px 18px;
                margin-bottom: 28px;
                font-size: 12px;
            }
            .banner-item {
                display: flex;
                gap: 6px;
                align-items: center;
            }
            .pill {
                display: inline-block;
                padding: 2px 10px;
                border-radius: 20px;
                font-size: 11px;
                font-weight: 500;
                letter-spacing: 0.06em;
            }
            .pill-green {
                background: rgba(67, 217, 173, 0.15);
                color: var(--teal);
            }
            .pill-gold {
                background: rgba(245, 200, 66, 0.12);
                color: var(--gold);
            }
            .pill-purple {
                background: rgba(167, 139, 250, 0.14);
                color: var(--lavender);
            }

            /* ── Section label ── */
            .section-label {
                font-size: 10px;
                letter-spacing: 0.16em;
                text-transform: uppercase;
                color: var(--muted);
                margin-bottom: 12px;
                padding-left: 2px;
            }

            /* ── Grid ── */
            .grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 14px;
                margin-bottom: 14px;
            }
            @media (max-width: 600px) {
                .grid {
                    grid-template-columns: 1fr;
                }
            }

            /* ── Cards ── */
            .card {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: 10px;
                padding: 18px 20px;
                transition: border-color 0.2s;
            }
            .card:hover {
                border-color: #3a3d52;
            }

            .card-title {
                font-size: 10px;
                letter-spacing: 0.15em;
                text-transform: uppercase;
                font-weight: 500;
                margin-bottom: 14px;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .card-title .dot {
                width: 7px;
                height: 7px;
                border-radius: 50%;
                flex-shrink: 0;
            }

            .row {
                display: flex;
                justify-content: space-between;
                align-items: baseline;
                padding: 5px 0;
                border-bottom: 1px solid rgba(255, 255, 255, 0.04);
                gap: 12px;
            }
            .row:last-child {
                border-bottom: none;
            }
            .row-key {
                color: var(--muted);
                font-size: 11px;
                white-space: nowrap;
            }
            .row-val {
                color: var(--text);
                font-size: 12px;
                text-align: right;
                word-break: break-all;
            }

            /* ── RAM bar ── */
            .ram-bar-wrap {
                margin-top: 10px;
                height: 5px;
                background: rgba(255, 255, 255, 0.06);
                border-radius: 3px;
                overflow: hidden;
            }
            .ram-bar-fill {
                height: 100%;
                border-radius: 3px;
                background: linear-gradient(90deg, var(--teal), var(--sky));
                width: %;
            }

            /* ── Endpoints card (full width) ── */
            .card-wide {
                grid-column: 1 / -1;
            }
            .endpoints {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
                margin-top: 4px;
            }
            .endpoint-link {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 6px 14px;
                border-radius: 6px;
                font-size: 12px;
                text-decoration: none;
                border: 1px solid var(--border);
                transition: all 0.2s;
            }
            .endpoint-link:hover {
                border-color: var(--gold);
                color: var(--gold);
                background: rgba(245, 200, 66, 0.06);
            }
            .endpoint-link.teal {
                color: var(--teal);
                border-color: rgba(67, 217, 173, 0.3);
            }
            .endpoint-link.sky {
                color: var(--sky);
                border-color: rgba(96, 200, 245, 0.3);
            }
            .endpoint-link.coral {
                color: var(--coral);
                border-color: rgba(255, 107, 107, 0.3);
            }
            .endpoint-link .badge {
                font-size: 9px;
                padding: 1px 6px;
                border-radius: 4px;
                letter-spacing: 0.08em;
                text-transform: uppercase;
                opacity: 0.75;
            }
            .endpoint-link.teal .badge {
                background: rgba(67, 217, 173, 0.15);
            }
            .endpoint-link.sky .badge {
                background: rgba(96, 200, 245, 0.15);
            }
            .endpoint-link.coral .badge {
                background: rgba(255, 107, 107, 0.15);
            }

            /* ── Image Gallery ── */
            .gallery-section {
                margin-top: 32px;
            }
            .gallery {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 14px;
            }
            @media (max-width: 600px) {
                .gallery {
                    grid-template-columns: 1fr;
                }
            }
            .gallery-item {
                border: 1px solid var(--border);
                border-radius: 10px;
                overflow: hidden;
                background: var(--surface);
                transition:
                    border-color 0.2s,
                    transform 0.2s;
            }
            .gallery-item:hover {
                border-color: var(--gold);
                transform: translateY(-2px);
            }
            .gallery-item img {
                width: 100%;
                height: 220px;
                object-fit: cover;
                display: block;
            }

            /* ── Footer ── */
            .footer {
                margin-top: 28px;
                padding-top: 18px;
                border-top: 1px solid var(--border);
                display: flex;
                justify-content: space-between;
                flex-wrap: wrap;
                gap: 8px;
                font-size: 11px;
                color: var(--muted);
            }
            .footer span {
                letter-spacing: 0.04em;
            }

            /* Color accents per card */
            .accent-gold {
                color: var(--gold);
            }
            .accent-teal {
                color: var(--teal);
            }
            .accent-coral {
                color: var(--coral);
            }
            .accent-sky {
                color: var(--sky);
            }
            .accent-purple {
                color: var(--lavender);
            }
        </style>
    </head>
    <body>
        <div class="wrap">
            <!-- Header -->
            <header class="header">
                <div class="header-eyebrow">
                    ✦ GCP Compute Instance Dashboard
                </div>
                <h1>SEIR-NetRunner</h1>
                <div class="header-sub">
                    Node is online · Auto-refresh every 10s
                </div>
            </header>

            <!-- Banner -->
            <div class="banner">
                <div class="banner-item">
                    <span class="pill pill-green">● ONLINE</span>
                </div>
                <div class="banner-item">
                    <span style="color: var(--muted); font-size: 11px"
                        >Delegate:</span
                    >
                    <strong style="color: var(--text)"
                        >Thomas Bell</strong
                    >
                </div>
                <div class="banner-item">
                    <span style="color: var(--muted); font-size: 11px"
                        >Started:</span
                    >
                    <span class="pill pill-gold">${START_TIME_UTC}</span>
                </div>
                <div class="banner-item" style="margin-left: auto">
                    <span class="pill pill-purple">↻ 10s refresh</span>
                </div>
            </div>

            <!-- Grid -->
            <div class="section-label">Infrastructure Details</div>
            <div class="grid">
                <!-- Identity -->
                <div class="card">
                    <div class="card-title accent-gold">
                        <span class="dot" style="background: var(--gold)"></span
                        >Identity
                    </div>
                    <div class="row">
                        <span class="row-key">Project</span
                        ><span class="row-val">${PROJECT_ID}</span>
                    </div>
                    <div class="row">
                        <span class="row-key">Instance</span
                        ><span class="row-val">${INSTANCE_NAME}</span>
                    </div>
                    <div class="row">
                        <span class="row-key">Hostname</span
                        ><span class="row-val">${HOSTNAME}</span>
                    </div>
                    <div class="row">
                        <span class="row-key">Machine Type</span
                        ><span class="row-val">${MACHINE_TYPE}</span>
                    </div>
                </div>

                <!-- Location -->
                <div class="card">
                    <div class="card-title accent-coral">
                        <span
                            class="dot"
                            style="background: var(--coral)"
                        ></span
                        >Location &amp; Status
                    </div>
                    <div class="row">
                        <span class="row-key">Region</span
                        ><span class="row-val">${REGION}</span>
                    </div>
                    <div class="row">
                        <span class="row-key">Zone</span
                        ><span class="row-val">${ZONE}</span>
                    </div>
                    <div class="row">
                        <span class="row-key">Uptime</span
                        ><span class="row-val">${UPTIME}</span>
                    </div>
                    <div class="row">
                        <span class="row-key">Load Avg</span
                        ><span class="row-val">${LOADAVG}</span>
                    </div>
                </div>

                <!-- Network -->
                <div class="card">
                    <div class="card-title accent-teal">
                        <span class="dot" style="background: var(--teal)"></span
                        >Network
                    </div>
                    <div class="row">
                        <span class="row-key">VPC</span
                        ><span class="row-val">${VPC}</span>
                    </div>
                    <div class="row">
                        <span class="row-key">Subnet</span
                        ><span class="row-val">${SUBNET}</span>
                    </div>
                    <div class="row">
                        <span class="row-key">Internal IP</span
                        ><span class="row-val">${INTERNAL_IP}</span>
                    </div>
                    <div class="row">
                        <span class="row-key">External IP</span
                        ><span class="row-val">${EXTERNAL_IP}</span>
                    </div>
                </div>

                <!-- System Resources -->
                <div class="card">
                    <div class="card-title accent-sky">
                        <span class="dot" style="background: var(--sky)"></span
                        >System Resources
                    </div>
                    <div class="row">
                        <span class="row-key">RAM Used</span
                        ><span class="row-val" style="color: var(--teal)"
                            >${MEM_USED_MB}</span
                        >
                    </div>
                    <div class="row">
                        <span class="row-key">RAM Free</span
                        ><span class="row-val">${MEM_FREE_MB} </span>
                    </div>
                    <div class="row">
                        <span class="row-key">RAM Total</span
                        ><span class="row-val">${MEM_TOTAL_MB}</span>
                    </div>
                    <div class="ram-bar-wrap">
                        <div class="ram-bar-fill"></div>
                    </div>
                    <div class="row" style="margin-top: 10px">
                        <span class="row-key">Disk Used</span
                        ><span class="row-val">${DISK_USED} / ${DISK_USEP}</span>
                    </div>
                    <div class="row">
                        <span class="row-key">Disk Avail</span
                        ><span class="row-val">${DISK_AVAIL}</span>
                    </div>
                </div>

                <!-- Endpoints (full width) -->
                <div class="card card-wide">
                    <div class="card-title accent-purple">
                        <span
                            class="dot"
                            style="background: var(--lavender)"
                        ></span
                        >Service Endpoints
                    </div>
                    <div class="endpoints">
                        <a href="/" class="endpoint-link teal">
                            / <span class="badge">HTML</span>
                        </a>
                        <a href="/healthz" class="endpoint-link sky">
                            /healthz <span class="badge">text</span>
                        </a>
                        <a href="/metadata" class="endpoint-link coral">
                            /metadata <span class="badge">JSON</span>
                        </a>
                    </div>
                </div>
            </div>
            <!-- /grid -->

            <!-- Image Gallery -->
            <div class="gallery-section">
                <div class="section-label">NetRunner Gallery</div>
                <div class="gallery">
                    <div class="gallery-item">
                        <img
                            src="https://deadline.com/wp-content/uploads/2025/10/jeff-bridges-tron-ares.jpg"
                            alt="Gallery image 1"
                            loading="lazy"
                        />
                    </div>
                    <div class="gallery-item">
                        <img
                            src="https://sm.ign.com/t/ign_pk/review/t/tron-ares-/tron-ares-review_ecfd.1200.jpg"
                            alt="Gallery image 2"
                            loading="lazy"
                        />
                    </div>
                    <div class="gallery-item">
                        <img
                            src="https://i0.wp.com/blexmedia.com/wp-content/uploads/2025/04/News-website-78.png?fit=800%2C450&ssl=1"
                            alt="Gallery image 3"
                            loading="lazy"
                        />
                    </div>
                </div>
            </div>

            <!-- Footer -->
            <div class="footer">
                <span
                    >SEIR-NetRunner · GCP Lab Node</span
                >
                <span
                    >Humans read the dashboard · Machines trust /healthz ·
                    Engineers curl /metadata</span
                >
            </div>
        </div>
    </body>
</html>
EOF

systemctl enable nginx >/dev/null 2>&1 || true
systemctl restart nginx

#Chewbacca: Proof in terminal too.
echo "OK: SEIR-I node deployed."
echo "Try:"
echo "  curl -s localhost/healthz"
echo "  curl -s localhost/metadata | jq ."