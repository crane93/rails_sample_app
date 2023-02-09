FROM ruby:3.1.2	
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN gem install bundler -v 2.3.14
RUN bundle _2.3.14_ config set --local without 'production'
RUN bundle _2.3.14_ install
COPY . .

EXPOSE 3000