# Nelson Dane

# Build from the playwright image
FROM mcr.microsoft.com/playwright:v1.43.1-jammy
# Set ENV variables
ENV TZ=America/New_York
ENV DEBIAN_FRONTEND=noninteractive

# Default display to :99
ENV DISPLAY :99

# CD into app
WORKDIR /app

# Install python, pip, and tzdata
RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb \
    xfonts-cyrillic \
    xfonts-100dpi \
    xfonts-75dpi \
    xfonts-base \
    xfonts-scalable \
    gtk2-engines-pixbuf \
    wget \
    gpg \
    python3-pip \
    tzdata \
    software-properties-common \
&& rm -rf /var/lib/apt/lists/*

# Install Chromium
RUN add-apt-repository ppa:savoury1/chromium
RUN apt-get update && apt-get install -y --no-install-recommends chromium-browser chromium-chromedriver && rm -rf /var/lib/apt/lists/*

# Install python dependencies
COPY ./requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install playwright
RUN playwright install && \
    playwright install-deps

# Grab needed files
COPY ./autoRSA.py .
COPY ./entrypoint.sh .
COPY ./chaseAPI.py .
COPY ./fidelityAPI.py .
COPY ./firstradeAPI.py .
COPY ./helperAPI.py .
COPY ./publicAPI.py .
COPY ./robinhoodAPI.py .
COPY ./schwabAPI.py .
COPY ./tastyAPI.py .
COPY ./tradierAPI.py .
COPY ./webullAPI.py .

# Make the entrypoint executable
RUN chmod +x entrypoint.sh

# Set the entrypoint to our entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]