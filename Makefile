.PHONY: init apply


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
		terraform -chdir=iac/environments/$(ENV_NAME) init;)
	@terraform -chdir=iac/environments/repo init

apply: init check-vars
	$(foreach ENV_NAME,$(ENV_LIST),\
		terraform -chdir=iac/environments/$(ENV_NAME) apply -auto-approve \
			-var "project_id=$(PROJECT_PREFIX)$(ENV_NAME)" \
			-var "repository_name=$(REPO_NAME)" \
			-var "repository_owner=$(REPO_OWNER)";)
