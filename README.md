# The current state

Having started this task late because of my other school commitments, it took me more time than I expected and it's left in semi-broken state, unfortunately.
What went wrong are two main things:

1) Right now, on Google Cloud deployment, when done via my script, frontend (http://35.228.234.122:8000/) simply doesn't see backend. I did manage to get it working when deploying via GUI, but not via script.
2) Ansible playbook breaks at the last stage, which is connecting to Docker.

## Writeup

Notes I was taking while working on this:

1) Frontend initially didn't ran for me on my local machine due to version of Node.js I was running, 21.7.
Worth considering if I could run automatical updates? 
Upon running frontend, I got console error that weather.icon was undefined. I decided to start small, just with fixing styling errors that eslint was complaining about. (Then I realised, that no, this means it can't connect to backend)
I also created .gitignore with node_modules.
Then, I created .env files to test the app out. Just as my first step to see how it works, I removed hardcoded values and left it in those files. While we were at it, in backend, I added .env to gitignore and
created .env.example w/o API key. Also I had to add dotenv to backend; React reads it automatically, Node.js does not. 
Having that done, it was perfect time to dockerize this. I wrote Dockerfiles + docker-compose, and this wasn't really anything eventful to speak about. (At that time I wanted to add Nginx to frontend as I used it for my uni, but... I had trouble getting it to work with React. With Vue it worked out of the box, with React it appeared that it didn't, and I didn't felt it was worth spending more time thinking about)
For deployment in cloud, I'll go with Google Cloud as I don't like AWS pricing. Azure could work too, I have access to it via uni, so let's try Google for once.


# Weatherapp

There was a beautiful idea of building an app that would show the upcoming weather. The developers wrote a nice backend and a frontend following the latest principles and - to be honest - bells and whistles. However, the developers did not remember to add any information about the infrastructure or even setup instructions in the source code.
Luckily we now have [docker compose](https://docs.docker.com/compose/) saving us from installing the tools on our computer, and making sure the app looks (and is) the same in development and in production. All we need is someone to add the few missing files!

The idea of the exercise is to improve the bare-bone piece of code (i.e. the weatherapp) and ensure there's adequate infrastructure around it. 
In real life scenario we might suggest to our customers to leverage cloud services to just run code in a serverless fashion - but that would make it difficult to evaluate technical skills - and that's the whole point of this exercise, ain't it? 


## Returning your solution via Github
Use Github to work on the solution and hand it in. Don't forget to update the README file to make it clear what did you concentrate on.

* Make a copy of this repository in your own Github account (do not fork unless you really want to be public).
* Create a personal repository in Github.
* Make changes, commit them, and push them in your own repository.
* Send us the url where to find the code.

## Exercises

Here are some suggestions in different categories that you can do to make the app better. Before starting you need to get yourself an API key to make queries in the [openweathermap](http://openweathermap.org/). You can run the app locally using `npm i && npm start`.
Remember, this is not a test for a developer position, so we're not after extensive changes in javascript code. Rather, we'd like to see you be able to work comfortably with containers, VMs in cloud and ideally, Ansible.

### Docker

* Add **Dockerfile**'s in the *frontend* and the *backend* directories to run them virtually on any environment having [docker](https://www.docker.com/) installed. It should work by saying e.g. `docker build -t weatherapp_backend . && docker run --rm -i -p 9000:9000 --name weatherapp_backend -t weatherapp_backend`. If it doesn't, remember to check your api key first.

* Add a **docker-compose.yml** -file connecting the frontend and the backend, enabling running the app in a connected set of containers.

* The developers are still keen to run the app and its pipeline on their own computers. Share the development files for the container by using volumes, and make sure the containers are started with a command enabling hot reload.

### Cloud hosting

* Set up the weather service in a free cloud hosting service, e.g. [Azure](https://azure.microsoft.com/en-us/free/), [AWS](https://aws.amazon.com/free/) or [Google Cloud](https://cloud.google.com/free/).
* Enable external access to weather app via HTTP reverse proxy. We suggest creating one compute instance e.g. for AWS one EC2 instance, that will host both weather app and before mentioned proxy. Remember that Weather App should be exposed in a secure way.
* Enable external SSH access and add id_rsa_internship.pub key, which you can find in this repository. We would like to check your work so grant us admin rights on your test system.

### Ansible

* Write [Ansible](http://docs.ansible.com/ansible/intro.html) playbooks for installing [docker](https://www.docker.com/) and the app itself. These playbooks should work both for local and cloud environment.

#### Terraform

* Write [Terraform](https://www.terraform.io/) configuration files to set up infrastructure required to run the app in the cloud provider of your choice.

### Documentation

* Remember to update the README

* Use descriptive names and add comments in the code when necessary

### ProTips

* The app must be ready to deploy and work flawlessly.

* Detailed instructions to run the app should be included in your forked version because a customer would expect detailed instructions also.

* Extra points for making sure the app could be deployed with as few manual steps as possible.

* Feel free to add would-be-nice-to-haves in the app / infra setup that you didn't have time to complete as possible further improvements in README.
