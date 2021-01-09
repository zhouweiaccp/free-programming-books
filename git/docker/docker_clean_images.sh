#!/bin/bash
#

days=`date +"%Y-%m-%d %H:%M:%M" -d '-14 day'`
timestamp_days=`date -d "$days" +%s`

docker images --format "{{.Repository}} {{.ID}} '{{.CreatedAt}}'" | grep -Ev 'redis|mysql|portainer' | while read repo c_id c_time; do
    format=`echo $c_time | awk -F"[ ']+" '{print $2" "$3}'`
    c_timestamp=`date -d "$format" +%s`
    if [ $c_timestamp -lt $timestamp_days ]; then
        docker rmi $c_id 
    fi
done


# https://docs.docker.com/engine/reference/commandline/images/
# .ID	Image ID
# .Repository	Image repository
# .Tag	Image tag
# .Digest	Image digest
# .CreatedSince	Elapsed time since the image was created
# .CreatedAt	Time when the image was created
# .Size	Image disk size