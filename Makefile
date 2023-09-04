# Executables (local)
DOCKER_COMP = docker compose

# Docker containers
PHP_CONT      = $(DOCKER_COMP) exec php
DATABASE_CONT = $(DOCKER_COMP) exec database
NODE_CONT     = $(DOCKER_COMP) exec node
NODE_CONT_DETACH = $(DOCKER_COMP) exec -d node

# Executables
PHP      = $(PHP_CONT) php
COMPOSER = $(PHP_CONT) composer
SYMFONY  = $(PHP) bin/console
NPM      = $(NODE_CONT) npm

# Misc
.DEFAULT_GOAL = help
.PHONY        : help build up start down logs sh composer vendor sf cc

## —— 🎵 🐳 The Symfony Docker Makefile 🐳 🎵 ——————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9\./_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Docker 🐳 ————————————————————————————————————————————————————————————————
build: ## Builds the Docker images
	@$(DOCKER_COMP) build --pull --no-cache

up: ## Start the docker hub in detached mode (no logs)
	@$(DOCKER_COMP) --env-file=docker.env -f docker-compose.yml -f docker-compose.prod.yml up --detach

up-dev: ## Start the docker hub in detached mode (no logs) and development mode
	@$(DOCKER_COMP) --env-file=docker.env up --detach

start: ## Build and start the docker hub in detached mode (no logs)
	@$(DOCKER_COMP) --env-file=docker.env -f docker-compose.yml -f docker-compose.prod.yml up --detach --build

start-dev: ## Build and start the docker hub in detached mode (no logs) and development mode
	@$(DOCKER_COMP) --env-file=docker.env up --detach --build

down: ## Stop the docker hub
	@$(DOCKER_COMP) down --remove-orphans

logs: ## Show live logs
	@$(DOCKER_COMP) logs --tail=0 --follow

sh: ## Connect to the PHP FPM container
	@$(PHP_CONT) sh

database: ## Connect to the database container
	@$(DATABASE_CONT) sh

## —— Composer 🧙 ——————————————————————————————————————————————————————————————
composer: ## Run composer, pass the parameter "c=" to run a given command, example: make composer c='req symfony/orm-pack'
	@$(eval c ?=)
	@$(COMPOSER) $(c)

vendor: ## Install vendors according to the current composer.lock file
vendor: c=install --prefer-dist --no-dev --no-progress --no-scripts --no-interaction
vendor: composer

## —— Symfony 🎵 ———————————————————————————————————————————————————————————————
sf: ## List all Symfony commands or pass the parameter "c=" to run a given command, example: make sf c=about
	@$(eval c ?=)
	@$(SYMFONY) $(c)

cc: c=c:c ## Clear the cache
cc: sf

## —— Node ✨ ——————————————————————————————————————————————————————————————————
encore:
	@$(NPM) install @symfony/webpack-encore --save-dev

client: ## Compila los archivos del frontal para producción
	@$(NPM) run build

client-dev: ## Compila los archivos del frontal para desarrollo
	@$(NPM) run dev -- --host

client-watch: ## Compila los archivos del frontal para seguir los cambios
	@$(NODE_CONT_DETACH) npm run watch

## —— Piña 🍍 ——————————————————————————————————————————————————————————————————
messenger-restart: ## Detiene y reinicia las tareas asíncronas de Symfony Messenger
	@$(SYMFONY) messenger:stop-workers
	@$(SYMFONY) messenger:consume async failed -vv

refresh: ## Recarga el frontal de todos los clientes conectados
	@$(SYMFONY) app:refresh_people

deploy: start messenger-restart refresh ## Despliega la aplicación en producción

deploy-dev: start-dev client-dev ## Despliega la aplicación en desarrollo
