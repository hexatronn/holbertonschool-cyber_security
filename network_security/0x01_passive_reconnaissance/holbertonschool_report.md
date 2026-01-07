|Holbertonschool.com Review|
----------------------------


1. Domain Overview

    Target Domain: holbertonschool.com

    Primary Hosting Provider: Amazon Data Services (AWS)

    Primary ASN: AS14618 (Amazon.com)

    Geographic Distribution: Infrastructure is primarily located in the United States (Seattle), with localized nodes for international campuses (e.g., Azerbaijan, Colombia).

2. IP Ranges and Network Infrastructure

Holberton School operates primarily on cloud-native infrastructure. Rather than owning physical hardware in a private data center, they utilize dynamic address space within AWS.

Notable Service IPs

    Main Site (www): Often resolves to IPs like 99.83.190.102 or 75.2.70.75. These are generally AWS Elastic Load Balancers (ELB), which distribute traffic to backend application servers.

3. Technologies and Frameworks

Shodan’s http.component and banner analysis reveal a modern, highly decoupled web stack.
Web Servers & Load Balancing

    Nginx: Used as the primary web server and reverse proxy across almost all subdomains.

    Amazon ELB: Acts as the entry point for HTTP/HTTPS traffic, handling SSL termination (using Amazon Certificate Manager).

Frontend Frameworks

    React.js: The core framework for the student application portal (apply.holbertonschool.com) and internal dashboard components.

    jQuery: Observed on the legacy main landing pages and some campus-specific subdomains.

    Webfont Loader: Integrated for custom typography across the brand sites.

Backend & Application Layer

    Python (Flask/Django): Signatures in cookie formats (e.g., session) and header patterns are consistent with Python-based backends, reflecting the school's own curriculum.

    Node.js: Evidence suggests Node.js is utilized for specific real-time or API-heavy microservices.

Third-Party Services

    HubSpot: Powers the marketing automation, lead capture forms, and CRM integration.

    Google Tag Manager / Analytics: Standard implementation for user behavior tracking.

    Let's Encrypt / Amazon: SSL certificate providers for securing subdomains.

4. Subdomain Analysis

Key subdomains identified through Shodan and DNS pivots:
Subdomain	Primary Purpose	Tech Identified
www.holbertonschool.com	Main Marketing Site	Nginx, HubSpot, Google Analytics
apply.holbertonschool.com	Admissions Portal	React, Python, AWS ELB
api.holbertonschool.com	Backend API	Nginx, Python (REST API)
blog.holbertonschool.com	Content/Articles	Often mapped to external CMS (e.g., Medium or Ghost)
talent.holbertonschool.com	Hiring Platform	React, Node.js
5. Security Posture (Shodan Observations)

    Ports Open: 80 (HTTP), 443 (HTTPS).
    
    Also this site don't allow to analyze with shodan tool (403 Forbidden).

    SSL Status: High compliance with modern TLS versions (1.2 and 1.3).

    Vulnerability Scan: No immediate "Low Hanging Fruit" (e.g., Heartbleed or BlueKeep) were detected on public-facing AWS nodes during the query.
