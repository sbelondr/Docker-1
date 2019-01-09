docker-machine create --driver virtualbox default
eval "$(docker-machine env default)"
docker image ls
docker-machine --storage-path "/sgoinfre/goinfre/Perso/sbelondr/Docker/Docker-data" create --driver=virtualbox Char
docker-machine -s Docker-data env Char
eval "$(docker-machine -s /sgoinfre/goinfre/Perso/sbelondr/Docker/Docker-data env Char)"
docker inspect -f '{{ .Mounts }}' 9e4249867d89
