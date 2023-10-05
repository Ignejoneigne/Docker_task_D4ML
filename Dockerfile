FROM httpd:latest
EXPOSE 15100

# Install wget to download the image
RUN apt-get update && apt-get install -y wget

# Download your business card image and copy it to the Apache document root
RUN wget -O /usr/local/apache2/htdocs/CARD.jpg https://github.com/Ignejoneigne/Docker_task_D4ML/raw/main/CARD.jpg
