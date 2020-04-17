docker build --tag hand:1.0 .
docker stop hand
docker rm hand
docker run -p 6080:80 --name hand hand:1.0 
# See README.md for more info
