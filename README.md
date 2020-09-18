# Git Story
Git Story helps in making appending a story id to commit message.
Most project management tools like pivotal tracker, devstack have story ids to the task you are working on.
It's highly helpful when these story ids can be tracked in you git commits as well.

But, it's annoying to add the story id to commit message every time.
Git-Story make this process simpler.

## Usage
- Adding story id
  ```
  git story "#some-id"
  ```
  Now whenever you commit with a message it is prepended with a story-id
  ```
  git commit -m "some message"
  ```
  
  the resulting commit message loooks as follows
  ```
  [#some-id] some message
  ```

- Unset story id 
  ```
  git story --unset
  ```

- display the set story id
  ```
  git story
  ```

## Installation

```git clone repo
cd git-story
sh ./install.sh
```

## Uninstallation

```
git clone repo
cd git-story
sh ./uninstall.sh 
```
## Running test

```
bats test/integration.bats
```
Note if it does not work run as super user.
## Tested platforms

Currently, still in beta state so tested only on MacOS
