FROM pytorch/pytorch:2.8.0-cuda12.8-cudnn9-devel
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8
RUN rm -f /etc/apt/apt.conf.d/docker-clean && echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt apt update &&\
    apt install -y \
    git \
    ffmpeg
WORKDIR /app
COPY --chown=1000:1000 . /app
RUN chown 1000:1000 /app
RUN --mount=type=cache,target=/root/.cache pip install uv
RUN useradd -m -u 1000 ubuntu
USER 1000:1000
RUN mkdir -p /home/ubuntu/.cache
RUN --mount=type=cache,target=/home/ubuntu/.cache,uid=1000,gid=1000 uv sync
ENTRYPOINT ["uv", "run", "acestep"]
