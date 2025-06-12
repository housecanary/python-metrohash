FROM docker-repo.housecanary.net/bitnami/minideb:bookworm

ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
  apt-get install -y \
    # For building deps that are source-only
    build-essential \
    # Python
    python3-pip \
    python3-dev \
    python3-setuptools \
    libpython3-dev \
    ca-certificates \
    libssl-dev

ADD test_requirements.txt .
RUN pip3 install --index-url https://nexus.housecanary.net/repository/pypi-all/simple/ --no-cache-dir \
    --break-system-packages --upgrade -r test_requirements.txt

CMD ["pytest", "tests"]
