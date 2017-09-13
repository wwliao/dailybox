FROM lbwang/dailybox

ARG DEBIAN_FRONTEND=noninteractive

# Set up Google Cloud SDK
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-transport-https gnupg2 && \
    export CLOUD_SDK_REPO="cloud-sdk-stretch" && \
    echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" > /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && \
    apt-get install -y google-cloud-sdk kubectl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/log/dpkg.log && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true
