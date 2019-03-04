FROM ruby:2.5

RUN apt-get update

RUN apt-get -y install build-essential nodejs

RUN gem install rails

WORKDIR /opt/app

RUN rails new example

WORKDIR /opt/app/example

RUN rails g controller pages home

COPY home.html.erb app/views/pages/

#RUN echo "<h1>Salut</h1><br><p>Page home</p>" > app/views/pages/home.html.erb

RUN rake db:migrate

RUN rake db:seed

EXPOSE 3000
