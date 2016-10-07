# IntegrationLayer

A toy app to play with ETS and plug.

## Steps

1. Fetch dependencies. Run:

  ```elixir
mix deps.get
  ```

2. Start the server and interactive shell. Run

  ```elixir
iex -S mix
  ```

3. Commands to play with. Run from bash shell:

  ```bash
$ curl -i -XGET "http://localhost:4000/configs?path=/user/create"
$ curl -i -XPOST http://localhost:4000/user/create
$ curl -i -XPUT "http://localhost:4000/configs?path=/user/create&key=to&value=abc.com"
$ curl -i -XPUT "http://localhost:4000/configs?path=/user/create&key=new_key&value=new_value"
$ curl -i -XGET "http://localhost:4000/configs?path=/user/create"
  ```

4. Excercises to try yourself:

  * Make a plug that will add a header "X-My-Header" to a request. The value of header should be configurable and depend on the route in question (e.g. for "/user/create" it can be "Example 1", while for "/some/path/path" the header value can be "Example 2").
