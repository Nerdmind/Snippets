VirtualHost "xmpp.hostname.tld"
ssl = {
	key = "/etc/certificates/prosody/xmpp.hostname.tld/confidential.pem";
	certificate = "/etc/certificates/prosody/xmpp.hostname.tld/certificate_full.pem";
	ciphers = "ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA";
}