if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g fish_key_bindings fish_vi_key_bindings

    # Activate mise
    mise activate fish | source

    source_google_fish_package pastebin

    fzf_configure_bindings --directory=ctrl-f
end

function fish_user_key_bindings
  bind --mode insert ctrl-a beginning-of-line
  bind --mode insert ctrl-e end-of-line
end
