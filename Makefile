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

release: production
	git checkout gh-pages
	cp -r public/* .
	git add .
	git commit -m "Production release"
	git push origin gh-pages
	git checkout master

