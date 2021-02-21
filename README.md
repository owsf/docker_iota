# IOTA

![Github Badge](https://github.com/owsf/docker_iota/workflows/docker/badge.svg)

Run the [OWSF OTA Server](https://github.com/owsf/owsf-ota-server) inside a
docker container.

## Build it
Run `docker build` inside the 
```bash
git clone https://github.com/owsf/docker_iota
cd docker_iota
docker build --tag iota:latest .
```

## Use it
Create a docker volume to store the database, configuration files and firmware
in
```bash
docker volume create iota_data
```

Create a new admin token. Alternatively, the container will create one for you
```bash
export IOTA_ADMIN_TOKEN=$(openssl rand -base64 64)
```

And finally run the container
```bash
docker run -v iota_data:/opt/iota -e ADMIN_TOKEN="$IOTA_ADMIN_TOKEN" \
    --name iota -p 8080:8080 iota:latest
```

Now the OWSF OTA server is reachable under `http://127.0.0.1:8080/api/v1/`. In
order to use this server with your wireless sensor, you need a reverse proxy and
a SSL certificate.
