FROM appium:1.7.1

WORKDIR /root

RUN apt-get -qqy update && apt-get -qqy install --no-install-recommends \
    xterm \
    supervisor \
    socat \
    x11vnc \
    openbox \
    menu \
    python-numpy \
    net-tools \
    ffmpeg \
    jq \
 && rm -rf /var/lib/apt/lists/*

ARG ANDROID_VERSION=7.1.1
ARG API_LEVEL=25
ARG PROCESSOR=x86
ARG SYS_IMG=x86_64
ARG IMG_TYPE=google_apis
ARG BROWSER=chrome
ENV ANDROID_VERSION=$ANDROID_VERSION \
    API_LEVEL=$API_LEVEL \
    PROCESSOR=$PROCESSOR \
    SYS_IMG=$SYS_IMG \
    IMG_TYPE=$IMG_TYPE \
    BROWSER=$BROWSER
ENV PATH ${PATH}:${ANDROID_HOME}/build-tools
RUN echo y | sdkmanager "platforms;android-${API_LEVEL}" && \
    echo y | sdkmanager "system-images;android-${API_LEVEL};${IMG_TYPE};${SYS_IMG}" && \
    echo y | sdkmanager "emulator"
RUN rm ${ANDROID_HOME}/tools/emulator \
 && ln -s ${ANDROID_HOME}/emulator/emulator64-${PROCESSOR} ${ANDROID_HOME}/tools/emulator
ENV LD_LIBRARY_PATH=$ANDROID_HOME/emulator/lib64:$ANDROID_HOME/emulator/lib64/qt/lib


RUN wget -nv -O chrome.zip "https://chromedriver.storage.googleapis.com/2.26/chromedriver_linux64.zip" \
 && unzip -x chrome.zip \
 && rm chrome.zip


ENV DISPLAY=:0 \
    SCREEN=0 \
    SCREEN_WIDTH=1600 \
    SCREEN_HEIGHT=900 \
    SCREEN_DEPTH=16 \
    LOCAL_PORT=5900 \
    TARGET_PORT=6080 \
    TIMEOUT=1 \
    VIDEO_PATH=/tmp/video \
    LOG_PATH=/var/log/supervisor

#===============
# Expose Ports
#---------------
# 4723
#   appium port
# 5554
#   Emulator port
# 5555
#   ADB connection port
# 5900
#   VNC connection port
#===============
EXPOSE 4723 5554 5555 5900

#======================
# Add Emulator Devices
#======================
COPY devices /root/devices

#===================
# Run docker-appium
#===================
COPY src /root/src
COPY supervisord.conf /root/
RUN chmod -R +x /root/src && chmod +x /root/supervisord.conf

HEALTHCHECK --interval=2s --timeout=40s --retries=1 \
    CMD adb wait-for-device shell 'while [[ -z $(getprop sys.boot_completed) ]]; do sleep 1; done'

CMD /usr/bin/supervisord --configuration supervisord.conf