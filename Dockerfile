FROM ruby:3.0.2 

RUN wget -O magick https://download.imagemagick.org/ImageMagick/download/binaries/magick

RUN export MAGICK_HOME="./magick"
RUN export PATH="$MAGICK_HOME/bin:$PATH"

RUN gem install rails

# RUN git clone https://github.com/nfgrep/img_repo

COPY img_repo .

WORKDIR img_repo

RUN bundle install

RUN rails db:migrate

EXPOSE 3000

CMD rails s -b 0.0.0.0
