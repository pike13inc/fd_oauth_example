Example Pike13 Oauth2 Consumer
==============================

This example uses the Ruby Oauth2 gem to make an auth request to Pike13, get the auth code, then use the auth code to 
fetch an access token.

Usage
-----

1. Visit <https://developer.pike13.com/oauth_clients> and select your client application. Make note of the Client ID and
the Client Secret.
2. Set the following environment variables in your terminal:

    ```bash
    export P13_OAUTH_KEY=<my pike13 oauth key> # Client ID
    export P13_OAUTH_SECRET=<my pike13 oauth secret> # Client Secret
    export P13_HOST=<Pike13 host> # https://pike13.com or you can also use https://<your_subdomain>.pike13.com
    ```

3. Run the server:

    ```bash
    ruby lib/server.rb
    ```

4. Fire up your browser and connect to the host:port that is listed in the server output. Probably <http://localhost:4567>
