.PHONY: all test clean

test:
	test/commands_test.sh
	test/docker-args_test.sh
