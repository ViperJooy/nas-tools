# FROM alpine
# RUN apk add --no-cache libffi-dev \
#     && apk add --no-cache $(echo $(wget --no-check-certificate -qO- https://raw.githubusercontent.com/jxxghp/nas-tools/master/package_list.txt)) \
#     && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
#     && echo "${TZ}" > /etc/timezone \
#     && ln -sf /usr/bin/python3 /usr/bin/python \
#     && curl https://rclone.org/install.sh | bash \
#     && curl https://dl.min.io/client/mc/release/linux-amd64/mc --create-dirs -o /usr/bin/mc \
#     && chmod +x /usr/bin/mc \
#     && pip install --upgrade pip setuptools wheel \
#     && pip install -r https://raw.githubusercontent.com/jxxghp/nas-tools/master/requirements.txt \
#     && apk del libffi-dev \
#     && npm install pm2 -g \
#     && rm -rf /tmp/* /root/.cache /var/cache/apk/*
# ENV LANG="C.UTF-8" \
#     TZ="Asia/Shanghai" \
#     NASTOOL_CONFIG="/config/config.yaml" \
#     NASTOOL_AUTO_UPDATE=true \
#     PS1="\u@\h:\w \$ " \
#     REPO_URL="https://github.com/jxxghp/nas-tools.git" \
#     PUID=0 \
#     PGID=0 \
#     UMASK=000 \
#     WORKDIR="/nas-tools"
# WORKDIR ${WORKDIR}
# RUN python_ver=$(python3 -V | awk '{print $2}') \
#     && echo "${WORKDIR}/" > /usr/lib/python${python_ver%.*}/site-packages/nas-tools.pth \
#     && echo 'fs.inotify.max_user_watches=524288' >> /etc/sysctl.conf \
#     && echo 'fs.inotify.max_user_instances=524288' >> /etc/sysctl.conf \
#     && git config --global pull.ff only \
#     && git clone -b master ${REPO_URL} ${WORKDIR} --recurse-submodule \
#     && git config --global --add safe.directory ${WORKDIR}

# COPY config.yaml /config/config.yaml
# EXPOSE 3000
# # VOLUME ["/config"]
# ENTRYPOINT ["/nas-tools/docker/entrypoint.sh"]


FROM ubuntu

ARG TARGETARCH
COPY ./ttyd /usr/bin/ttyd
RUN apt-get update && apt-get install -y --no-install-recommends tini && rm -rf /var/lib/apt/lists/*
RUN chmod +x /usr/bin/ttyd

EXPOSE 7681
WORKDIR /root

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["ttyd", "bash"]