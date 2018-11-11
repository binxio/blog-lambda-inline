.PHONY: help init clean validate mock create delete info deploy
.DEFAULT_GOAL := help
environment = "inlined"

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

init: ## init python
	@pipenv install --python 2.7.15 --dev

clean: ## clean
	@pipenv --rm

create: merge-lambda ## create env
	@sceptre launch-env $(environment)

delete: ## delete env
	@sceptre delete-env $(environment)

info: ## describe resources
	@sceptre describe-stack-outputs $(environment) api-gateway

deploy: delete create info ## delete and create

merge-lambda: ## merge lambda in api gateway
	aws-cfn-update \
		lambda-inline-code \
		--resource PythonFunction \
		--file lambdas/python_function.py \
		templates/api-gateway.yaml

	aws-cfn-update \
		lambda-inline-code \
		--resource NodeFunction \
		--file lambdas/node_function.js \
		templates/api-gateway.yaml
