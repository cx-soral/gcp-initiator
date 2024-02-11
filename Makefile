.PHONY: init apply

ENV_LIST := dev sit prd
ENV_LIST_TF := $(foreach item,$(ENV_LIST),\"$(item)\",)
ENV_LIST_TF := $(strip $(ENV_LIST_TF))
ENV_LIST_TF := $(patsubst %,,%$(ENV_LIST_TF))

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
