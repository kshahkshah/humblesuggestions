# Humble Suggestions #

## Set up ##

roughly, on OS X.

### source, dependency, & code management tools ###

If you don't have homebrew ( https://github.com/mxcl/homebrew ) get it.

If you do, run `brew update`. If it has been a while you may need to update your git first `brew update git`.

Ensure you have at least git 1.8. with `git --version`

Also, now `brew install postgres` to install postgresql. I'm using postgres instead of mysql since I'm planning on putting this up onto postgres only compatible Heroku.

Note - you are however free to use mysql locally if you do not want to run pg. Just change your adapter in database.yml. Let me know if you do so I can remove database.yml from source control so we can maintain separate copies of it.

If you do install postgres make sure to follow the post-installation instructions.

Another unnecessary dependency is the gnu scientific library for statistics calculations which I am in all earnesty not doing yet but am expecting too. I'm happy to shed the dependency if it becomes a problem but try installing gsl first with:

`brew install gsl`

Install the latest ruby 1.9.3 with rvm or rbenv as you prefer.

rvm is the ruby version manager and is my preferred way of managing and installing versions of ruby.

`rvm install 1.9.3`.

Follow all directions rvm gives you.

when you run `ruby --version` you should see 1.9.3 as your current. If not, you haven't set your default ruby to 1.9.3.

Run `rvm --default 1.9.3` to set that as your default, I believe that is the correct command.

Finally make sure the rubygem bundler is installed. `gem install bundler`


### setting up the application ###

Okay, you can `git checkout git@github.com:whistlerbrk/humblesuggestions.git` now, into whatever directory you'd like.

`cd` into that directory and run `bundle install` to install all the gems (json, rails, resque, pg)

Hopefully that ran without incident, if you did have a problem with gsl there then maybe just comment it out in the Gemfile.

If you had a problem with postgres, maybe switch over to mysql as I mention above. It's not worth spending time on.

From there create the database with `rake db:create` and load the schema in one shot with `rake db:schema:load`.

Start the server `rails s` and navigate to localhost:3000 in your browser and you should be good to go.

I think you've worked in a rails app before so this final section is a bit sparse. I can solve any environmental problems you're having when I see you next.

Otherwise css is scss here and is found in `./app/assets/` and the layout and other views are in `./app/views/`

