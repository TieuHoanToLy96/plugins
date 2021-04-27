services:
	docker-compose -f docker-compose-services.yml up -d
app:
	make services
	docker-compose -f docker-compose.yml down; docker-compose -f docker-compose.yml run --name api --service-ports api
bash:
	docker-compose run api sh