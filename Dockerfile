FROM centos:7
MAINTAINER "Brant Faircloth" <brant _at_ faircloth-lab _dot_ org>
ENV container docker

# update yum
RUN yum -y update; yum clean all
# install wget
RUN yum -y install wget
RUN yum -y install tar
RUN yum -y install bzip2
RUN yum -y install flac
RUN yum -y install zsh
RUN yum -y install git

RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum -y install lame

# add test user
RUN useradd -ms /bin/zsh bcf

# switch to test user
USER bcf
ENV HOME /home/bcf/
WORKDIR /home/bcf/

# download conda
RUN ["/bin/bash", "-c", "wget http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh -O $HOME/miniconda.sh"]
RUN chmod 0755 $HOME/miniconda.sh
RUN ["/bin/bash", "-c", "$HOME/miniconda.sh -b -p $HOME/conda"]
ENV PATH="$HOME/conda/bin:$PATH"
RUN rm $HOME/miniconda.sh

# update conda
RUN conda update conda

# install phyluce
RUN pip install flac2all

# install prezto
ADD ./prezto.sh /tmp/ 
RUN zsh /tmp/prezto.sh
RUN sed -ri "s/'prompt'/'prompt' 'syntax-highlighting' 'history-substring-search' 'git'/g" ~/.zpreztorc
RUN sed -ri "s/theme 'sorin'/theme 'steeef'/g" ~/.zpreztorc
RUN zsh
CMD ["zsh"]