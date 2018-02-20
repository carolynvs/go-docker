# PKG is the package name, usually the path to the package under the GOPATH
# $GOPATH/src/path/to/package
PKG = github.com/carolynvs/go-docker

# builds a linux binary in a container
build: buildimage
	@# --rm removes the container when the command completes
	@# -it connects your terminal to the container so that you can type interactive commands at the prompt if necessary
	@# -v ... mounts the source code in the current directory into the GOPATH in the container
	@# godocker is the name of our docker image
	@# go build ... is the command we want to run in the container
	@# CGO_ENABLED, and -a -tags netgo ensures a static binary with no dependencies
	docker run --rm -it -v `pwd`:/go/src/$(PKG) -e CGO_ENABLED=0 godocker-build \
		go build -tags netgo -o godocker

# run the linux binary in a container
run: image
	@echo "Listening on http://localhost:8080/"
	@# -p connects the host port (8080) to the container port (80)
	@# This time instead of running a go command, we execute the default command (godocker)
	docker run --rm -it -p 8080:80 godocker
	
	@# Use the alternate command below to enable editing the css files without building the container
	#docker run --rm -it -p 8080:80 \
	#	-v `pwd`/static:/static \
	#	godocker


# compile our static assets
static:
	mkdir -p static/css
	@# Run a tool that isn't installed on your computer (sass)
	@# -v mounts the current directory
	@# -w sets it as the current directory
	docker run --rm -v `pwd`:`pwd` -w `pwd` jbergknoff/sass \
		./scss/site.scss ./static/css/site.css

# create the docker image for building go application
buildimage:
	@# -t ... tags our docker image with the specified name (godocker)
	@# -f tells Docker to use the specified Dockerfile
	@# . tells Docker to use the contents of the current directory to build the image
	docker build -t godocker-build -f Dockerfile.build .

# create the docker image for running our go application
image: static build
	docker build -t godocker .

# List any target names here that should be executed every time
.PHONY: static
