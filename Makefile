.PHONY: update-submodule

update-submodule:
	git submodule update --remote bootstrap
	git add bootstrap
	- git commit -m "Update bootstrap submodule"
	git push origin main
