# batch_rename
A simple command make linux or macos do things like "rename *.mp3 *.mp4" in Windows/MSDOS


Do you remember the convenient command `rn' in MSDOS ?
When you want to change all your .mp3 files to .mp4
Simply type "rn *.mp3 *.mp4."
I really like this.
But in linux/Mac world, people keep asking how.(http://bit.ly/2cIskUu)
So maybe this little tool can help you a lot. remember QUOTE NEEDED.

# Install:
  - sudo apt-get install cabal-install
  - cabal update
  - cabal install batch-rename

# Usage:
  - batch_rename "\*.mp3" "\*.mp4"
  - batch_rename "\*.mp3" "fake\*.mp4"
  - batch_rename "DCIM\*.jpg" "\*.png"
