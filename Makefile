prereqs:
	cabal install -j alex happy
	cabal install -j hakyll pandoc

build:
	ghc --make site.hs
	./site rebuild

publish: build
	s3cmd sync --delete-removed _site/* s3://essays.iangreenleaf.com
	cat ~/.s3cfg | sed 's/\(guess_mime_type.*\)True/\1False/' > .tmpconfig
	s3cmd put --config=.tmpconfig --mime-type=application/rss+xml _site/*.rss s3://essays.iangreenleaf.com
	rm .tmpconfig
	./upload_redirects s3://essays.iangreenleaf.com
