FROM ubuntu:22.04
RUN apt-get update && apt-get install openssh-client -y

COPY configs/id_ed25519 /root/.ssh/
COPY configs/id_ed25519.pub /root/.ssh/
COPY configs/known_hosts /root/.ssh/
RUN chmod 0700 /root/.ssh && chmod 0644 /root/.ssh/id_ed25519.pub && chmod 0600 /root/.ssh/id_ed25519 && chmod 0600 /root/.ssh/known_hosts

COPY JOIntegration-1.0-SNAPSHOT-jar-with-dependencies.jar ./app.jar

ENTRYPOINT /bin/bash