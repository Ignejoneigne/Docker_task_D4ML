# Define environment variables
export MY_PUBLIC_IP="5.20.132.172"
export INSTANCE_PUBLIC_IP="3.77.57.82"
export SECURITY_GROUP_ID="sg-0f4dd6849aa4dc0ab"
export APACHE_VERSION="2.4.57"
export CARD_IMAGE_URL="https://github.com/Ignejoneigne/Docker_task_D4ML/raw/main/CARD.jpg"

# Update the system and install necessary packages
sudo apt-get update
sudo apt-get install -y apache2=$APACHE_VERSION

# Configure Apache to listen on port 15100
sudo sed -i 's/80/15100/g' /etc/apache2/ports.conf
sudo sed -i 's/80/15100/g' /etc/apache2/sites-enabled/000-default.conf

# Start the Apache service
sudo systemctl start apache2

# Enable Apache to start on boot
sudo systemctl enable apache2

# Install Docker (if not already installed)
# sudo apt-get install -y docker.io

# Create a directory for your Apache container
sudo mkdir my-apache-container
sudo cd my-apache-container

# Create a Dockerfile for your Apache container
sudo cat <<EOL > Dockerfile
# Use the official Apache HTTP Server image as the base image
FROM httpd:latest
# Expose port 15100 for HTTP
EXPOSE 15100
# Install wget to download the image (if needed)
RUN apt-get update && apt-get install -y wget
# Copy the "index.html" file from the local source directory to the Apache document root
COPY index.html /usr/local/apache2/htdocs/
# Copy the "CARD.jpg" image from the local source directory to the Apache document root
COPY CARD.jpg /usr/local/apache2/htdocs/
# Start the Apache server
CMD ["httpd-foreground"]
EOL

# Copy the "index.html" and "CARD.jpg" files to the directory where the Dockerfile is located
cp index.html my-apache-container/index.html
cp CARD.jpg my-apache-container/CARD.jpg

# Build the Docker image
sudo docker build -t my-apache-image my-apache-container

# Run the Docker container, mapping port 15100 of the host to port 80 of the container
sudo docker run -d -p 15100:80 --name my-apache-container my-apache-image

# Authorize incoming traffic on port 15100 (HTTP) for your public IP address and security group
sudo aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_ID --protocol tcp --port 15100 --source $MY_PUBLIC_IP/32

# Access your business card image using your instance's public IP address and port 15100
# URL: http://$INSTANCE_PUBLIC_IP:15100/CARD.jpg
