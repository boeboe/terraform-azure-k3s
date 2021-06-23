# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
.PHONY: init plan deploy destroy clean reset validate update

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help


# EXAMPLE					:= server_only
# EXAMPLE					:= server_agent
# EXAMPLE					:= server_agent_groups
EXAMPLE					:= server_agent_flags

TEST_FOLDER			:= ${CURDIR}/examples/${EXAMPLE}
TERRAFORM_VARS	:= ${TEST_FOLDER}/${EXAMPLE}.tfvars

OUTPUT_FOLDER		:= ${CURDIR}/output/${EXAMPLE}
TERRAFORM_PLAN	:= ${OUTPUT_FOLDER}/${EXAMPLE}.tfplan.tf
TERRAFORM_STATE	:= ${OUTPUT_FOLDER}/${EXAMPLE}.tfstate


init: ## Initialize terraform
	terraform init -input=false ;

plan: init ## Plan infrastructure changes using terraform
	terraform plan -input=false -var-file=${TERRAFORM_VARS} -state=${TERRAFORM_STATE} -out=${TERRAFORM_PLAN} ;

deploy: plan ## Deploy infrastructure using terraform
	terraform apply -auto-approve -input=false -state=${TERRAFORM_STATE} ${TERRAFORM_PLAN} ;

destroy: ## Cleanup infrastructure managed by terraform
	terraform destroy -auto-approve -input=false -var-file=${TERRAFORM_VARS} -state=${TERRAFORM_STATE} ;

clean: ## Remove all temorary output/build artifacts
	rm -f ${CURDIR}/.terraform.lock.hcl ${OUTPUT_FOLDER}/*.tf ${OUTPUT_FOLDER}/*.tfstate ${OUTPUT_FOLDER}/*.tfstate.backup ${OUTPUT_FOLDER}/*.yaml ;
	rm -rf ${CURDIR}/.terraform ;

reset: destroy clean deploy ## Cleanup existing and create new infrastructure using terraform

validate: init ## Validate terraform syntax and linting
	terraform validate ;
	terraform fmt -recursive ;

update: ## Perform terraform module update
	terraform get -update=true ;

local-public-ip:  ## Determine your public IP address for Azure FW allowance
	dig +short myip.opendns.com @resolver1.opendns.com
