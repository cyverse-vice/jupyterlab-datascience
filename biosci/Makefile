platform = linux/amd64
repo = harbor.cyverse.org/vice/jupyter/datascience
tag = 3.6.3-biosci-rstudio-4.4.1
repotag = $(repo):$(tag)

build:
	docker buildx build --rm --platform "$(platform)" -t "$(repotag)" .

push:
	docker push "$(repotag)"

rmi:
	socker rmi "$(repotag)"
