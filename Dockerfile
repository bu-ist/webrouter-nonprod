FROM buist/websites-webrouter-base:2022.05.18

# for now this is our split and everything below this is for a different location
#
# the final default landscape should be test
ARG landscape=qa

# These files remains in the landscape specific CodePipeline area.
ADD maps/hosts.map.erb /etc/erb/nginx/hosts.map.erb
ADD maps /etc/nginx/maps

