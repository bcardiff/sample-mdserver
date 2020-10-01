# mdserver

A sample server that renders markdown on the fly, with [LiveReload](https://github.com/bcardiff/live_reload.cr).

## Installation

```
$ git clone git@github.com:bcardiff/sample-mdserver.git
$ shards build
```

## Usage

```
$ bin/mdserver [dir]
Using data at /full/path/to/dir
Listening on http://127.0.0.1:3000
LiveReload on http://0.0.0.0:35729
```

Open `http://127.0.0.1:3000`.

When the server receives a `GET /file`:

* If a `dir/file.md` exists, it will render it with `dir/styles.css` and livereload script
* Otherwise it will return `dir/file` with a `HTTP::StaticFileHandler`

When changes in `dir` are detected a reload will be sent to the browser.

## Contributors

- [Brian J. Cardiff](https://github.com/bcardiff) - creator and maintainer
