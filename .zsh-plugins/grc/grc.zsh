if [[ "$TERM" != dumb ]] && (( $+commands[grc] )) ; then
  # Prevent grc aliases from overriding zsh completions.
  setopt COMPLETE_ALIASES

  # Supported commands
  cmds=(
    ping \
    ping6 \
    traceroute \
    traceroute6 \
    gc \
    gcc \
    make \
    netstat \
    stat \
    ss \
    diff \
    wdiff \
    last \
    who \
    ldap \
    mount \
    findmnt \
    mtr \
    ps \
    dif \
    ifconfig \
    mount \
    df \
    du \
    ip \
    env \
    systemctl \
    iptables \
    lspci \
    lsblk \
    lsof \
    blkid \
    id \
    iostat \
    sar \
    fdisk \
    free \
    findmnt \
    docker \
    journalctl \
    systemctl \
    sysctl \
    tcpdump \
    tune2fs \
    lsmod \
    lsattr \
    semanage \
    getsebool \
    ulimit \
    vmstat \
    dnf \
    nmap \
    uptime \
    getfacl \
    showmount \
    ant \
    mvn \
  );

  # Set alias for available commands.
  for cmd in $cmds ; do
    if (( $+commands[$cmd] )) ; then
      alias $cmd="grc --colour=auto $cmd"
    fi
  done

  # Clean up variables
  unset cmds cmd
fi
