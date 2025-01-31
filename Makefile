.PHONY: it
it: refactoring coding-standards security-analysis static-code-analysis tests ## Runs the refactoring, coding-standards, security-analysis, static-code-analysis, and tests targets

.PHONY: code-coverage
code-coverage: vendor ## Collects coverage from running unit tests with phpunit/phpunit
	mkdir -p .build/phpunit/
	vendor/bin/phpunit --configuration=test/Unit/phpunit.xml --coverage-text

.PHONY: coding-standards
coding-standards: vendor ## Lints YAML files with yamllint, normalizes composer.json with ergebnis/composer-normalize, and fixes code style issues with friendsofphp/php-cs-fixer
	yamllint -c .yamllint.yaml --strict .
	composer normalize
	mkdir -p .build/php-cs-fixer/
	vendor/bin/php-cs-fixer fix --config=.php-cs-fixer.php --diff --verbose

.PHONY: dependency-analysis
dependency-analysis: phive vendor ## Runs a dependency analysis with maglnet/composer-require-checker
	.phive/composer-require-checker check --config-file=$(shell pwd)/composer-require-checker.json --verbose

.PHONY: help
help: ## Displays this list of targets with descriptions
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: phar
phar: phive vendor ## Builds a phar with humbug/box
	.phive/box validate box.json
	composer remove phpunit/phpunit --no-interaction --no-progress
	.phive/box compile --config=box.json
	git checkout HEAD -- composer.json composer.lock
	.phive/box info .build/phar/phpunit-slow-test-detector.phar --list
	.phive/phpunit --configuration=test/Phar/phpunit.xml

.PHONY: phive
phive: .phive ## Installs dependencies with phive
	mkdir -p .build/phive/
	PHIVE_HOME=.build/phive phive install --trust-gpg-keys 0x2DF45277AEF09A2F,0x033E5F8D801A2F8D,0x4AA394086372C20A

.PHONY: refactoring
refactoring: vendor ## Runs automated refactoring with rector/rector
	mkdir -p .build/rector/
	vendor/bin/rector process --config=rector.php

.PHONY: security-analysis
security-analysis: vendor ## Runs a security analysis with composer
	composer audit

.PHONY: static-code-analysis
static-code-analysis: vendor ## Runs a static code analysis with vimeo/psalm
	mkdir -p .build/psalm/
	vendor/bin/psalm --config=psalm.xml --clear-cache
	vendor/bin/psalm --config=psalm.xml --show-info=false --stats --threads=4

.PHONY: static-code-analysis-baseline
static-code-analysis-baseline: vendor ## Generates a baseline for static code analysis with vimeo/psalm
	mkdir -p .build/psalm/
	vendor/bin/psalm --config=psalm.xml --clear-cache
	vendor/bin/psalm --config=psalm.xml --set-baseline=psalm-baseline.xml

.PHONY: tests
tests: vendor ## Runs unit and end-to-end tests with phpunit/phpunit
	mkdir -p .build/phpunit
	composer require phpunit/phpunit:10.4.0 --no-interaction --no-progress --update-with-all-dependencies; vendor/bin/phpunit --configuration=test/Unit/phpunit.xml; git checkout HEAD -- composer.json composer.lock; composer install --no-interaction --no-progress
	composer require phpunit/phpunit:10.4.0 --no-interaction --no-progress --update-with-all-dependencies; vendor/bin/phpunit --configuration=test/EndToEnd/Version10/phpunit.xml; git checkout HEAD -- composer.json composer.lock; composer install --no-interaction --no-progress
	composer require phpunit/phpunit:9.6.0 --no-interaction --no-progress --update-with-all-dependencies; vendor/bin/phpunit --configuration=test/EndToEnd/Version9/phpunit.xml; git checkout HEAD -- composer.json composer.lock; composer install --no-interaction --no-progress

vendor: composer.json composer.lock
	composer validate --strict
	composer install --no-interaction --no-progress
