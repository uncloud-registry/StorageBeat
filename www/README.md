# website

## How to build

```
go run main.go && cp styles/style.css ./out/ && cp js/sort.js ./out/
```

## How to run

in development you can run a simple python server

```
python -m http.server -d out 3000
```

then go to http://localhost:3000

in production a web server is recommended, for example Caddy