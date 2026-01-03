---

## 1. Objective

The objective of this report is to gather as much publicly available information as possible about the domain **holbertonschool.com** using **Shodan**, focusing on:

- IP ranges associated with the domain
- Technologies and frameworks used across its subdomains

All information was collected using **passive reconnaissance techniques only**.

---

## 2. Methodology

Shodan was used to identify infrastructure, services, and technologies related to **holbertonschool.com** and its subdomains.

The following Shodan search techniques were applied:

- Domain and hostname searches  
- IP and ASN correlation  
- Technology fingerprinting (HTTP headers, TLS, service banners)

No direct interaction with target systems was performed.

---

## 3. IP Ranges and Infrastructure

Based on Shodan data, **holbertonschool.com** relies heavily on **cloud‑based infrastructure** and third‑party services.

### 3.1 Identified Network Providers

The domain and its subdomains are associated with the following providers:

- **Amazon Web Services (AWS)**
  - EC2 instances
  - Elastic Load Balancers
  - CloudFront CDN
- **Cloudflare**
  - Reverse proxy
  - DDoS protection
  - CDN services
- **Google**
  - Mail infrastructure (MX records)

### 3.2 Observed IP Range Categories

Rather than a single fixed IP block, the domain resolves to **multiple IP ranges** belonging to large providers:

- AWS public IP ranges (multiple regions)
- Cloudflare global edge IP ranges
- Google mail server IP ranges

This indicates:
- Load balancing
- High availability
- CDN usage
- Distributed infrastructure

---

## 4. Technologies and Frameworks

Shodan fingerprints reveal multiple technologies used across **holbertonschool.com** subdomains.

### 4.1 Web Servers and Proxies

- **nginx**
- **Cloudflare HTTP proxy**
- **Amazon CloudFront**

### 4.2 Web Technologies

- **HTML5**
- **JavaScript**
- **CSS**
- **React** (observed on frontend‑heavy subdomains)
- **Webflow** (used for marketing / content pages)

### 4.3 Backend & Platforms

- **Ruby on Rails** (apply, staging, assets subdomains)
- **Node.js** (API‑related services)
- **Amazon ALB / ELB**

### 4.4 Security & Networking

- **TLS / HTTPS enforced**
- **Cloudflare WAF**
- **SPF / TXT records for email validation**
- **Google Workspace email services**

---

## 5. Subdomain Technology Distribution

Examples of technologies observed on specific subdomains:

| Subdomain | Technologies |
|---------|-------------|
| www.holbertonschool.com | Cloudflare, Webflow |
| apply.holbertonschool.com | Ruby on Rails, AWS |
| blog.holbertonschool.com | WordPress / CDN |
| support.holbertonschool.com | Cloudflare, Zendesk |
| assets.holbertonschool.com | AWS CloudFront |
| staging.* | AWS, Rails, nginx |

---

## 6. Security Observations

- No exposed databases or admin panels detected via Shodan
- No critical services (SSH, FTP, RDP) publicly exposed
- Infrastructure follows **cloud security best practices**
- Use of CDN and WAF reduces attack surface

---

## 7. Conclusion

The **holbertonschool.com** domain is built on **modern cloud infrastructure**, primarily leveraging **AWS and Cloudflare** for scalability and security.

Shodan reconnaissance indicates:
- Proper segmentation of services
- Use of industry‑standard frameworks
- Minimal direct exposure of sensitive services

Overall, the domain demonstrates a **strong security posture** from an OSINT perspective.

---

## 8. Disclaimer

This report is based solely on **publicly available information** obtained via Shodan and DNS records.  
No active scanning or exploitation techniques were used.

---


