#!/bin/bash

#Build Front-End
echo "====== Packagin & Copying Front-End ======"
(cd adm/client/ && INLINE_RUNTIME_CHUNK=false npm run build && cp -r ./dist/ ./../server/)

#Replace Old Folder 
if [ -d "./adm/server/public/" ]
then
    echo "====== Updating Previous Public Folder ======"
    (rm -r ./adm/server/public/ && mv ./adm/server/dist/ ./adm/server/public/)
else
    echo "====== Creating a New Public Folder ======"
    mv ./adm/server/dist/ ./adm/server/public/
fi

#Update Docker adm Image
echo "====== Updating Docker Image ======"
(cd adm && docker build -t adm:latest .)

#Commit Git
echo "====== Commiting Work to Repo ======"
(git add . && git commit -m "$1" && git push origin master)

#Rebuild Docker-Compose
echo "====== Rebuild Docker-Compose ======"
docker-compose up -d --force-recreate adm nginx_proxy
docker-compose ps