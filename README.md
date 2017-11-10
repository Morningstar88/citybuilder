
# Citybuilder
## Regenerating Neighbourhoods.

Hey! Welcome to Citybuilder open-source project.

City-builder helps people **build useful projects** in their neighbourhoods.

- Hydroponic gardens
- Solar arrays
- Low-tech vertical farms
- Pico-wind turbines
- Organic cafes
- Food-forests
- Longevity research.
- ... and anything else we can imagine.

We help people build prototypes of their dreams.

## Project Display

The main page displays projects and a news feed.

http://citybuilder.microflow.io/

## Country Specific Project Display

http://citybuilder.microflow.io/india





----

## Setting Up Elixir + Phoenix

### Installing Elixir

https://elixir-lang.org/install.html

### Installing Phoenix

http://www.phoenixframework.org/docs/installation

This worked for me on Cloud9:

https://medium.com/@Oxyrus/how-to-install-the-phoenix-framework-on-cloud9-ef0ac265229c

## Citybuilder runs on Port 8080, please don't change that.

Any problems ask us in www.reddit.com/r/CityBuilderDev

----

### City Builder Installation Instructions

To start your Phoenix server:

- Install dependencies with mix deps.get
- Create and migrate your database with mix ecto.create && mix ecto.migrate
- start the database: sudo service postgresql start
- Install Node.js dependencies with cd assets && npm install
- Start Phoenix endpoint with mix phx.server
- Now you can visit localhost:8080 from your browser.

Ready to run in production? Please check our deployment guides.

##### Windows Installation Instructions

1. Install Elixir (download link and instructions [here](https://elixir-lang.org/install.html#windows))
2. Open a command line window, and enter the following commands (give Y for prompts)
  * `mix local.hex`
  * `mix archive.install` https://github.com/phoenixframework/archives/raw/master/phx_new.ez
3. Install [Build Tools for Visual Studio](https://www.visualstudio.com/downloads/#build-tools-for-visual-studio-2017)
4. Fork/Clone/Download this repo onto your local machine
5. Open a command line window
6. In the command line window, navigate to the Visual Studio directory containing the file `vcvarsall.bat`.  
This can vary based on the version of Visual Studio, mine was found at `C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build`
7. Run the command: `vcvarsall.bat amd64`
8. In the same command line window, navigate to the project directory
9. Enter the following commands
  * `mix deps.get`
  * `mix ecto.create && mix ecto.migrate`  
  If that command gives an error, step 6 may not have worked for you. Alternatively, the postgres server (which should have been installed with step 2) may not have started correctly. In that case, check that the service is running:
    * Open a run prompt with `Windows + R`
    * Search for a variation of `postgressql-x64-10` in the list and start the service  
    If it is still not working, the database user / pass you set when given the choice during setup may be different. Open the file `config\dev.exs` in the project folder and alter the user / pass found here to match what you set
    ```
    # Configure your database
    config :citybuilder, Citybuilder.Repo,
    adapter: Ecto.Adapters.Postgres,
    types: Citybuilder.PostgrexTypes,
    username: "postgres",
    password: "postgres",
    database: "citybuilder_dev",
    hostname: "localhost",
    template: "template0",
    pool_size: 10
    ```
    After that, restart the postgres service.
  * `cd assets && npm install`
  * `cd .. && mix phx.server`
10. And you should be good to go! Check the server is running by visiting `localhost:8080` in your browser

### Learn more

- Official website: http://www.phoenixframework.org/
- Guides: http://phoenixframework.org/docs/overview
- Docs: https://hexdocs.pm/phoenix
- Mailing list: http://groups.google.com/group/phoenix-talk
- Source: https://github.com/phoenixframework/phoenix

----

## Early Stages: Messy CSS + Confused Media Queries

If you're coming in the early stages, expect messy CSS, screwed up grid systems, hacky media queries, redundant code, and other problems. Plz enjoy the ride, deal with minor hassles, + accept it's an early stage project.

Ultimately City-builder has to look like Kickstarter or StartSomeGood, but volunteer focused instead of money oriented.

https://www.kickstarter.com
https://www.startsomegood.com/
---

## Communication

Reddit + Github Issues:

We're communicating on Reddit + Github issues for now. It keeps communication simple and open. We don't use Slack. It looks pretty, but it runs slowly on some computers + archiving can be a hassle. If you want to open an IRC or Discord, go ahead, but please confine official communication to Reddit and Github issues, so no one gets lost.  

www.reddit.com/r/CityBuilderDev

----

## 3 Issues / Labels for Contributors: Elixir, CSS + JS.

If you're here from Reddit or Elixir Slack, you can focus on three labels:

- #### Buggy CSS - for quirks in the CSS that need to be fixed.

- #### Buggy JS - Any JS/JQuery bugs that need fixing.  

- #### Elixir Bug - A general label for problems and fixes with the backend code.

----

- #### New Front End Feature - is a general label for UI/UX improvements, and roadmap tweaks. If you're coming here to help with the Elixir/backend and JS bugs, you can ignore the Front End labels.

----

## Location of Main CSS/HTML files

### Check 'Citybuilder/lib/citybuilder/web/templates/'

for most of the files you need.

### If you're on the front end, you will mainly be working with the title/index page:

https://github.com/Microflow/citybuilder/blob/master/lib/citybuilder/web/templates/post/index.html.eex

### and the project display page:

https://github.com/Microflow/citybuilder/blob/master/lib/citybuilder/web/templates/post/show.html.eex

### Project Upload Form is Here

https://github.com/Microflow/citybuilder/blob/master/lib/citybuilder/web/templates/post/form.html.eex

### Main CSS file is here:

https://github.com/Microflow/citybuilder/blob/master/assets/css/app.css



----

## Collaboration Strategy

As issues come up, we'll post them in CityBuilderDev subreddit or other forums. If you see an interesting issue, go ahead and try to fix it.

## Design + Coding Strategy.

We want to keep the coding as simple as possible. Please use the oldest libraries that you can.

No need for React, Angular, or any front end framework right now. We're happy with vanilla JS. Check out this essay on React + Phoenix, we agree with their conclusions:

https://robots.thoughtbot.com/how-we-replaced-react-with-phoenix

## Micro-Merges instead of Monster-Merges

If you're working on something, try and make small incremental merges. This helps the codebase stay up to date and fresh. If you spend 3 days on a massive fix, you might find that the codebase has moved ahead, and we'll have problems integrating your code.

----

## Understanding The Codebase

Up til now this has been a two man project. To understand the Elixir, read commits from DenisPeplin. To look at the CSS, check out commits from Microflow/mikeflow. The CSS is buggy + unprofessional, we welcome any help cleaning it up. It's littered with !importants and other bad practices. If you're new to Elixir, you can get a good idea of the entire codebase by going slowly through Denis' commits.

Any questions please ask on Reddit. As this is a side project, we've sometimes cut corners and employed hacky fixes.

#### If you want to read the Elixir commits, type:

git log --author="denispeplin" --oneline

or

git log --author="denispeplin" | more

#### Earlier commits come from

git log --author="Ayomide Aregbede" --oneline

#### List all authors:

git log --format='%aN' | sort -u
----



## The Type of Projects We Support

### Videos

If you want to add some videos, please go ahead.

## [Food Forest](https://www.youtube.com/watch?v=4qvr8fLLgGQ)

## [Vertical Gardens](https://www.youtube.com/watch?v=BL_2HRzjbl8)

## [Printable Solar Panels](https://www.youtube.com/watch?v=gMuL38fOK0A)

*Move Slowly and Fix Things*
