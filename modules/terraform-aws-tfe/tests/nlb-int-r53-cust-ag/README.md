# nlb-int-r53-cust-ag
This deployment scenario is geared towards a more locked down network and stringent security posture, and leverages the following configurations:

| Configuration                   | Choice                      |
|---------------------------------|-----------------------------|
| Load Balancer Type              | Network Load Balancer (nlb) |
| Load Balancer Scheme (exposure) | Internal (int)              |
| DNS service                     | Route53 (r53)               |
| TLS/SSL Certificate service     | Custom (cust)               |
| Installation Method             | Airgap (ag)                 |
<p>&nbsp;</p>

## Ideal Use Case
- Version Control System (VCS) and other interfacing tools are hosted internally
- TFE is to be hosted on a private/internal network with no connectivity to the public Internet
- Security posture is to terminate TLS at the instance-level rather than the load balancer-level
- A private Certificate Authority is to be used to issue cert rather than AWS Certificate Manager (ACM)
