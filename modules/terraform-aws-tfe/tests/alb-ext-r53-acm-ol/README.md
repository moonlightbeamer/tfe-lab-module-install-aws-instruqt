# alb-ext-r53-acm-ol
This is the "happy path" deployment scenario that leverages the following configurations:

| Configuration                   | Choice                          |
|---------------------------------|---------------------------------|
| Load Balancer Type              | Application Load Balancer (alb) |
| Load Balancer Scheme (exposure) | External (ext)                  |
| DNS service                     | Route53 (r53)                   |
| TLS/SSL Certificate service     | AWS Certificate Manager (acm)   |
| Installation Method             | Online (ol)                     |
<p>&nbsp;</p>

## Ideal Use Case
- Version Control System (VCS) and/or CI/CD tooling is a hosted SaaS (external-facing)
- EC2 instance in VPC has egress connectivity to Internet
- Desirable to use only AWS services (including DNS and TLS/SSL)
- Desirable to automate as much of the TFE deployment and installation as possible in a single Terraform run
- Able to use Amazon Route53 Hosted Zone that is of the type **public** for DNS certificate validation with ACM
- Able to use AWS Certificate Manager (ACM) to automatically create and validate TLS/SSL certificate
