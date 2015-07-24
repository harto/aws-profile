# aws-profile

Rudimentary AWS profile management as described in [Ghetto AWS profile switcher](https://harto.org/blog/2015-02-22-ghetto-aws-profile-switcher/).

If you're on OS X, you should probably use [`aws-keychain`](https://github.com/pda/aws-keychain) instead ;-)


## Installation

    $ git clone https://github.com/harto/aws-profile.git ~/.aws
    $ echo "source ~/.aws/profiles.bash" >> ~/.bash_profile # or similar
    
    
## Usage

 - Create profiles in `~/.aws/profiles.d`, e.g.:
   ```
   $ cat >~/.aws/profiles.d/work
   [Credentials]
   AWSAccessKeyId=ABCDEFGHIJKLMNOP
   AWSSecretKey=abcdefghijklmnop
   ^D
   ```
   
 - Switch between profiles like this:
   ```
   $ aws-profile work
   ```
