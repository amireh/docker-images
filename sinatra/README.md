# sinatra

Ruby's Thin webserver serving a [Sinatra](http://sinatrarb.com) application
with [live-reload](http://sinatrarb.com/contrib/reloader) suitable for use as a
"mock server".

## Usage

Mount your app code that contains a `config.ru` at `/app` and run the image:

```bash
docker run --rm -it -v "$PWD":/app -p 3000:3000 amireh/sinatra:latest
```

As the app is not expected to have a Gemfile or any dependencies, `bundle
install` is not run.
