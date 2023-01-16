# Instructions for using this repository

### 1. Fork this repository to your own Github account by clicking the "Fork" button in the top right corner.

### 2. Clone the forked repository to your local machine.

By running the following command after replacing YOUR_USERNAME:

```
git clone https://github.com/YOUR_USERNAME/TryHackMe
```

### 3. To start tracking your progress, you can use the shell command to clear the completed rooms from the list.

By running the following command:

```
sed -i 's/\[x\]/\[ \]/g' README.md
```

This command will replace '[x]' with '[ ]' in the README.md file.

### 4. Keep track of which rooms you have completed.

By replacing '[ ]' with '[x]' in README.md file for each room you completed.

### 5. (optional) To better track your progress with rooms in progress / stopped.

You can use emojis inside the square brackets. For example:

- '[⏳]' for rooms in progress
- '[🔴]' for rooms stopped (depends on other tasks, depends on knowledge from other rooms)

### 6. Make any changes you want and push them back to your forked repository using the following commands:

```
git add .
git commit -m "Your commit message"
git push origin master
```

### 7. You can always sync your forked repo with the upstream repo by running the following commands:

```
git remote add upstream https://github.com/migueltc13/TryHackMe
git pull upstream master
```
