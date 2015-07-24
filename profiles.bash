PROFILES_DIR="$HOME/.aws/profiles.d"
CREDENTIALS="$HOME/.aws/credentials"

aws-profile() {
  local profile="$1"

  if [[ -z $profile ]]; then
    __aws-profile-usage >&2
  else
    __aws-switch-profile $profile
  fi
}

__aws-profile-usage() {
  echo "usage: aws-profile <profile>

Available profiles:
$(for profile in $(__aws-ls-profiles | sort); do
    if [[ $profile == $(__aws-active-profile) ]]; then
      echo -n " * "
    else
      echo -n " - "
    fi
    echo $profile
  done)"
}

__aws-active-profile() {
  if [[ -e "$CREDENTIALS" ]]; then
    basename $(readlink "$CREDENTIALS")
  fi
}

__aws-switch-profile() {
  local profile_name="$1"
  local profile_credentials="$PROFILES_DIR/$profile_name"

  if [[ ! -f "$profile_credentials" ]]; then
    echo "profile $profile_name not found" >&2
    return 1
  fi

  ln -fhs "$profile_credentials" "$CREDENTIALS"
  __aws-set-env-from-profile

  echo "profile $profile_name activated"
}

__aws-set-env-from-profile() {
  export AWS_ACCESS_KEY_ID=$(__aws-read-credential "AWSAccessKeyId")
  export AWS_SECRET_ACCESS_KEY=$(__aws-read-credential "AWSSecretKey")
}

__aws-read-credential() {
  local credential_name="$1"
  local credential=$(grep -E "^${credential_name}=" "$CREDENTIALS" | cut -d= -f2)
  if [[ -z "$credential" ]]; then
    echo "unable to read $credential_name from $CREDENTIALS" >&2
    return 1
  fi
  echo "$credential"
}

__aws-ls-profiles() {
  ls -1 "$PROFILES_DIR" | xargs -n1 basename
}

__aws-profile-completion() {
  local input="${COMP_WORDS[COMP_CWORD]}"
  local candidates="$(__aws-ls-profiles | sort)"
  COMPREPLY=($(compgen -W "$candidates" -- $input))
}

complete -F __aws-profile-completion aws-profile

__aws-set-env-from-profile
