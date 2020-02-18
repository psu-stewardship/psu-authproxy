# README


Local Setup:

# Start up psu-authproxy
```
docker-compose up --build -d
```

# Configure psu-authproxy
Use a plugin to modify your request headers, and set REMOTE_USER to be your psu userid
I use (https://bewisse.com/modheader/) with firefox

- log into http://localhost:3001/oauth/applications
- Click "New Application"
- Name: myradapp
- Redirect URI: callbackurl for your app
- Confidential: yes
- Scopes: public

Once created set the following environment variables in your app
* OAUTH_APP_ID
* OAUTH_APP_URL
* OAUTH_APP_SECRET

# Shut it down!

```
docker-compose down
```

# Machine Users
Machine Users have access to the API, they currently use basic auth on the api endpoints, and are manually created via the rails console 

To create a machine user with the username "robot" and password "foobar" you would do the following in a rails console

```
u = User.create(username: "robot", password: "foobar", is_admin: true)

u.save
```
