.DEFAULT_GOAL:=help

##@ Run

start: ## start docker container
	@docker run -dit \
	-v $(pwd)/jd/config:/jd/config \
	-v $(pwd)/jd/log:/jd/log \
	-p 5678:5678 \
	--name jd \
	--hostname jd \
	--restart always \
	evinedeng/jd:github

stop: ## stop docker container
	@docker stop jd
	@docker rm jd

show-logs: ## show container logs
	@docker logs jd -f

run-all: ## run all tasks
	@bash run_all.sh

auto-update-images: ## automating Docker container base image updates
	@docker run -d \
	--name watchtower \
	-v /var/run/docker.sock:/var/run/docker.sock \
	containrrr/watchtower

##@ Help
help: ## Display this help.
	@echo "Usage:\n  make \033[36m<target>\033[0m"
	@awk 'BEGIN {FS = ":.*##"}; \
		/^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } \
		/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
