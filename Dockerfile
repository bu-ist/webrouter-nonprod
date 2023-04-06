# Base Image:
FROM public.ecr.aws/bostonuniversity/webrouter-base:2023.03.27

# for now this is our split and everything below this is for a different location
#
# the final default landscape should be test
ARG landscape=devl

# These files remains in the landscape specific CodePipeline area.
ADD maps/hosts.map.erb /etc/erb/nginx/hosts.map.erb
ADD maps /etc/nginx/maps

