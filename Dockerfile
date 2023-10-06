# Use the official Apache HTTP Server image with version 2.4.57
FROM httpd:2.4.57

# Expose port 15100 for HTTP
EXPOSE 15100

# Install wget to download the image
RUN apt-get update && apt-get install -y wget

# Copy your business card image from the local source directory to the Apache document root
COPY CARD.jpg /usr/local/apache2/htdocs/

# Copy the "index.html" file from the local source directory to the Apache document root
COPY index.html /usr/local/apache2/htdocs/

# Start the Apache server
CMD ["httpd-foreground"]


