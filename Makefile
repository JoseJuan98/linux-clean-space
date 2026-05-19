# If the first argument is "clean"...
ifeq (clean,$(firstword $(MAKECMDGOALS)))
  # Store the remaining arguments in CLEAN_ARGS
  CLEAN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # Turn those arguments into do-nothing targets so Make doesn't throw an error
  $(eval $(CLEAN_ARGS):;@:)
endif

.PHONY: clean

## Clean the OS. If pass the argument y then it will pass --yes, if n then it will pass --no, otherwise it will ask for confirmation.
clean:
	bash clean.sh $(CLEAN_ARGS)