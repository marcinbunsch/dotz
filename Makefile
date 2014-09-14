all:
	npm i
	bower i
	brunch build

watch:
	brunch watch --server

production:
	npm i
	bower i
	rm -rf public
	brunch build --production
