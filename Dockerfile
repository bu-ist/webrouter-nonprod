# These are all defined in the base image
#
FROM dsmk/web-router-base

# for now this is our split and everything below this is for a different location
#
# the final default landscape should be test
ARG landscape=syst

# These files remains in the landscape specific CodePipeline area.
ADD landscape/${landscape}/sites.map /etc/nginx/sites.map
ADD landscape/${landscape}/vars.sh /etc/nginx/vars.sh
ADD landscape/${landscape}/redirects.map.erb /etc/erb/nginx/redirects.map.erb
ADD landscape/${landscape}/hosts.map.erb /etc/erb/nginx/hosts.map.erb

