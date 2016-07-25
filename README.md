Posh Server
===========

This is a template Express.js server which I frequently use to build HTTP server applications.

It uses Docker for easy containerized deployment, Express.JS for routing and logic, Handlebars for templating,
sequelize as an ORM, and a dockerized Postgres database.


### Running:

Simply run:

```bash
./manage.sh install        # Install dependencies
./manage.sh generate-cert  # Generate certificates (using LetsEncrypt)
./manage.sh start          # Start the server
```

If it fails to connect to the database the first time, that is because the database image was still setting up
for the first time, run:
```bash
./manage.sh restart
```
to restart and it should start fine.

The server will be running on ports 80 (HTTP) and 443 (HTTPS).

This assumes the server is running Ubuntu 14.04 x86-64 and is capable of running Docker.
It may need to be run as the root user.


### Development:

Install the pre-commit hook to ensure clean, linted code prior to commits.  Run the following from the project's root directory

```bash
ln -s $(pwd)/pre-commit.sh .git/hooks/pre-commit
```


### Contributors

Ken Leidal <ken@poshdevelopment.com>
