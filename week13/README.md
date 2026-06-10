

### Parameter Mapping Table

|**Setting**|**Project A (Dallas)**|**Project B (Mexico)**|
|---|---|---|
|**VPC Name**|`my-vpn-network`|`my-vpn-ip-2`|
|**Subnet CIDR**|`10.30.0.0/16`|`10.72.0.0/16`|
|**Gateway Static IP**|`[Paste IP A Here]`|`[Paste IP B Here]`|
|**Peer Gateway IP**|`[Paste IP B Here]`|`[Paste IP A Here]`|
|**Shared Secret**|`89GL1/VbuTS9LvbH7AVFhj60W6SScKNi`|`89GL1/VbuTS9LvbH7AVFhj60W6SScKNi`|
|**Remote Subnet**|`10.72.0.0/16`|`10.30.0.0/16`|
### Runbook: Site-to-Site Classic VPN (Dual-Account)

#### Phase 1: Infrastructure Setup (Repeat for both Project A and Project B)

1. **VPC Network:**
    
    - Navigate to **VPC network** > **Create VPC network**.
        
    - **Name:** `my-vpn-network` (Unique to the project).
        
    - **Subnet:** Custom mode > **Name:** `subnet-1` > **Region:** Select target region > **IPv4 Range:** `10.30.0.0/16` (Ensure this is unique for each VPC to avoid routing conflicts).
        
    - Click **Create**.
        

#### Phase 2: VPN Configuration

1. **VPN Gateway:**
    
    - Search for **Network Connectivity Center** > **VPN** > **Create VPN connection**.
        
    - Select **Classic VPN** > **Continue**.
        
    - **Name:** `vpn-gateway-1`.
        
    - **Network:** `my-vpn-network`.
        
    - **Region:** Matches the VPC subnet region.
        
    - **IP Address:** Create a new **Static** External IP. (Note this IP address—it is the "Peer IP" for the _other_ VPC).
        
2. **VPN Tunnels:**
    
    - **Name:** `vpn-tunnel-1`.
        
    - **Remote Peer IP:** Enter the static IP created for the _other_ VPC’s gateway.
        
    - **IKE Pre-shared Key:** Use a shared string (e.g., `89GL1/VbuTS9LvbH7AVFhj60W6SScKNi`). _Ensure both accounts use the exact same key._
        
3. **Routing Options:**
    
    - **Remote network IP ranges:** Enter the CIDR range of the _other_ VPC's subnet (e.g., `10.224.0.0/16`).
        

#### Phase 3: Firewall Rules (Critical for Traffic)

_You must allow internal traffic and ESP/UDP traffic for the tunnel to function._

1. **Create Rule 1 (Tunnel Traffic):**
    
    - **Name:** `allow-vpn-tunnel`.
        
    - **Direction:** Ingress.
        
    - **Action:** Allow.
        
    - **Source IP ranges:** The Public IP of the _remote_ VPN Gateway.
        
    - **Protocols and ports:** UDP 500, UDP 4500, and ESP.
        
2. **Create Rule 2 (Internal Traffic):**
    
    - **Name:** `allow-internal-traffic`.
        
    - **Direction:** Ingress.
        
    - **Action:** Allow.
        
    - **Source IP ranges:** The remote VPC subnet range (e.g., `10.224.0.0/16`).
        
    - **Protocols and ports:** All protocols.
        

#### Phase 4: Compute Deployment

1. **VM Instance:**
    
    - **Name:** `vm-1` (or `vm-2` for the second account).
        
    - **Region:** Must match your VPC subnet region.
        
    - **Networking:** Under **Advanced configurations**, ensure the network is set to your custom `my-vpn-network`.
        
    - **Check:** "Allow HTTP/HTTPS traffic" (optional, for testing).
        
    - **Click Create.**
        

### Verification Steps

Run these commands from the terminal:

1. **Connectivity Check:**
    
    Bash
    
    ```
    ping <Internal-IP-of-Remote-VM>
    ```
    
2. **Path Verification:**
    
    Bash
    
    ```
    sudo apt install mtr -y
    mtr -rw <Internal-IP-of-Remote-VM>
    ```
    

### Phase 5: Tear Down (Cleanup)

_To avoid ongoing costs, follow this order to ensure all dependent resources are removed._

1. **Delete VPN Tunnels:**
    
    - Navigate to **Network Connectivity Center** > **VPN** > **VPN tunnels**.
        
    - Select `vpn-tunnel-1` and click **Delete**.
        
2. **Delete VPN Gateways:**
    
    - In the same pane, click the **VPN Gateways** tab.
        
    - Select your gateway (e.g., `vpn-2`) and click **Delete**.
        
3. **Release Static IPs:**
    
    - Navigate to **VPC network** > **IP addresses**.
        
    - Find the static IP addresses you reserved for your VPN Gateways.
        
    - Select them and click **Release static IP address**. (Crucial step: Reserved but unused IPs cost money).
        
4. **Delete VM Instances:**
    
    - Navigate to **Compute Engine** > **VM instances**.
        
    - Select your VMs and click **Delete**.
        
5. **Delete VPC Network:**
    
    - Navigate to **VPC network**.
        
    - Select `my-vpn-network` and click **Delete**.