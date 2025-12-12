# Currency Converter

## API

Run the server:

    $ deno run --allow-net src/server.ts
    Listening on http://localhost:8000/

Define an exchange rate (requires authentication):

    $ curl -X PUT -u banker:iLikeMoney http://localhost:8000/rate/usd/chf/0.81

Show a conversion rate (reverse rates are computed automatically):

    $ curl -X GET -u banker:iLikeMoney http://localhost:8000/rate/chf/usd
    {"rate":1.2345679012345678}

Convert a currency amount:

    $ curl -X GET http://localhost:8000/conversion/usd/chf/100
    {"result":81}

Remove an exchange rate (requires authentication):

    $ curl -X DELETE -u banker:iLikeMoney http://localhost:8000/rate/usd/chf

## CLI

Define a file containing exchange rates:

```json
[
  { "fromCurrency": "usd", "toCurrency": "chf", "exchangeRate": 0.81 },
  { "fromCurrency": "eur", "toCurrency": "chf", "exchangeRate": 0.94 },
  { "fromCurrency": "chf", "toCurrency": "gbp", "exchangeRate": 0.93 }
]
```

Run the command line program:

    $ deno run --allow-read src/cli.ts --rates exchange-rates.json --from chf --to usd --amount 1900
    2345.679012345679

## Tests

Run the tests:

    $ deno test

Report test coverage (exports an HTML report to the `codecov/` folder):

    $ deno test --coverage=codecov

## Was habe ich gemacht:

### Aufgabe 3

1. cli-test.sh in einem Neuen Ordner anlegen.
2. Readme anschauen und alles ausführen.
3. exchange-rates.json anachauen.
4. Nun müssen cli.ts und conversion.ts für komplettes verständniss.
5. Erster Testfall definieren und ausführen.
6. Erstelle die 3 Weiteren Testfälle und führe diese aus.
7. Erkenne wie viel code abdeckung: - Keine Ahnung wie ist ja nicht deno.
8. Fertig!

### Aufgabe 4

1. server-test.sh im test ordner anlegen.
2. routing.ts, endpoints.ts, http.ts, server.ts anschauen und verstehen.
3. Server starten: deno run --allow-net src/server.ts
4. Base setup
5. Dann Server management funktion also start stop usw.
6. Dann big ass funktion zum test runnen
7. der main loop und der erste test.
8. Nächsten 2 Tests erstellen, komandozeilen ki hilft sehr da es fiel gleich aus den files lesen kann.
9. Die nächsten beiden Tests definieren.