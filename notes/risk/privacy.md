# Privacy, authorization

For this discussion, we consider only privacy in the limited sense of "external actors cannot read the objects a client uploads without permission."

Centralised service providers generally must comply with various standards (ISO etc.) governing privacy. Applicability of standards depend on the type of data, i.e. is it "personal data." Other (legal) rules may compel providers to *reveal* data to authorities.

In decentralised storage, privacy is generally approached with client-side encryption. It is often the responsibility of the user to pre-encrypt data, or at best, this step is integrated into client software. 

With standard encryption methods, read access to files is governed by possession of a single keypair; more complex sharing or access control requires more sophisticated approaches.

## Resources

* Swarm ACT. https://docs.ethswarm.org/docs/concepts/access-control


### Standards relevant to privacy

* ISO 27001
* ISO 27018 https://aws.amazon.com/compliance/data-privacy-faq/
* AICPA SOC [2]. Controls at a service organization relevant to security, availability, processing integrity, confidentiality, or privacy.
  https://d1.awsstatic.com/whitepapers/compliance/AWS_SOC3.pdf
* ISO 22301
* HIPAA (Health Insurance Portability and Accountability Act). Lawful use and disclosure of protected health information in the United States.
* PCI DSS (Payment Card Industry Data Security Standard)

