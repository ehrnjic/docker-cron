FROM debian:10.6-slim

# Update apt repo & Install cron
RUN apt-get update && apt-get install cron -y

# Add crontab file in the cron directory
ADD schedules /etc/cron.d/my-crontab

# Add shell script and grant execution rights
ADD script.sh /script.sh
RUN chmod +x /script.sh

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/my-crontab

# Create the log file to be able to run tail
# OVDJE SAM TI OPISAO BUG I RJESENJE, IMA NA STACKOVERFLOW
# There is a bug in Debian based distributions which will 
#  cause cronjobs to fail because docker uses layered
#  filesystem and cron doesn't start. FIX IS SIMPLE add
#  /etc/crontab /etc/cron.*/* to the entrypoint of your container. 
RUN touch /cron.log /etc/crontab /etc/cron.*/*

# Run the command on container startup
CMD cron && tail -f /cron.log
