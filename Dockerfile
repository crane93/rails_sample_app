FROM ruby:3.1.2	
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ARG UID=1001
ARG GID=1001
ARG UNAME=yuri

ENV UID ${UID}
ENV GID ${GID}
ENV UNAME ${UNAME}

RUN useradd --uid $UID --create-home --shell /bin/bash -G sudo,root $UNAME
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER $UNAME

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN gem install bundler -v 2.3.14
RUN bundle _2.3.14_ config set --local without 'production'
RUN bundle _2.3.14_ install
COPY . .

EXPOSE 3000