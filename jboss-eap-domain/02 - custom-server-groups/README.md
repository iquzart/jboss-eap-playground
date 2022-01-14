# JBoss EAP 7.2.9 Containers with custom Server Groups and server instances


```
1. jgroup - TCP with TCPPING
2. Server Groups (development-server-group, production-server-group)
3. Nginx revers proxy 
```


# Topology

| Hostname | development-server-group | production-server-group |
| --- | --- | --- |
| jboss-eap-node-dc | dev-instance-01 | NA | 
| jboss-eap-node-01 | NA | instance-01 |
| jboss-eap-node-02 | NA | instance-01 | 
| jboss-eap-node-03 | NA | instance-01 | 
| jboss-eap-node-04 | dev-instance-02 | NA |

