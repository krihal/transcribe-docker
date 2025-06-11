# transcribe-docker

Build containers with ./build.sh

To run:
```
export HF_TOKEN=<token>
export OIDC_CLIENT_ID=<id>
export OIDC_CLIENT_SECRET=<secret>
export OIDC_METADATA_URL=<metadata URL>
export OIDC_SCOPE=openid,profile,email

docker compose up
```

GPU acceleration in Docker is a requirement, will most likely not work on MacOS.
