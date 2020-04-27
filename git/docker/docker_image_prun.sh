#!/bin/bash
d=`date '+%Y%m%d%H%M%S'`


#https://docs.docker.com/engine/reference/commandline/images/
# Format the output🔗
# The formatting option (--format) will pretty print container output using a Go template.

# Valid placeholders for the Go template are listed below:

# Placeholder	Description
# .ID	Image ID
# .Repository	Image repository
# .Tag	Image tag
# .Digest	Image digest
# .CreatedSince	Elapsed time since the image was created
# .CreatedAt	Time when the image was created
# .Size	Image disk size

# Filtering
# The filtering flag (-f or --filter) format is of “key=value”. If there is more than one filter, then pass multiple flags (e.g., --filter "foo=bar" --filter "bif=baz")

# The currently supported filters are:

# dangling (boolean - true or false)
# label (label=<key> or label=<key>=<value>)
# before (<image-name>[:<tag>], <image id> or <image@digest>) - filter images created before given id or references
# since (<image-name>[:<tag>], <image id> or <image@digest>) - filter images created since given id or references
# reference (pattern of an image reference) - filter images whose reference matches the specified pattern

docker images --format 'table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedAt}}\t{{.Size}}'





#https://docs.docker.com/engine/reference/commandline/image_prune/

# Filtering🔗
# The filtering flag (--filter) format is of “key=value”. If there is more than one filter, then pass multiple flags (e.g., --filter "foo=bar" --filter "bif=baz")

# The currently supported filters are:

# until (<timestamp>) - only remove images created before given timestamp
# label (label=<key>, label=<key>=<value>, label!=<key>, or label!=<key>=<value>) - only remove images with (or without, in case label!=... is used) the specified labels.
# The until filter can be Unix timestamps, date formatted timestamps, or Go duration strings (e.g. 10m, 1h30m) computed relative to the daemon machine’s time. Supported formats for date formatted time stamps include RFC3339Nano, RFC3339, 2006-01-02T15:04:05, 2006-01-02T15:04:05.999999999, 2006-01-02Z07:00, and 2006-01-02. The local timezone on the daemon will be used if you do not provide either a Z or a +-00:00 timezone offset at the end of the timestamp. When providing Unix timestamps enter seconds[.nanoseconds], where seconds is the number of seconds that have elapsed since January 1, 1970 (midnight UTC/GMT), not counting leap seconds (aka Unix epoch or Unix time), and the optional .nanoseconds field is a fraction of a second no more than nine digits long.

# The label filter accepts two formats. One is the label=... (label=<key> or label=<key>=<value>), which removes images with the specified labels. The other format is the label!=... (label!=<key> or label!=<key>=<value>), which removes images without the specified labels.

##The following removes images created more than 10 days (240h) ago:
docker image prune -a --force --filter "until=240h"


docker image prune --filter="label=deprecated"

##The following example removes images with the label deprecated:
docker image prune --filter="label=deprecated"

##The following example removes images with the label maintainer set to john:
docker image prune --filter="label=maintainer=john"



## 清理
# docker container prune # 删除所有退出状态的容器
# docker volume prune # 删除未被使用的数据卷
# docker image prune # 删除 dangling 或所有未被使用的镜像
# 删除容器：docker container rm $(docker container ls -a -q)
# 删除镜像：docker image rm $(docker image ls -a -q)
# 删除数据卷：docker volume rm $(docker volume ls -q)
# 删除 network：docker network rm $(docker network ls -q)