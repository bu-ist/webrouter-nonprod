# These are all defined in the base image
#
FROM buist/websites-webrouter-base:2022.05.17

# for now this is our split and everything below this is for a different location
#
# the final default landscape should be test
ARG landscape=test

# These files remains in the landscape specific CodePipeline area.
ADD maps/hosts.map.erb /etc/erb/nginx/hosts.map.erb
ADD maps /etc/nginx/maps

