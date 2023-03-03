FROM busybox:1.35.0-uclibc as busybox
FROM python:3.8.0

# Setup python virtualenv.
RUN echo python3 --version
RUN python3 -m venv env
ENV VIRTUAL_ENV=/home/fbox/env
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY pip.conf $VIRTUAL_ENV/pip.conf
ENV PIP_CONFIG_FILE $VIRTUAL_ENV/pip.conf

RUN pip install \
    mlflow==2.0.1 \
        pymysql==1.0.2 \
    boto3 && \
    mkdir /mlflow/


# Now copy the static shell into base image.
COPY --from=busybox /bin/sh /bin/sh
# You may also copy all necessary executables into distroless image.
COPY --from=busybox /bin/mkdir /bin/mkdir
COPY --from=busybox /bin/cat /bin/cat


EXPOSE 5000
