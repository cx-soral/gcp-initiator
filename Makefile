.PHONY: init apply

ENV_LIST := dev sit prd
ENV_LIST_TF := ["dev", "sit", "prd"]

check-vars:
ifndef PROJECT_PREFIX
	$(error PROJECT_PREFIX is undefined)
endif
ifndef ENV_LIST
	$(error ENV_LIST is undefined)
endif
ifndef REPO_NAME
	$(error REPO_NAME is undefined)
endif
ifndef REPO_OWNER
	$(error REPO_OWNER is undefined)
endif

init:
	$(foreach ENV_NAME,$(ENV_LIST),\
		terraform -chdir=iac/environments/$(ENV_NAME) init -backend-config "bucket=$(PROJECT_PREFIX)-tf-states" -backend-config "prefix=terraform/$(PROJECT_PREFIX)$(ENV_NAME)/state";)
	@terraform -chdir=iac/environments/repo init

apply: init check-vars
	$(foreach ENV_NAME,$(ENV_LIST),\
		terraform -chdir=iac/environments/$(ENV_NAME) apply -auto-approve \
			-var "project_id=$(PROJECT_PREFIX)$(ENV_NAME)" \
			-var "repository_name=$(REPO_NAME)" \
			-var "repository_owner=$(REPO_OWNER)";)
	@terraform -chdir=iac/environments/repo apply -auto-approve \
		-var 'project_prefix=$(PROJECT_PREFIX)' \
		-var 'env_list=$(ENV_LIST_TF)' \
		-var 'repository_name=$(REPO_NAME)' \
		-var 'repository_owner=$(REPO_OWNER)'
