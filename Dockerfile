FROM ubuntu:20.04
#FROM docker.io/library/ubuntu:16.04
#FROM 10.0.1.150:5000/sjjeon/podman

RUN apt-get update \
    && echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list \
    && curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key | apt-key add - \
    && apt-get update \
    && apt-get -y upgrade
    && apt-get -y install podman \
    && apt-get install -y iptables

#RUN apt-get update -qq \
#    && apt-get install -qq -y software-properties-common uidmap \
#    && add-apt-repository -y ppa:projectatomic/ppa \
#    && apt-get update -qq \
#    && apt-get -qq -y install podman \
#    && apt-get install -y iptables

COPY . .

# Change default storage driver to vfs
RUN sed -i "s/overlay/vfs/g" /etc/containers/storage.conf

RUN echo "nameserver 8.8.8.8" >> /etc/resolv.conf

# Add docker.io as a search registry
#RUN sed -i '0,/\[\]/s/\[\]/["docker.io"]/' /etc/containers/registries.conf
# test
