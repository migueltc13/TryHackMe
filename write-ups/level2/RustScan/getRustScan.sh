# Copy this alias to your .bashrc or .zshrc file to run rustscan from the command line
alias rustscan='docker run -it --rm --name rustscan rustscan/rustscan:2.1.1' # may require sudo privileges

# Usage example: rustscan -a 192.168.1.0/24 -t 500 -b 1500 -- -A
