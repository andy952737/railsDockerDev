FROM ruby:2.7.2
MAINTAINER andy <andy952737@gmail.com>
RUN apt-get update && apt-get install -y build-essential libpq-dev nodejs vim postgis imagemagick default-libmysqlclient-dev
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN gem install bundler:2.4.13
RUN gem install rake:13.0.6
#RUN gem install sqlite3
RUN gem install pg 
RUN gem install mysql2
RUN gem install nokogiri --platform=ruby
RUN apt-get update && apt-get install -y libsqlite3-dev
RUN bundle config set force_ruby_platform true
RUN bundle install

ENV SECRET_KEY_BASE=f2dcc179a1a26cd12b65c698ef2fbce0821aab5eacabb0e4f129c1d2bab68b5ba6ed2420cadfe26cc7b92bd4378fd803bcc0ea07510436489e079484521262c1

COPY . /app
CMD rake db:migrate assets:precompile && puma -C config/puma.rb

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES yes
ENV RAILS_LOG_TO_STDOUT yes

#CMD ["bundle", "exec", "rails", "server"]

# 下载安装 Nginx
RUN apt-get update && apt-get install -y nginx
#FROM nginx

# 复制 Nginx 配置文件到容器中
COPY default.conf /etc/nginx/conf.d/default.conf

# 暴露端口
EXPOSE 80

# 启动 Nginx 和 Rails 服务器
CMD service nginx start && bundle exec rails server -b 0.0.0.0