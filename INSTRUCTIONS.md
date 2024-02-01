# Instructions to use this repository:

### 1. Fork this repository to your own GitHub account

### 2. Clone the forked repository to your local machine

By running the following command after replacing your username:

```sh
git clone https://github.com/YOUR_USERNAME/TryHackMe
```

### 3. To start tracking your progress, you can use this command to clear the rooms list:

```sh
sed -i 's/☑/☐/g' README.md
```

This command will replace '☑' with '☐' in the `README.md` file.

### 4. Keep track of which rooms you have completed

Mark completed rooms with '☑' in the `README.md` file.

### 5. [Optional] Optimize your progress tracking with rooms in progress or stopped

You can use emojis inside the `Status` column, for example:

- '⏳' for rooms in progress
- '🔴' for rooms stopped (depends on other tasks, depends on knowledge from other rooms)

### 6. Make any changes you want and push them to your forked repo

By using the following commands:

```sh
git add .
git commit -m "Your commit message"
git push origin main
```

### 7. You can sync your forked repo with the upstream repo with:

```sh
# Stash your changes if you have any
git stash

# Add the upstream repo
git remote add upstream https://github.com/migueltc13/TryHackMe

# Pull the changes from the upstream repo
git pull upstream main

# Recover your stashed files if you have any
git stash pop
```
