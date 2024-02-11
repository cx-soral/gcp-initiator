.PHONY: init apply

ENV_LIST := dev sit prd
# Initialize ENV_LIST_JSON with the opening bracket and the first quote
ENV_LIST_TF := "["

# Use foreach to append each item in quotes followed by a comma
ENV_LIST_TF += $(foreach item,$(ENV_LIST),"$(item)",)

# Trim the trailing comma and add the closing bracket
ENV_LIST_TF := $(shell echo '$(ENV_LIST_TF)' | sed 's/,$$/]/')

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

apply:
	@echo $(ENV_LIST_TF)
	@terraform -chdir=iac/environments/repo apply -auto-approve \
		-var 'project_prefix=$(PROJECT_PREFIX)' \
		-var 'env_list=$(ENV_LIST_TF)' \
		-var 'repository_name=$(REPO_NAME)' \
		-var 'repository_owner=$(REPO_OWNER)'
