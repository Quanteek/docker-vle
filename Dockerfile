FROM ubuntu:14.04
MAINTAINER quanteek

#dependencies
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y cmake g++ libgtkmm-2.4-dev libglademm-2.4-dev libgtksourceview2.0-dev libboost1.55-dev libboost-serialization1.55-dev libboost-date-time1.55-dev libboost-filesystem1.55-dev libboost-test1.55-dev libboost-regex1.55-dev libboost-program-options1.55-dev libboost-thread1.55-dev libboost-chrono1.55-dev libarchive-dev libqt4-dev wget
RUN apt-get install -y xmlstarlet

#create user
RUN useradd -ms /bin/bash user01
USER user01
WORKDIR /home/user01

#specific tasks
RUN wget http://www.vle-project.org/pub/vle/1.1/1.1.2/vle-1.1.2.tar.gz
RUN tar -xvzf vle-1.1.2.tar.gz
WORKDIR /home/user01/vle-1.1.2
RUN mkdir build
WORKDIR /home/user01/vle-1.1.2/build
RUN cmake .. -DWITH_GTKSOURCEVIEW=ON -DWITH_GTK=ON -DWITH_CAIRO=ON -DWITH_MPI=OFF -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=/usr
RUN make
USER root
RUN make install
USER user01
WORKDIR /home/user01
RUN wget http://www.vle-project.org/pub/vle/1.1/1.1.2/packages-1.1.2.tar.gz
RUN tar -xvzf packages-1.1.2.tar.gz
WORKDIR /home/user01/packages-1.1.2
RUN vle-1.1 --package=vle.output configure build || vle-1.1 --package=vle.output configure build
RUN vle-1.1 --package=vle.extension.celldevs configure build
RUN vle-1.1 --package=vle.extension.cellqss configure build
RUN vle-1.1 --package=vle.extension.decision configure build
RUN vle-1.1 --package=vle.extension.difference-equation configure build
RUN vle-1.1 --package=vle.extension.differential-equation configure build
RUN vle-1.1 --package=vle.extension.dsdevs configure build
RUN vle-1.1 --package=vle.extension.fsa configure build
RUN vle-1.1 --package=vle.extension.petrinet configure build
RUN vle-1.1 --package=vle.examples configure build
RUN vle-1.1 --package=ext.muparser configure build
RUN vle-1.1 --package=vle.forrester configure build

