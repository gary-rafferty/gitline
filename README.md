#GitLine

Aggregates and displays your GitHub activity on your Facebook timeline.

WIP, but the general flow of things is 

1. User authenticates the application using the JavaScript SDK
2. User then enters the link to their repository, in short form e.g 'gary-rafferty/gitline'
4. Applications provides the user with a post-receive url for GitHub
5. When post-receive payloads are received, the system will then publish to Facebook timeline

![GitBook
screeny](https://raw.github.com/gary-rafferty/gitline/master/public/images/GitBook.png)


##Dev
Most of the bootstrap tasks are in the Rakefile.

To start the server

```
rake server
```

To start the Saas to CSS watcher/compiler

```
rake watch
```

To index MongoDB

```
rake index
```

To run the test suite

```
rake test
```

To truncate MongoDB

```
rake truncate
``` 

To send a sample payload to a repository

```
# rake payload[REPO_ID]

rake payload[50fdbac236974c8983000001]
```

NB: ZSH users, like me, need to modify the call like this

```
rake 'payload[50fdbac236974c8983000001]'
```

To send a sample payload to a repository on the Heroku server

```
rake 'heroku_payload[50fdbac236974c8983000001]'
```
