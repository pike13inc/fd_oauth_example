= Example Front Desk Oauth2 Consumer

== Usage

First set the following ENV vars:

    export FD_OAUTH_KEY=<my front desk oauth key>
    export FD_OAUTH_SECRET=<my frontdesk aouth secret>
    export FD_HOST=<front desk host> # probably frontdeskhq.com

Then run the server:

    ruby lib/server.rb

Fire up your browser and enjoy.