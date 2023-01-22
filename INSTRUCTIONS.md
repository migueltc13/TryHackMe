# Instructions to use this repository:

### 1. Fork this repository to your own GitHub account by clicking the "Fork" button in the top right corner

<br>

### 2. Clone the forked repository to your local machine

By running the following command after replacing your username:

```
git clone https://github.com/YOUR_USERNAME/TryHackMe
```

<br>

### 3. To start tracking your progress, you can use this command to clear the rooms list:

```
sed -i 's/\[x\]/\[ \]/g' README.md
```

This command will replace '[x]' with '[ ]' in the README.md file.

<br>

### 4. Keep track of which rooms you have complete

By replacing '[ ]' with '[x]' in the README.md file for each room you complete.

<br>

### 5. [Optional] Optimize your progress tracking with rooms in progress or stopped

You can use emojis inside the square brackets. For example:

- '[⏳]' for rooms in progress
- '[🔴]' for rooms stopped (depends on other tasks, depends on knowledge from other rooms)

<br>

### 6. Make any changes you want and push them back to your forked repo

By using the following commands:

```
git add .
git commit -m "Your commit message"
git push origin master
```

<br>

### 7. You can sync your forked repo with the upstream repo with:

```
git remote add upstream https://github.com/migueltc13/TryHackMe
git pull upstream master
```
