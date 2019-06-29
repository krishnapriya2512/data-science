FROM gitpod/workspace-full:latest

#  $ docker build . -t continuumio/anaconda:latest -t continuumio/anaconda:5.3.0 -t continuumio/anaconda2:latest -t continuumio/anaconda2:5.3.0
#  $ docker run --rm -it continuumio/anaconda2:latest /bin/bash
#  $ docker push continuumio/anaconda:latest
#  $ docker push continuumio/anaconda:5.3.0
#  $ docker push continuumio/anaconda2:latest
#  $ docker push continuumio/anaconda2:5.3.0

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN sudo apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion

RUN sudo wget --quiet https://repo.anaconda.com/archive/Anaconda2-5.3.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    sudo /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    sudo rm ~/anaconda.sh && \
    sudo ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    sudo echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    sudo echo "conda activate base" >> ~/.bashrc

RUN sudo apt-get install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    sudo dpkg -i tini.deb && \
    sudo rm tini.deb && \
    sudo apt-get clean

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]
