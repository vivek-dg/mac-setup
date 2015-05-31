# mac-setup
Setting up my dev programs on mac


I've already installed a few apps and programs on my mac. This is just some notes on it

* Terminal - leave as is. Have light background since it is better for your eyes
* Firefox - or your favorite browser
* XCode from AppStore
* Homebrew! - definitely a must have for easy installs
  - brew install maven
  - brew install scala
    * brew install sbt
  - brew install git
  - brew install ruby - NOOOO. Ruby needs to be installed through rvm / rbenv
  - brew install heroku-toolbelt
    * brew upgrade heroku-toolbelt
  - Finally say 'brew list' to list all packages installed by brew!
* Java sdk from Oracle
* STS from spring for Java
* IntelliJ Community Edition for Scala


# Projects and development folder
I've created simple folder called 'dev' in my ~/Documents directory. Inside this I have further categories folder such as '~/Documents/dev/workspace' as a container workspace for all my java, ruby and scala code. Also created '~/Documents/dev/iOS' for all iOS related code. That way XCode and STS can have their own workspaces. We can create other workspaces later as well.

Sometimes I try out newer version of Eclipse and sometimes other programs which come in a zipped format. Those I put under the '~Documents/dev/programs' folder. That way it is all grouped in a single place.

When I need to shift my mac to a new machine, I know my documents folder is automatically transferred by default! Don't have to do any custom folder copies or think I've missed something.
