.PHONY: init apply


check-vars:
ifndef PROJECT_ID
	$(error PROJECT_ID is undefined)
endif
ifndef REPO_NAME
	$(error REPO_NAME is undefined)
endif
ifndef REPO_OWNER
	$(error REPO_OWNER is undefined)
endif

init:
    @terraform -chdir=iac/environments/dev init
    @terraform -chdir=iac/environments/sit init
    @terraform -chdir=iac/environments/prd init
    @terraform -chdir=iac/environments/repo init

apply: init check-vars
	$(foreach PROJECT_ID,$(PROJECT_IDS),\
		terraform -chdir=iac/environments/repo apply -auto-approve \
			-var "project_id=$(PROJECT_ID)" \
			-var "repository_name=$(REPO_NAME)" \
			-var "repository_owner=$(REPO_OWNER)";)
	@terraform -chdir=iac/environments/repo apply -auto-approve \
		-var "project_id=$(PROJECT_ID)" \
		-var "repository_name=$(REPO_NAME)" \
		-var "repository_owner=$(REPO_OWNER)"
