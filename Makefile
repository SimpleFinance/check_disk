RUBY_GEMS ?= .gems

bundle_tasks:
	bundle config build.nokogiri --use-system-libraries

bundle_install: bundle_tasks
	bundle install --jobs 4 --quiet --path=$(RUBY_GEMS)

test: bundle_install
	bundle exec rake test:all
