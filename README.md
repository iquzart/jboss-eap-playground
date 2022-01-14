# JBoss EAP 7 Playground

The repo is for local development and eap infrastructure tests


```
1. Standalone -> jboss-eap-standalone
2. Domain   -> jboss-eap-domain
```

## Build JBoss EAP Conainer Image

step: 1
Download the zip installer and pach for the jboss-eap 7.
 
step: 2 
```
docker build -t diquzart/jboss-eap:7.2.9 -f .\Containerfile .
```

step: 3
Update docker-compose file and run.
- standalone
```
docker-compose.exe -f .\docker-compose.yaml-standalone up
```

- Domain
```
docker-compose.exe -f .\docker-compose.yaml-domain up
```
