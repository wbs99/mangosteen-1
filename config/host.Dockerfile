# 注意将 bible 替换为当前应用名称

FROM ruby:3.0.0

ENV RAILS_ENV production
ARG USER=mangosteen
RUN mkdir /$USER
RUN bundle config mirror.https://rubygems.org https://gems.ruby-china.com
WORKDIR /$USER
ADD Gemfile /$USER
ADD Gemfile.lock /$USER
ADD vendor/cache.tar.gz /$USER/vendor/
ADD vendor/rspec_api_documentation.tar.gz /$USER/vendor/ 
RUN bundle config set --local without 'development test'
RUN bundle install --local

ADD $USER-*.tar.gz ./
ENTRYPOINT bundle exec puma